//
//  ReviewStore.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 07. 05..
//

import RealmSwift
import Combine

protocol ReviewStoreProtocol {
    func getReviews(fromMediaId mediaId: Int) -> AnyPublisher<[MediaReview], MovieError>
    func saveReviews(_ items: [MediaReview], forMediaId mediaId: Int)
    func deleteReviews(forMediaId mediaId: Int)
    func deleteAll()
}

class ReviewStore: ReviewStoreProtocol {
    private let realm: Realm
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }
    
    func getReviews(fromMediaId mediaId: Int) -> AnyPublisher<[MediaReview], MovieError> {
        let results = realm.objects(MediaItemReviewEntity.self)
            .where {
                $0.mediaId == mediaId
            }
        let reviews = results.map { $0.toDomain }
        return Just(Array(reviews))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
    
    func saveReviews(_ items: [MediaReview], forMediaId mediaId: Int) {
        let entities = items.map { review in
            let entity = MediaItemReviewEntity(from: review, mediaId: mediaId)
            return entity
        }
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }
    
    func deleteReviews(forMediaId mediaId: Int) {
        do {
            let items = realm.objects(CastMemberEntity.self)
                .where {
                    $0.mediaId == mediaId
                }
            try realm.write {
                realm.delete(items)
            }
        } catch {
            print("Failed to delete cast members for movie \(mediaId): \(error)")
        }
    }
    
    func deleteAll() {
        let all = realm.objects(CastMemberEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}

