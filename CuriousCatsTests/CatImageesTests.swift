//
//  CatImageesTests.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/2/24.
//

import Testing
import XCTest

@testable import CuriousCats

class CatImageesTests: XCTestCase {
    
    var mockNetworkService: MockNetworkService!
    var mockDecodingService: MockDecodingService!
    var sut: GetRandomCatImagesService!
    
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
        
        guard let path = Bundle(for: CatImageesTests.self).path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "File not found", code: 0, userInfo: nil)
        }
        
        let fileURL = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: fileURL)
        return data
    }
    
    @Test func testFetchCatImagesSuccess() async throws {
        
        let mockData = try loadJSONFromFiile(named: "ImagesStub")
        
        mockNetworkService.mockData = mockData
        mockNetworkService.mockResponse = HTTPURLResponse(url: URL(string: "https://meowfacts.herokuapp.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        let expectedResponse = try JSONDecoder().decode([CatImageResponse].self, from: mockData)
        mockDecodingService.decodeObject = expectedResponse
        
        let sut = GetRandomCatImagesService(networkService: mockNetworkService, decodingService: mockDecodingService)
        
        let fetchedResponse = try await sut.fetchCatImages(limit: 1)
        
        XCTAssertEqual(fetchedResponse?.first?.id, "ebv")
        XCTAssertEqual(fetchedResponse?.first?.url, "https://cdn2.thecatapi.com/images/ebv.jpg")
        XCTAssertEqual(fetchedResponse?.first?.width, 176)
        XCTAssertEqual(fetchedResponse?.first?.height, 540)
        XCTAssertEqual(fetchedResponse?.first?.breeds, [])
    }

}
