//
//  MoviesApi.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMediaListRequest)
    case fetchTV(req: FetchMediaListRequest)
    case searchMovies(req: SearchMovieRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMoviesRequest)
    case editFavoriteMovie(req: EditFavoriteRequest)
    case fetchDetails(req: FetchDetailsRequest)
    case fetchCredits(req: FetchCreditsRequest)
    case fetchExternalIds(req: FetchExternalIdsRequest)
    case addReview(req: AddReviewRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        let baseUrl = "https://api.themoviedb.org/3"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "/genre/movie/list"
        case .fetchTVGenres:
            return "/genre/tv/list"
        case .fetchMovies:
            return "/discover/movie"
        case .fetchTV:
            return "/discover/tv"
        case .searchMovies:
            return "/search/movie"
        case .fetchFavoriteMovies(let req):
            return "/account/\(req.account_id)/favorite/movies"
        case .editFavoriteMovie(req: let req):
            return "/account/\(req.account_id)/favorite"
        case .fetchDetails(req: let req):
            return Environments.name == .tv ?
            "/tv/\(req.mediaId)" :
            "/movie/\(req.mediaId)"
        case .fetchCredits(let req):
            return "movie/\(req.mediaId)/credits"
        case .fetchExternalIds(let req):
            return "/movie/\(req.mediaId)/external_ids"
        case .addReview(let req):
            return "/movie/\(req.mediaId)/rating"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .fetchFavoriteMovies, .fetchDetails, .fetchCredits, .fetchExternalIds:
            return .get
        case .editFavoriteMovie, .addReview:
            return .post
        }
    }
    
    // TODO: Different encoding
    var task: Moya.Task {
        switch self {
        case let .fetchGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTV(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .editFavoriteMovie(req):
//            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.httpBody)
            let request = EditFavoriteBodyRequest(movieId: req.movieId, isFavorite: req.isFavorite)
            return .requestJSONEncodable(request)
        case let .fetchDetails(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCredits(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchExternalIds(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .addReview(req):
            let request = AddReviewBodyRequest(mediaId: req.mediaId, value: req.value)
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchTV(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        case let .fetchFavoriteMovies(req):
            return ["Authorization": req.accessToken]
        case .editFavoriteMovie(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        case .fetchDetails(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCredits(let req):
            return ["Authorization": req.accessToken]
        case .fetchExternalIds(let req):
            return ["Authorization": req.accessToken]
        case .addReview(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        }
    }
}
