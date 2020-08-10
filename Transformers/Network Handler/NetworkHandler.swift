//
//  NetworkHandler.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import Foundation

class NetworkHandler {
    // MARK: - Public Methods
    func makeAPICall<T: Decodable>(router: NetworkConfiguration,
                                    decodingType: T.Type,
                                    completion: @escaping(Result<Decodable, APIError>)-> ()) {
        guard Reachability.isNetwrokReachable() else {
            completion(.failure(.noNetwork))
            return
        }
        if let urlRequest = getURLRequest(for: router) {
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    // if server returns error
                    completion(.failure(.serverError))
                    return
                }
                if let data = data {
                    // data decoding to models
                    self.decodeObj(decodingType: T.self, data: data) { (object, err) in
                        guard let object = object else {
                            completion(.failure(.jsonError))
                            return
                        }
                        completion(.success(object))
                    }
                }
            }.resume()
        }
    }
    func makeAPICall(router: NetworkConfiguration,
                     completion: @escaping(Result<String, APIError>)-> ()) {
        guard Reachability.isNetwrokReachable() else {
            completion(.failure(.noNetwork))
            return
        }
        if let urlRequest = getURLRequest(for: router) {
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    // if server returns error
                    completion(.failure(.serverError))
                    return
                }
                if let data = data {
                    // data decoding to string value
                    self.decodeString(data: data) { (object, error) in
                        guard let object = object else {
                            completion(.failure(.jsonError))
                            return
                        }
                        completion(.success(object))
                    }
                }
            }.resume()
        }
    }
    // MARK: - Private Methods
    private func getURLRequest(for router: NetworkConfiguration) -> URLRequest? {
        if let url = URL(string: router.baseURL + (router.path ?? "")) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = router.method.rawValue
            urlRequest.allHTTPHeaderFields = router.headers
            
            if router.method == .get {
                // retured as GET calls will not have httpBody
                return urlRequest
            }
            else if let jsonData = try? JSONSerialization.data(withJSONObject: router.bodyparameters ?? [:]) {
                urlRequest.httpBody = jsonData
                return urlRequest
            } else {
                return urlRequest
            }
        }
        return nil
    }
    private func decodeObj<T: Decodable>(decodingType: T.Type,
                                 data: Data,
                                 decode: @escaping (Decodable?, APIError?) -> Void)  {
        //let jsonString = String(decoding: data, as: UTF8.self)
        //print("server response \(jsonString)")
         do {
            let model = try JSONDecoder().decode(T.self, from: data)
            decode(model, nil)
         } catch {
            decode(nil, .jsonError)
        }
    }    
    private func decodeString(data: Data, decode: @escaping (String?, APIError?) -> Void)  {
        decode(String(decoding: data, as: UTF8.self), nil)
    }
}
