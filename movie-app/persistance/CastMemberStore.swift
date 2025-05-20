//
//  CastMemberStore.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 20..
//

import RealmSwift
import Combine

protocol CastMemberStoreProtocol {
    func getCastMembers(fromMediaId mediaId: Int) -> AnyPublisher<[CastMember], MovieError>
    func saveCastMembers(_ items: [CastMember], forMediaId mediaId: Int)
    func deleteCastMembers(forMediaId mediaId: Int)
    func deleteAll()
}

class CastMemberStore: CastMemberStoreProtocol {
    private let realm: Realm
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }
    
    func getCastMembers(fromMediaId mediaId: Int) -> AnyPublisher<[CastMember], MovieError> {
        let results = realm.objects(CastMemberEntity.self)
            .where {
                $0.mediaId == mediaId
            }
        let castMembers = results.map { $0.toDomain }
        return Just(Array(castMembers))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
    
    func saveCastMembers(_ items: [CastMember], forMediaId mediaId: Int) {
        let entities = items.map { cast in
            let entity = CastMemberEntity(from: cast, mediaId: mediaId)
            return entity
        }
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }
    
    func deleteCastMembers(forMediaId mediaId: Int) {
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
