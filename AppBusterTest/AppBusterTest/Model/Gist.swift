//
//  Gist.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 12.01.2022.
//

import Foundation

struct Gist: Decodable {
    let htmlUrl: String
    let dateCreated: String
    let title: String
    let owner: GistOwner
    
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
        owner: GistOwner
    ) {
        self.htmlUrl = htmlUrl
        self.dateCreated = dateCreated
        self.title = title
        self.owner = owner
    }
}

