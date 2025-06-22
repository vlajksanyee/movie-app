//
//  MoviesApi.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchMovieGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMediaListRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMoviesRequest)
    case fetchDetails(req: FetchDetailsRequest)
    case fetchCredits(req: FetchMediaCreditsRequest)
    case fetchReviews(req: FetchReviewsRequest)
    case fetchCastMemberDetails(req: FetchCastMemberDetailsRequest)
    case fetchCompanyDetails(req: FetchCastMemberDetailsRequest)
    case fetchSimilars(req: FetchSimilarsRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchTV(req: FetchMediaListRequest)
    case searchMedia(req: SearchMediaRequest)
    case addReview(req: AddReviewRequest)
    case editFavoriteMovie(req: EditFavoriteRequest)
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
        case .fetchMovieGenres:
            return "/genre/movie/list"
        case .fetchMovies:
            return "/discover/movie"
        case .fetchFavoriteMovies(let req):
            return "/account/\(req.account_id)/favorite/movies"
        case .fetchDetails(req: let req):
            return Environments.name == .tv ?
            "/tv/\(req.mediaId)" :
            "/movie/\(req.mediaId)"
        case .fetchCredits(let req):
            return "movie/\(req.mediaId)/credits"
        case .fetchReviews(let req):
            return "movie/\(req.mediaId)/reviews"
        case .fetchCastMemberDetails(let req):
            return "person/\(req.castMemberId)"
        case .fetchCompanyDetails(let req):
            return "company/\(req.castMemberId)"
        case .fetchSimilars(let req):
            return "movie/\(req.mediaId)/similar"
        case .fetchTVGenres:
            return "/genre/tv/list"
        case .fetchTV:
            return "/discover/tv"
        case .searchMedia:
            return "/search/movie"
        case .addReview(let req):
            return "/movie/\(req.mediaId)/rating"
        case .editFavoriteMovie(req: let req):
            return "/account/\(req.account_id)/favorite"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMovieGenres, .fetchMovies, .fetchFavoriteMovies, .fetchDetails, .fetchCredits, .fetchReviews, .fetchCastMemberDetails, .fetchCompanyDetails, .fetchSimilars, .fetchTVGenres, .fetchTV, .searchMedia:
            return .get
        case .addReview, .editFavoriteMovie:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchMovieGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchDetails(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCredits(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchReviews(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCastMemberDetails(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCompanyDetails(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchSimilars(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTV(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMedia(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .addReview(req):
            let request = AddReviewBodyRequest(mediaId: req.mediaId, value: req.value)
            return .requestJSONEncodable(request)
        case let .editFavoriteMovie(req):
            let request = EditFavoriteBodyRequest(movieId: req.movieId, isFavorite: req.isFavorite)
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchMovieGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchFavoriteMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchDetails(req):
            return ["Authorization": req.accessToken]
        case let .fetchCredits(req):
            return ["Authorization": req.accessToken]
        case let .fetchReviews(req):
            return ["Authorization": req.accessToken]
        case let .fetchCastMemberDetails(req):
            return ["Authorization": req.accessToken]
        case let .fetchCompanyDetails(req):
            return ["Authorization": req.accessToken]
        case let .fetchSimilars(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTV(req):
            return ["Authorization": req.accessToken]
        case let .searchMedia(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        case let .addReview(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        case let .editFavoriteMovie(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application.json"
            ]
        }
    }
}
