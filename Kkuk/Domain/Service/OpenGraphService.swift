//
//  OpenGraphService.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import SwiftSoup

import Foundation

struct OpenGraph {
    let ogURL: String?
    let ogTitle: String?
    let ogImage: String?
}

protocol Extractable {
    func extractOpenGraphData(from URL: URL, completion: @escaping (Result<OpenGraph, Error>) -> Void)
}

class OpenGraphService: Extractable {
    
    func extractOpenGraphData(from URL: URL, completion: @escaping (Result<OpenGraph, Error>) -> Void) {
        let htmlParseService = HTMLParseService()
        
        htmlParseService.parseHTML(from: URL) { result in
            switch result {
            case .success(let document):
                let URLElement = try? document.select("meta[property=og:url]").attr("content")
                let titleElement = try? document.select("meta[property=og:title]").attr("content")
                let imageElement = try? document.select("meta[property=og:image]").attr("content")
                
                let openGraphData = OpenGraph(ogURL: URLElement, ogTitle: titleElement, ogImage: imageElement)
                
                completion(.success(openGraphData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
