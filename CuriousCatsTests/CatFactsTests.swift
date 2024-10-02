//
//  CatFactsTests.swift
//  CatFactsTests
//
//  Created by Erika Ypil on 10/1/24.
//

import Testing
import XCTest

@testable import CuriousCats

class CatFactsTests: XCTestCase {
    
    var mockNetworkService: MockNetworkService!
    var mockDecodingService: MockDecodingService!
    var sut: GetRandomCatFactsService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        mockDecodingService = MockDecodingService()
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
        mockDecodingService = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func loadJSONFromFiile(named fileName: String) throws -> Data {
        
        guard let path = Bundle(for: CatFactsTests.self).path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "File not found", code: 0, userInfo: nil)
        }
        
        let fileURL = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileURL)
        return data
    }
    
    @Test func testFetchCatFactsSuccess() async throws {
        let mockNetworkService = MockNetworkService()
        let mockDecodingService = MockDecodingService()
        
        let mockData = try loadJSONFromFiile(named: "factsStub")
        
        mockNetworkService.mockData = mockData
        mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://meowfacts.herokuapp.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        let mockFactResponse = try JSONDecoder().decode(CatFactsResponse.self, from: mockData)
        mockDecodingService.decodeObject = mockFactResponse
        
        let sut = GetRandomCatFactsService(networkService: mockNetworkService, decodingService: mockDecodingService)
        
        let facts = try await sut.fetchCatFacts(limit: 1)
        
        XCTAssertEqual(facts, ["A cat has been mayor of Talkeetna, Alaska, for 15 years. His name is Stubbs."])
    }

}
