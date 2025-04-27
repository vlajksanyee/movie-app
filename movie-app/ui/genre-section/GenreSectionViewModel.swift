//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import InjectPropertyWrapper

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ?
            try await movieService.fetchTVGenres(req: request) :
            try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch let error as MovieError {
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
    
    private func toAlertModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title", comment: ""),
                message: NSLocalizedString("unexpectederror.message", comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: NSLocalizedString("apierror.message", comment: ""),
                message: message,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title", comment: "")
            )
        case .clientError:
            return AlertModel(
                title: NSLocalizedString("clienterror.title", comment: ""),
                message: error.localizedDescription,
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
}
