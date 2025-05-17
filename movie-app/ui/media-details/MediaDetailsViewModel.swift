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
    var media: MediaItemDetail { get }
}

class MediaDetailsViewModel: MediaDetailsViewModelProtocol, ErrorPresentable {
    @Published var media: MediaItemDetail = MediaItemDetail()
    @Published var credits: [CastMember] = []
    @Published var externalIds: ExternalIds = ExternalIds()
    @Published var alertModel: AlertModel? = nil
    @Published var isFavorite: Bool = false
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var favoriteMediaStore: FavoriteMediaStoreProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let details = mediaIdSubject
            .flatMap { [weak self] mediaId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailsRequest(mediaId: mediaId)
                return self.service.fetchDetails(req: request)
            }
        
        let credits = mediaIdSubject
            .flatMap { [weak self] mediaId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchCreditsRequest(mediaId: mediaId)
                return self.service.fetchCredits(req: request)
            }
        
        let externalIds = mediaIdSubject
            .flatMap { [weak self] mediaId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchExternalIdsRequest(mediaId: mediaId)
                return self.service.fetchExternalIds(req: request)
            }
        
        Publishers.CombineLatest3(details, credits, externalIds)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits, externalIds in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.media = details
                self.credits = credits
                self.externalIds = externalIds
                self.isFavorite = self.favoriteMediaStore.isFavoriteMediaItem(withId: details.id)
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(EditFavoriteResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.media.id, isFavorite: true)
                return service.editFavoriteMovie(req: request).map { result in
                    (result, isFavorite)
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavorite = isFavorite
                    if isFavorite {
                        self.favoriteMediaStore.addFavoriteMediaItem(self.media.asMedaiItem())
                    } else {
                        self.favoriteMediaStore.removeFavoriteMediaItem(withId: self.media.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
