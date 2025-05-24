//
//  NetworkMonitor.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 17..
//

import Foundation
import Reachability
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
    
    private let reachability: Reachability
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    
    init() {
        guard let reachability = try? Reachability() else {
            fatalError("Failed to initialize Reachability")
        }
        
        self.reachability = reachability
        
        reachability.whenReachable = { [weak self] reachability in
            let available = reachability.connection != .unavailable
            self?.isConnectedSubject.send(available)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.isConnectedSubject.send(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
