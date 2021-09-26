//
//  GistAPI.swift
//
//  Pagination
//
//  AppBusterTest
//
//  Created by Денис Денисов on 16.09.2021.
//

import Foundation


private extension URL {
    init?(host: URL, endpointComponents: EndpointComponents) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.absoluteString
        components.path = endpointComponents.path.reduce("") { "\($0)/\($1)"  }
        components.queryItems = endpointComponents.queryItems
        guard let url = components.url else { return nil }
        self = url
    }
}

enum APIError: Error {
    case incorrectDataType // если указан не правильный тип модели
    case systemError // если нет интернета
    case serverError
}

protocol EndpointComponents {
    // объект подписаный этим протоколом сможет только получить значения этих properties
    var path: [String] { get }
    var queryItems: [URLQueryItem]? { get }
}

struct UserGistsEndpoint: EndpointComponents {
    // endpoint parameter
    // stored-property (лоцирована, память выделена)
    let username: String
    
    // Согласно документации API
    
    // read-only computed-property (передача издержек по памяти - вызывающей стороне)
    var path: [String] {
        ["users", username, "gists"]
    }
    // possible query items
    let gistsPerPage: Int // default parameter in init()
    let pageNumber: Int   // default parameter in init()
    
    // Согласно документации API
    
    // read-only computed-property (передача издержек по памяти - вызывающей стороне)
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "per_page", value: String(gistsPerPage)),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
    }
    
    init(username: String, gistsPerPage: Int = 6, pageNumber: Int = 0) {
        self.username = username
        self.gistsPerPage = gistsPerPage
        self.pageNumber = pageNumber
    }
}

struct GistAPI {
    private let host = URL(string: "api.github.com")!
    
    enum Endpoints {
        case userGistsEndpoint(associatedValue: UserGistsEndpoint) //one of variants of use GithubAPI
        
        var endpointComponents: EndpointComponents {
            switch self {
            case .userGistsEndpoint(let endpointComponents):
                return endpointComponents
            }
        }
    }
    
    func request<Model: Decodable>(
        endpoint: Endpoints,
        completion completionHandler: @escaping (Result<Model, APIError>) -> Void
    ) {
        guard let url = URL(host: host, endpointComponents: endpoint.endpointComponents) else {
            fatalError("Error: your endpoints are not valid") //не compltionHandler так как мы уверенны что URL собрался
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil { // тут возможна только системная ошибка (нет интернета)
                completionHandler(.failure(.systemError))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse, // логическое &&
                (200...299).contains(httpResponse.statusCode)
                    
            else {
                completionHandler(.failure(.serverError))
                return
            }
            print("response statusCode: \(httpResponse.statusCode)")
            
            guard let data = data,
                  let models = try? JSONDecoder().decode(Model.self, from: data)
            else {
                completionHandler(.failure(.incorrectDataType))
                return
            }
            completionHandler(.success(models))
        }
        .resume()
    }
    
}


