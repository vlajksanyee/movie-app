//
//  SearchViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var mediaItems: [MediaItem] { get set }
    var searchText: String { get set }
}

class SearchViewModel: SearchViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [MediaItem] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    
    let startSearch = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        startSearch
            .print("<<< startSearch")
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .flatMap { [weak self] _ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = SearchMediaRequest(query: self.searchText)
                return Environments.name == .tv ?
                self.repository.searchTV(req: request) :
                self.repository.searchMovie(req: request)
            }
            .sink { [weak self] completion in
                print("<<< Completion: \(completion)")
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItems in
                print("<<< Received movies: \(mediaItems.count)")
                self?.mediaItems = mediaItems
            }
            .store(in: &cancellables)
    }
}
