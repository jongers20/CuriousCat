//
//  GetRandomCatFacts.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//

import Foundation

class GetRandomCatFactsService {
    private let networkService: NetworkService
    private let decodingService: DecodingService
    
    init(networkService: NetworkService = URLSessionNetworkService(),
         decodingService: DecodingService = JSONDecodingService()) {
        self.networkService = networkService
        self.decodingService = decodingService
    }
    
    func fetchCatFacts(limit: Int) async throws -> [String]? {
        
        let catFacts = CatFacts(limit: limit)
        let (data, response) = try await  networkService.fetchData(from: catFacts.buildURL())
        
        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
            throw NetworkError.iinvalidResponse
        }
        
        let facts = try decodingService.decode(CatFactsResponse.self, from: data)
        return facts.data
        
    }
}
