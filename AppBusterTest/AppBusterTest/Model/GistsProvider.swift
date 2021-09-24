//
//  GistsProvider.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 23.09.2021.
//

import Foundation

struct Gist: Decodable {
    
    let htmlURL: String
    let dateCreated: String
    let dateUpdated: String
    let gistTitle: String
    
    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case dateCreated = "created_at"
        case dateUpdated = "updated_at"
        case gistTitle = "description"
      
    }
}

protocol GistsProviderDelegate: AnyObject {
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReceiveNextPage gists: [Gist])
    func gistProviderDelegate(_ gistProvider: GistsProvider, didFailWithError error: Error)
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachFinalPage finished: Bool)
}

class GistsProvider {
    private let api = GistAPI()
    private let username: String
    private var pageNumber: Int = 1
    private var isFinished = false
    
    weak var delegate: GistsProviderDelegate?
    
    init(username: String) {
        self.username = username
    }
    
    func getNextGists() {
        api.request(endpoint: .userGistsEndpoint(associatedValue: makeEndpointComponents())) { (result: Result<[Gist], APIError>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.delegate?.gistProviderDelegate(self, didFailWithError: error)
                case .success(let gists):
                    if gists.isEmpty {
                        self.delegate?.gistProviderDelegate(self, didReachFinalPage: true)
                        self.isFinished = true
                    } else {
                        self.delegate?.gistProviderDelegate(self, didReceiveNextPage: gists)
                        self.pageNumber += 1
                    }
                }
            }
        }
    }
    
    private func makeEndpointComponents() -> UserGistsEndpoint {
        UserGistsEndpoint(username: username, pageNumber: pageNumber)
    }
}
