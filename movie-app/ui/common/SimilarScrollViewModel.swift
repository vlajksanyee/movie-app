//
//  SimilarsScrollViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 21..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol SimilarScrollViewModelProtocol: ObservableObject {
    var similars: [MediaItem] { get }
}

class SimilarScrollViewModel: SimilarScrollViewModelProtocol, ErrorPresentable {
    @Published var similars: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Published var isLoading: Bool = false
    
    let similarsSubject = PassthroughSubject<Int, MovieError>()
    
    @Inject
    private var repository: MovieRepository
    
    var actualPage: Int = 0
    var totalPages: Int = 10
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        similarsSubject
            .filter { [weak self] _ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.actualPage < self.totalPages
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.actualPage += 1
                self.isLoading = true
            })
            .flatMap { [weak self] mediaItemId -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchSimilarsRequest(mediaId: mediaItemId, page: actualPage)
                return self.repository.fetchSimilars(req: request)
            }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] similars in
                self?.similars.append(contentsOf: similars.mediaItems)
            }
            .store(in: &cancellables)
    }
}
