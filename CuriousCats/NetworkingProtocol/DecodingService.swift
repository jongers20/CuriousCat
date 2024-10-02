//
//  DecodingService.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//
import Foundation

protocol DecodingService {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

struct JSONDecodingService: DecodingService {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
