//
//  AddReviewViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 20..
//

import Combine
import Foundation
import InjectPropertyWrapper

class AddReviewViewModel: ObservableObject, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = 1
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    let ratingButtonSubject = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        mediaDetailSubject
            .sink { [weak self] detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        
        ratingButtonSubject
            .flatMap { [weak self] _ -> AnyPublisher<ModifyMediaResult, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let rating: Double = Double(self.selectedRating)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, value: rating)
                
                return self.repository.addReview(req: request)
            }
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { result in
                
            })
            .store(in: &cancellables)
    }
}
