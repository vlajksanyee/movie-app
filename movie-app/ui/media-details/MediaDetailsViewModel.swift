//
//  MediaDetailsViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 08..
//

import Combine
import Foundation
import InjectPropertyWrapper

protocol MediaDetailsViewModelProtocol: ObservableObject {
    var media: DetailsResponse? { get }
}

class MediaDetailsViewModel: MediaDetailsViewModelProtocol, ErrorPresentable {
    @Published var media: DetailsResponse? = nil
    @Published var alertModel: AlertModel? = nil
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaIdSubject
            .flatMap { [weak self] mediaId -> AnyPublisher<DetailsResponse, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailsRequest(mediaId: mediaId)
                return self.service.fetchDetails(req: request)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self]media in
                self?.media = media
            }
            .store(in: &cancellables)
    }
}
