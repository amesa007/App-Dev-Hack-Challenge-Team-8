//
//  NetworkManager.swift
//  ClassChat
//
//  Created by Gabriel Xu on 12/5/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = URL(string: "http://127.0.0.1:5000")!
    
    private init() {}
    
    // MARK: - Helpers
    
    private func makeRequest(
        path: String,
        method: String = "GET",
        body: [String: Any]? = nil
    ) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
    
    // MARK: - Public API
    
    func fetchPosts(forGroupID groupID: Int, completion: @escaping (Result<[APIPost], Error>) -> Void) {
        let path = "api/groups/\(groupID)/posts/"
        
        do {
            let request = try makeRequest(path: path)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { completion(.success([])) }
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(APIPostsResponse.self, from: data)
                    DispatchQueue.main.async { completion(.success(decoded.post)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // Create post
    func createPost(
        userID: Int,
        groupID: Int,
        content: String,
        completion: @escaping (Result<APIPost, Error>) -> Void
    ) {
        let path = "api/posts/"
        let body: [String: Any] = [
            "user_id": userID,
            "group_id": groupID,
            "content": content
        ]
        
        do {
            let request = try makeRequest(path: path, method: "POST", body: body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                    }
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(APIPost.self, from: data)
                    DispatchQueue.main.async { completion(.success(decoded)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchGroups(completion: @escaping (Result<[APIGroup], Error>) -> Void) {
        let path = "api/groups/"
        
        do {
            let request = try makeRequest(path: path)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { completion(.success([])) }
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(APIGroupsResponse.self, from: data)
                    DispatchQueue.main.async { completion(.success(decoded.groups)) }
                } catch {
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
