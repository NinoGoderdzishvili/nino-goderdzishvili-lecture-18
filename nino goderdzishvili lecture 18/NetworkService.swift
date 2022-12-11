//
//  UsersPostService.swift
//  nino goderdzishvili lecture 18
//
//  Created by Nino Goderdzishvili on 12/8/22.
//

import Foundation

class NetworkService {
    static var shared = NetworkService()
    private var session = URLSession()
    
    init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        self.session = urlSession
    }
    
//    func getUserPosts(completion: @escaping ([UserPost])->(Void)) {
//        let urlsString = "https://jsonplaceholder.typicode.com/posts"
//        let url = URL(string: urlsString)!
//
//        session.dataTask(with: URLRequest(url: url)) { data, response, error in
//            let data = data
//            let decoder = JSONDecoder()
//
//            let object = try! decoder.decode([UserPost].self, from: data!)
//            DispatchQueue.main.async {
//                completion(object)
//            }
//        }.resume()
//    }
//
//    func getUserPostComments(postId: Int, completion: @escaping ([PostComment])->(Void)) {
//        let urlsString = "https://jsonplaceholder.typicode.com/posts/\(postId)/comments"
//        let url = URL(string: urlsString)!
//
//        session.dataTask(with: URLRequest(url: url)) { data, response, error in
//            let data = data
//            let decoder = JSONDecoder()
//
//            let object = try! decoder.decode([PostComment].self, from: data!)
//            DispatchQueue.main.async {
//                completion(object)
//            }
//        }.resume()
//    }
    
    func getData<T: Codable>(urlString: String,
                             expecting: T.Type,
                             complition: @escaping (Result<T, Error>) -> Void) {
        
        let url = URL(string: urlString)!
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("wrong response")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(expecting, from: data)
                complition(.success(object))
            } catch {
                complition(.failure(error))
            }
            
        }.resume()
        
    }
}
