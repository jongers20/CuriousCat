//
//  GetRandomCatImage.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//

import Foundation

class GetRandomCatImagesService {
    private let networkService: NetworkService
    private let decodingService: DecodingService
    
    init(networkService: NetworkService = URLSessionNetworkService(),
         decodingService: DecodingService = JSONDecodingService()) {
        self.networkService = networkService
        self.decodingService = decodingService
    }
    
    func fetchCatImages(limit: Int) async throws -> [CatImageResponse]? {
        
        let catImage = CatImages(limit: limit)
        let (data, response) = try await  networkService.fetchData(from: catImage.buildURL())
        
        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
            throw NetworkError.iinvalidResponse
        }
        
        let images = try decodingService.decode([CatImageResponse].self, from: data)
        return images
    }
}
