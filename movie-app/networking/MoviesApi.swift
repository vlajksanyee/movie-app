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
    case fetchTVGenres(req: FetchTVGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
    case fetchTV(req: FetchMoviesRequest)
    case searchMovies(req: SearchMovieRequest)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies:
            return .get
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
        }
    }
}
