//
//  HTMLParseService.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import Alamofire
import SwiftSoup

import Foundation

protocol Parsable {
    func parseHTML(from URL: URL, completion: @escaping (Result<Document, Error>) -> Void)
}

class HTMLParseService: Parsable {
    
    func parseHTML(from URL: URL, completion: @escaping (Result<Document, Error>) -> Void) {
        AF.request(URL).responseString { response in
            switch response.result {
            case .success(let HTMLString):
                do {
                    let document = try SwiftSoup.parse(HTMLString)
                    completion(.success(document))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
