//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 24..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        //        do {
        //            let request = FetchGenreRequest()
        //            let genres = Environment.name == .tv ?
        //            try await movieService.fetchTVGenres(req: request) :
        //            try await movieService.fetchGenres(req: request)
        //            DispatchQueue.main.async {
        //                self.genres = genres
        //            }
        //        } catch let error as MovieError {
        //            DispatchQueue.main.async {
        //                self.alertModel = self.toAlertModel(error)
        //            }
        //        } catch {
        //            print("Error fetching genres: \(error)")
        //        }
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
    
    init() {
        let request = FetchGenreRequest()
        let future = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchGenres(req: request)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        let requestTV = FetchTVGenreRequest()
        let futureTV = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchTVGenres(req: requestTV)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        Publishers.CombineLatest(future, futureTV)
//        future
//            .flatMap({ genres in
//                futureTV.map { genresTV -> ([Genre], [Genre]) in
//                    (genres, genresTV)
//                }
//            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]genres, genresTV in
                self?.genres = genres + genresTV
            }
            .store(in: &cancellables)
    }
    
//    init() {
//            let request = FetchGenreRequest()
//            
//            let publisher = PassthroughSubject<[Genre], Error>()
//
//            Task {
//                do {
//                    let genres = try await self.movieService.fetchTVGenres(req: request)
//                    publisher.send(genres)
//                    publisher.send(completion: .finished) // FONTOS: befejezés
//                } catch {
//                    publisher.send(completion: .failure(error)) // Hiba küldése
//                }
//            }
//            
//            publisher
//                .receive(on: RunLoop.main)
//                .sink { completion in
//                    switch completion {
//                    case .failure(let error):
//                        self.alertModel = self.toAlertModel(error)
//                    case .finished:
//                        break
//                    }
//                } receiveValue: { genres in
//                    self.genres = genres
//                }
//                .store(in: &cancellables)
//        }
}
