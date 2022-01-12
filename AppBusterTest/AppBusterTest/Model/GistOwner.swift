//
//  GistOwner.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 12.01.2022.
//

import Foundation

struct GistOwner: Codable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
     }
}
