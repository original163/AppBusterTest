//
//  GistsProvider.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 23.09.2021.
//

import Foundation

private extension String {
    func formatted() -> String {
        let ISOFormatter = ISO8601DateFormatter()
        guard let date = ISOFormatter.date(from: self) else {
            fatalError("Something is wrong with API")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct Gist: Decodable {
    let htmlUrl: String
    let dateCreated: String
    let title: String
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case htmlUrl = "html_url"
        case dateCreated = "created_at"
        case title = "description"
        case owner
     }
    
    init(
        htmlUrl: String,
        dateCreated: String,
        title: String,
        owner: Owner
    ) {
        self.htmlUrl = htmlUrl
        self.dateCreated = dateCreated
        self.title = title
        self.owner = owner
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
     }
}

typealias GistProviderError = APIError

protocol GistsProviderDelegate: AnyObject {
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReceiveNextPage gists: [Gist])
    func gistProviderDelegate(_ gistProvider: GistsProvider, didFailWithError error: GistProviderError)
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachFinalPage finished: Bool)
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachedFinalPage finished: Bool)
}

class GistsProvider {
    private enum State {
        case idle
        case loading
        case finished
    }
    
    private let api = GistAPI()
    private let username: String
    private var pageNumber: Int = Int()
    private var state: State = .idle
    
    weak var delegate: GistsProviderDelegate?
    
    init(username: String) {
        self.username = username
    }
    
    func getNextGists() {
        switch state {
        case .idle:
            request()
        case .loading,
             .finished:
            break
        }
    }
    
    private func request() {
        state = .loading
        api.request(endpoint: .userGistsEndpoint(associatedValue: makeEndpointComponents())) { (result: Result<[Gist], APIError>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.delegate?.gistProviderDelegate(self, didFailWithError: error)
                    self.state = .idle
                case .success(let gists):
                    if gists.count < 6 {
                        self.delegate?.gistProviderDelegate(self, didReachedFinalPage: true)
                        self.state = .finished
                    }
                    if gists.isEmpty {
                        self.delegate?.gistProviderDelegate(self, didReachFinalPage: true)
                        self.state = .finished
                    } else {
                        self.delegate?.gistProviderDelegate(
                            self,
                            didReceiveNextPage: gists.map {
                                Gist(
                                    htmlUrl: $0.htmlUrl,
                                    dateCreated: $0.dateCreated.formatted(),
                                    title: $0.title,
                                    owner: $0.owner
                                )
                            }
                        )
                        self.pageNumber += 1
                        self.state = .idle
                    }
                }
            }
        }
    }
    
    private func makeEndpointComponents() -> UserGistsEndpoint {
        UserGistsEndpoint(username: username, pageNumber: pageNumber)
    }
}
