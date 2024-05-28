//
//  ApiHandler.swift
//  PaginationDemo
//
//  Created by shree on 28/05/24.
//

enum ApiError : Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
    
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol ApiHandlerProtocol{
    func apiCall<T : Codable>(urlStr : String, method : HTTPMethod, param : [String : Any]?, comletion : @escaping(Result<[T] , ApiError>) -> Void)
}

import Foundation

class ApiHandler : ApiHandlerProtocol{
   
   
    static let shared = ApiHandler()
    
    private init(){}
    
    func apiCall<T>(urlStr: String, method: HTTPMethod, param: [String : Any]?, comletion: @escaping (Result<[T], ApiError>) -> Void) where T : Decodable, T : Encodable   {
        
        guard let url = URL(string: urlStr) else{
            comletion(.failure(.invalidURL))
            return
        }
        
        var request =  URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        if let param =  param {
            if method == .post{
                do{
                    request.httpBody =  try JSONSerialization.data(withJSONObject: param, options: [])
                }catch{
                    comletion(.failure(.invalidURL))
                }
            }else if method == .get{
                let queryParam = param.map{ "\($0.key)=\($0.value)"}.joined(separator: "&")
                
                print("query param -", queryParam)
                request.url = URL(string: "\(urlStr)\(queryParam)")
            }
        }
        
        print("request - ", request)
        
        let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 60 // 60 seconds
                configuration.timeoutIntervalForResource = 120 // 120 seconds
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request){(data, response, error) in
            if let error = error{
                comletion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as?   HTTPURLResponse else{
                comletion(.failure(.invalidResponse))
                return
            }
            
            guard(200...299).contains(httpResponse.statusCode) else{
                comletion(.failure(.invalidResponse))
                return
            }
            
            guard let responseData = data else{
                comletion(.failure(.invalidData))
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("Response String: \(responseString)")
            }
            
            do{
                let decodeData  = try JSONDecoder().decode([T].self, from: responseData)
                comletion(.success(decodeData))
            }catch{
                comletion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
   
}
