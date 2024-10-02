//
//  MockService.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/2/24.
//

import Foundation

//Mock versions of the network and decoding services.

class MockNetworkService: NetworkService {
    var shouldReturnError = false
    var mockData: Data?
    var mockResponse: URLResponse?
    
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}

class MockDecodingService: DecodingService {
    var shouldReturnError = false
    var decodeObject: Decodable?
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if shouldReturnError {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Mock decoding error"))
        }
        return decodeObject as! T
    }
}

class MockCatFactsService: GetRandomCatFactsService {
    override func fetchCatFacts(limit: Int) async throws -> [String]? {
        return [
            "A cat has been mayor of Talkeetna, Alaska, for 15 years. His name is Stubbs."
        ]
    }
}

class MockCatImagesService: GetRandomCatImagesService {
    override func fetchCatImages(limit: Int) async throws -> [CatImageResponse]? {
        let imageResponse = CatImageResponse(id: "ebv",
                                             url: "https://cdn2.thecatapi.com/images/ebv.jpg",
                                             width: 176,
                                             height: 540,
                                             breeds: []
        )
        return [imageResponse]
    }
}

