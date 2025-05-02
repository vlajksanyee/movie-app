//
//  SearchViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [Movie] { get set }
    var searchText: String { get set }
    func searchMovies() async
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var service: MoviesServiceProtocol
    
    private func toAlertModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title", comment: ""),
                message: NSLocalizedString("unexpectederror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        }
        switch error {
        case .mappingError:
            return AlertModel(
                title: NSLocalizedString("mappingerror.title", comment: ""),
                message: NSLocalizedString("mappingerror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        default:
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title", comment: ""),
                message: NSLocalizedString("unexpectederror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        }
    }
    
    func searchMovies() async {
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }
        
        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
            print("Error searching movies: \(error)")
        }
    }
}
