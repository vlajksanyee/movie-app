//
//  ServiceAssembly.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 15..
//

import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            let configuration = URLSessionConfiguration.ephemeral
            configuration.headers = .default
            
            return MoyaProvider<MultiTarget>(
                session: Session(configuration: configuration,
                                 startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin(
                        configuration: NetworkLoggerPlugin.Configuration(
                            output: { _, items in
                                items.forEach { item in
                                    print("Response \(item)")
                                }
                            },
                            logOptions: [.verbose, .requestBody]
                        )
                    )
                ])
        }.inObjectScope(.container)
        
        container.register(ReactiveMoviesServiceProtocol.self) { _ in
            return ReactiveMoviesService()
        }.inObjectScope(.container)
        
        container.register(MediaItemStoreProtocol.self) { _ in
            return MediaItemStore()
        }.inObjectScope(.container)
        
        container.register(MediaItemDetailStoreProtocol.self) { _ in
            return MediaItemDetailStore()
        }.inObjectScope(.container)
        
        container.register(CastMemberStoreProtocol.self) { _ in
            return CastMemberStore()
        }.inObjectScope(.container)
        
        container.register(NetworkMonitorProtocol.self) { _ in
            return NetworkMonitor()
        }.inObjectScope(.container)
    }
}
