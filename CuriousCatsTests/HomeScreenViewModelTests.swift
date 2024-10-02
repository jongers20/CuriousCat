//
//  HomeScreenViewModelTests.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/2/24.
//

import Testing
import XCTest

@testable import CuriousCats


class HomeScreenViewModelTests: XCTestCase {
    
    var mockCatFactsService: MockCatFactsService!
    var mockCatImagesService: MockCatImagesService!
    lazy var viewModel = HomeScreenViewModel(factsService: mockCatFactsService, imagesService: mockCatImagesService)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCatFactsService = MockCatFactsService()
        mockCatImagesService = MockCatImagesService()
    }
    
    override func tearDownWithError() throws {
        mockCatFactsService = nil
        mockCatImagesService = nil
        try super.tearDownWithError()
    }
    
    @Test func testFetchFacts() async {
        do {
            if let facts = try await viewModel.fetchFacts(){
                XCTAssertEqual(facts.count, 1)
                XCTAssertEqual(facts.first, "A cat has been mayor of Talkeetna, Alaska, for 15 years. His name is Stubbs.")
            }
        } catch {
            XCTFail("Expected to fetch facts successfully, but got an error: \(error)")
        }
    }
    
    @Test func testFetchImages() async {
        do {
            if let images = try await viewModel.fetchImages() {
                
                XCTAssertEqual(images.count, 1)
                
                guard let firstImage = images.first else {
                    XCTFail("Expected at least one image, but got none")
                    return
                }
                
                XCTAssertEqual(firstImage.id, "ebv")
                XCTAssertEqual(firstImage.url, "https://cdn2.thecatapi.com/images/ebv.jpg")
                XCTAssertEqual(firstImage.width, 176, "Width does not match")
                XCTAssertEqual(firstImage.height, 540, "Height does not match")
                XCTAssertEqual(firstImage.breeds, [], "Breeds array is not empty")
                
            } else {
                XCTFail("Expected images to be non-nil")
            }
        } catch {
            XCTFail("Expected to fetch images successfully, but got an error: \(error)")
        }
    }
}
