//
//  HomeScreenViewModel.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//

import Foundation
import Combine
import UIKit


class HomeScreenViewModel: ObservableObject {
    
    @Published var factsArr: [String]?
    @Published var imagesArr: [CatImageResponse]?
    @Published var image: UIImage?
    @Published private(set) var currentIndex: Int = 0
    private let limit: Int = 10
    private var cancellables = Set<AnyCancellable>()
    var onFetchDataRequested: (() -> Void)?
    
    var factsService: GetRandomCatFactsService
    var imagesService: GetRandomCatImagesService
    
    init(factsService: GetRandomCatFactsService = GetRandomCatFactsService(),
         imagesService: GetRandomCatImagesService = GetRandomCatImagesService()) {
        self.factsService = factsService
        self.imagesService = imagesService
    }
    
    func fetchData() async {
        
        async let facts = fetchFacts()
        async let images = fetchImages()
        
        do {
            let fetchedfacts = try await facts
            let fetchedImages = try await images
            
            self.factsArr = fetchedfacts
            self.imagesArr = fetchedImages
            
            if let imageIndex = fetchedImages?[currentIndex],
               let imageURLString = imageIndex.url,
               let url = URL(string: imageURLString) {
                let imageData =  try await loadImage(from: url)
                self.image = UIImage(data: imageData)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
    }
    
    func fetchFacts() async throws -> [String]? {
        return try await self.factsService.fetchCatFacts(limit: self.limit)
    }
    
    func fetchImages() async throws -> [CatImageResponse]? {
        return try await self.imagesService.fetchCatImages(limit: self.limit)
    }
    
    private func loadImage(from url: URL) async throws -> Data {
        return try await URLSession.shared.data(from: url).0
    }
    
    func loadIndexImage() async throws -> UIImage {
        guard let urlString = self.imagesArr?[currentIndex].url,
              let imgURL = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: imgURL)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Image creation failed", code: 0, userInfo: nil)
        }
        
        return image
    }
}

//Logic for tapping
extension HomeScreenViewModel {
    
    func handleTap(at location: CGPoint, in viewWidth: CGFloat) {
        if location.x < viewWidth / 2 {
            //lef tap, navigate back from the arr
            if self.currentIndex > 0 {
                self.currentIndex -= 1
            }
        } else {
            //right tap, navigate forward from the arr
            if let count = factsArr?.count, currentIndex < count - 1{
                self.currentIndex += 1
            } else {
                self.onFetchDataRequested?()
            }
        }
    }
    
    func getCurrentIndex() -> Int {
        return self.currentIndex
    }
    
}
