//
//  NetworkManagment.swift
//  RoomvuPhotoCroper
//
//  Created by Iman Seraji on 2/5/24.
//

import Foundation

struct NetworkManagment{
    
    
    static let shared = NetworkManagment()
    
    private init(){}
    
    private func handleRessponse<T:Decodable>(result : Result<Data,Error>?,completion:(Result<T,Error>)->Void){
        
        guard let result = result else{
            completion(.failure(AppErrors.unknownError))
            return
        }
        switch result{
            
        case .success(let data):
            let decoder = JSONDecoder()
            
            let responseString = String(data: data, encoding: .utf8) ?? "Could Not Convert Data to tring"
            print("The Dataaaaaaa is : \(responseString)")
            do {
                
                let response = try decoder.decode(T.self, from: data)
           
            } catch let jsonError as NSError {
              print("JSON decode failed: \(jsonError.localizedDescription)")
                completion(.failure(AppErrors.serverError(jsonError.localizedDescription)))
                return
            }
         
            
            guard let response = try? decoder.decode(T.self, from: data) else{
                completion(.failure(AppErrors.errorDecoding))
                return
            }
            print("The ressssssss is : \(response)")
            completion(.success(response))
            
           
        case .failure(let error):
            completion(.failure(error))
        }
        
        
    }
    
    
    /// Create UrlRequest
    /// - Parameters:
    ///   - apiAddress: End Point Addres
    ///   - method: Request Type
    ///   - parameters: Request Prameters
    /// - Returns: UrlRequest
     private func createRequest(apiAddress : ApiInfo,method:RequestTypes,parameters:[String:Any]? = nil)-> URLRequest?{

        let urlString = apiAddress.Value
        
        guard  let url = URL(string:urlString) else{ return nil }
        
        var urlRequest = URLRequest(url: url)
         urlRequest.addValue(ApiInfo.apiToken, forHTTPHeaderField: "token")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method{
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map{URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params)
                urlRequest.httpBody = bodyData
            }
          }
    return urlRequest
    }
    
     func  request<T:Decodable>(apiAddress : ApiInfo,method:RequestTypes,parameters:[String:Any]? = nil, complition:@escaping (Result<T,Error>)->Void){
        
        guard let request = createRequest(apiAddress: apiAddress, method: method, parameters: parameters) else{
            complition(.failure(AppErrors.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request){data,response,error in
            var result : Result<Data,Error>?
            
            if let data = data {
                
                let responseString = String(data: data, encoding: .utf8) ?? "Could Not Convert Data to tring"
                 print("The Response is : \(responseString)")
                result = .success(data)
                
            } else if let error = error{
                result = .failure(error)
                 print("error is \(error)")
            }
            DispatchQueue.main.async {
                self.handleRessponse(result: result, completion: complition)
                
            }
            
            
        }.resume()
        
        
        
    }
    
}
