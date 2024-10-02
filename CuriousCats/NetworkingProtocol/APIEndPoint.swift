//
//  APIEndpoint.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//
import Foundation

protocol APIEndPointProtocol {
    var baseURL: String { get }
    var path: String { get }
    func buildURL() -> URL
}

struct APIConfiguration {
    static let imageBaseURL = "https://api.thecatapi.com/v1/images/search"
    static let factsBaseURL = "https://meowfacts.herokuapp.com"
    static let APIKey = ""
}

struct CatImages: APIEndPointProtocol {
    let limit: Int
    
    var baseURL: String {
        return APIConfiguration.imageBaseURL
    }
    
    var path: String {
        return "?limit=\(limit)"
    }
    
    func buildURL() -> URL {
        return URL(string: baseURL + path)!
    }
}

struct CatFacts: APIEndPointProtocol {
    let limit: Int
    
    var baseURL: String {
        return APIConfiguration.factsBaseURL
    }
    
    var path: String {
        return "/?count=\(limit)"
    }
    
    func buildURL() -> URL {
        return URL(string: baseURL + path)!
    }
}
