//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    func loadGenres()
    func genresAppeared()
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItemsByGenre: [Int: [MediaItem]] = [:]
    
    var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    
    
    init() {
        useCase.showAppearPopup
            .map { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "[[Rate the app]]", message: "[[Rate the app]]", dismissButtonTitle: "[[Ok]]")
                }
                return nil
            }
            .sink { [weak self] alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
    }
    
    func loadGenres() {
        useCase.loadGenres()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func loadMediaItems(genreId: Int) {
        useCase.loadMediaItems(genreId: genreId)
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .map({ mediaItemPage in
                Array(mediaItemPage.mediaItems.prefix(5))
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItems in
                self.mediaItemsByGenre[genreId] = mediaItems
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItemsByGenre(_ genreId: Int) -> [MediaItem] {
        return self.mediaItemsByGenre[genreId] ?? [MediaItem(id: -1), MediaItem(id: -6), MediaItem(id: -9999)]
    }
    
}
