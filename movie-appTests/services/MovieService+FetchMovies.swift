//
//  MovieService+FetchMovies.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 04. 22..
//

@testable import movie_app
import Nimble
import Quick
import Moya
import Foundation
import Swinject
import InjectPropertyWrapper

private var fetchMovieParameters: FetchMediaListRequest?
private var expectedFetchMoviesResponse: EndpointSampleResponse =
    .networkResponse(502, Data())

class MoviesService_FetchMovies: AsyncSpec {
    
    override class func spec() {
        xdescribe("MoviesService") {
            var sut: MoviesService!
            var assembler: MainAssembler!
            var emittedResult: [[MediaItem]]?
            
            beforeEach {
                assembler = MainAssembler.create(withAssemblies: [TestAssembly()])
                InjectSettings.resolver = assembler.container
                
                sut = assembler.resolver.resolve(MoviesService.self)
            }
            
            afterEach {
                sut = nil
                assembler.dispose()
                emittedResult = nil
            }
            
            context("fetchMovies") {
                context("on success") {
                    var resultFromServer = [MediaItem]()
                    beforeEach {
                        emittedResult = [[MediaItem]]()
                        
                        resultFromServer = [
                            MediaItem(id: 550,
                                  title: "Fight Club",
                                  year: "1999",
                                  duration: "1h 25min",
                                  imageUrl: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
                                  rating: 8.439,
                                  voteCount: 30180),
                        ]
//                        let responseFromServer = try! JSONDecoder().decode(GenreListResponse.self,
//                                                                     from: fetchGenresSuccessResponseData)
//
//                        resultFromServer = responseFromServer.genres.map { genreResponse in
//                            Genre(dto: genreResponse)
//                        }
                        expectedFetchMoviesResponse =
                            .networkResponse(200, fetchMovieSuccessResponseData)
                        
                        let result = try await sut.fetchMovies(req: FetchMediaListRequest(genreId: 20))
                        
                        emittedResult?.append(result)
                    }
                    
                    it("emits the correct movies") {
                        expect(emittedResult).to(equal([resultFromServer]))
                    }
                }
            }
        }
    }
}

extension MoviesService_FetchMovies {
    
    class TestAssembly: TestServiceAssembly {
        override func assemble(container: Container) {
            super.assemble(container: container)
            container.register(MoviesService.self) { _ in
                let instance = MoviesService()
                return instance
            }.inObjectScope(.transient)
        }
        
        override func createStubEndpoint(withMultiTarget multiTarget: MultiTarget) -> Endpoint {
            guard let target = multiTarget.target as? MoviesApi else {
                preconditionFailure("Target is not \(String(describing: MoviesApi.self))")
            }
            
            var sampleResponseClosure: Endpoint.SampleResponseClosure
            switch target {
            case let .fetchMovies(req):
                fetchMovieParameters = req
                sampleResponseClosure = { expectedFetchMoviesResponse }
            default:
                sampleResponseClosure = { .networkResponse(502, Data()) }
            }
            return Endpoint(
                url: url(target),
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)
        }
        
    }
}

private let fetchMovieSuccessResponseData =
"""
{
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
      "genre_ids": [
        18
      ],
      "id": 550,
      "original_language": "en",
      "original_title": "Fight Club",
      "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
      "popularity": 40.2077,
      "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
      "release_date": "1999-10-15",
      "title": "Fight Club",
      "video": false,
      "vote_average": 8.439,
      "vote_count": 30180
    }
]
}
""".data(using: String.Encoding.utf8)!
