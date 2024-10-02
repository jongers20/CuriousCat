//
//  Facts.swift
//  CuriousCats
//
//  Created by Erika Ypil on 10/1/24.
//

import Foundation

struct CatFactsResponse: Codable {
    let data: [String]
}

struct CatImageResponse: Codable {
    let id: String?
    let url: String?
    let width: Int?
    let height: Int?
    let breeds: [String]?
}
