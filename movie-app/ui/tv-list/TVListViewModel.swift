//
//  TVListViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 02..
//

import Foundation
import InjectPropertyWrapper

protocol TVListViewModelProtocol: ObservableObject {
    var tv: [TV] { get }
    func loadTV(by genreId: Int) async
}

class TVListViewModel: TVListViewModelProtocol, ErrorViewModelProtocol {
    @Published var tv: [TV] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func loadTV(by genreId: Int) async {
        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let tv = try await service.fetchTV(req: request)
            DispatchQueue.main.async {
                self.tv = tv
            }
        } catch {
            print("Error fetching TV: \(error)")
        }
    }
}

