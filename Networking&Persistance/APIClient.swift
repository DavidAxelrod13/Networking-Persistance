//
//  APIClient.swift
//  Networking&Persistance
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum APIError: Error {
    case noHTTPResponse, badHTTPResponse, noDataReturned, jsonParsingFailure

    
    var localizedDescription: String {
        switch self {
        case .noHTTPResponse:
            return "No HTTP Response has been returned!"
        case .badHTTPResponse:
            return "HTTP Response not 200!"
        case .noDataReturned:
            return "Data object was Nil!"
        case .jsonParsingFailure:
            return "Could not parse the JSON using the decoder!"
        }
    }
}


class APIClient {
    
    func submitPost(post: Post, completion: ((Error?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(post)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion?(error)
                return
            }
            
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                print("Response: ", utf8Representation)
            } else {
                print("Error, no readable data recieve in response")
            }
        }
        task.resume()
    }
    
    func getPosts(for userId: Int, completion: ((Result<[Post]>) -> Void)?) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        let userIdItem = URLQueryItem(name: "userId", value: "\(userId)")
        urlComponents.queryItems = [userIdItem]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion?(.failure(.noHTTPResponse)); return }
            
            if httpResponse.statusCode != 200 { completion?(.failure(.badHTTPResponse)); return }
            
            guard let jsonData = data else {
                completion?(.failure(.noDataReturned))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let posts = try decoder.decode([Post].self, from: jsonData)
                
                DispatchQueue.main.async {
                    completion?(.success(posts))
                }
            } catch {
                completion?(.failure(.jsonParsingFailure))
            }
        }
        
        task.resume()
        
    }
}
