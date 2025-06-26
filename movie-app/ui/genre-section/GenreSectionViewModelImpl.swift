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
    @Published var recommended: MediaItemDetail?
    
    var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    
    
    init() {
        useCase.showAppearPopup
            .map { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "rate.title".localized(), message: "rate.text".localized(), dismissButtonTitle: "rate.ok".localized())
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
            .map({ mediaItemPage in
                Array(mediaItemPage.mediaItems.prefix(5))
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItems in
                self.mediaItemsByGenre[genreId] = mediaItems
                
                if self.recommended == nil, let recommended = mediaItems.randomElement() {
                    self.loadRecommended(mediaItem: recommended)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadRecommended(mediaItem: MediaItem) {
        useCase.loadRecommended(mediaItem: mediaItem)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { recommended in
                self.recommended = recommended
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
