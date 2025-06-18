//
//  MediaDetailsViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 08..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol MediaDetailsViewModelProtocol: ObservableObject {
}

class MediaDetailsViewModel: MediaDetailsViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var credits: [CastMember] = []
    @Published var isFavorite: Bool = false
    @Published var reviews: [MediaReview] = []
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let mediaItemIdSubject = mediaItemIdSubject.share()
        
        let details = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailsRequest(mediaId: mediaItemId)
                return self.repository.fetchDetails(req: request)
            }
        
        let credits = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaCreditsRequest(mediaId: mediaItemId)
                return self.repository.fetchCredits(req: request)
            }
        
        let reviews = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchReviewsRequest(mediaId: mediaItemId)
                return self.repository.fetchReviews(req: request)
            }
        
        Publishers.CombineLatest3(details, credits, reviews)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits, reviews in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.reviews = reviews.prefix(4).map { $0 }
                self.isFavorite = self.mediaItemStore.isMediaItemStored(withId: details.id)
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavorite)
                return repository.editFavoriteMovie(req: request)
                    .map { result in
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
                        self.mediaItemStore.saveMediaItems([MediaItem(detail: self.mediaItemDetail)])
                    } else {
                        self.mediaItemStore.deleteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
