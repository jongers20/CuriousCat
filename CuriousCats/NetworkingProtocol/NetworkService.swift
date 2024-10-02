//
//  NetworkService.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//
import Foundation

protocol NetworkService {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}

struct URLSessionNetworkService: NetworkService {
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}
