//
//  CastDetailsViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 14..
//

import Foundation
import Combine
import InjectPropertyWrapper

enum CastDetailType {
    var id: Int {
        switch self {
        case .castMember(let id):
            return id
        case .company(let id):
            return id
        }
    }
    
    case castMember(id: Int)
    case company(id: Int)
}

class CastDetailViewModel: ObservableObject, ErrorPresentable {
    @Published var castDetail: CastDetail?
    @Published var alertModel: AlertModel? = nil
    @Published var rating: Int = 0
    
    var combined: [MediaItem] = []
    
    let castTypeSubject = PassthroughSubject<CastDetailType, Never>()
    
    let combinedCreditsSubject = PassthroughSubject<Int, MovieError>()
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        castTypeSubject
            .flatMap { [weak self] castType -> AnyPublisher<CastDetail, MovieError> in
                guard let self = self else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
                let request = FetchCastMemberDetailsRequest(castMemberId: castType.id)
                switch castType {
                case .castMember:
                    return self.repository.fetchCastMemberDetail(req: request)
                case .company:
                    return self.repository.fetchCompanyDetail(req: request)
                }
                
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }, receiveValue: { [weak self] castDetail in
                self?.castDetail = castDetail
                self?.rating = self?.calculateStarRating(for: castDetail.popularity) ?? 0
            })
            .store(in: &cancellables)
                
        combinedCreditsSubject
            .flatMap { [weak self] combinedCreditsId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
                let request = FetchCastMemberDetailsRequest(castMemberId: combinedCreditsId)
                return self.repository.fetchCombinedCredits(req: request)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] combinedCredits in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.combined = combinedCredits
            }
            .store(in: &cancellables)
    }
    
    private func calculateStarRating(for popularity: Double?) -> Int {
        guard let popularity = popularity else { return 0 }
        if popularity == 0 {
            return 0
        }
        
        let maxPopularity = 30.0
        let scaledPopularity = min(popularity, maxPopularity)
        
        let rating = (scaledPopularity / maxPopularity) * 4.0
        
        return Int(rating + 1.0)
    }
}
