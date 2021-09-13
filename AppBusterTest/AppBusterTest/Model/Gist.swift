//
//  Gist.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 09.09.2021.
//


import Foundation

class GistProvider {
    
    
    static func fetchGist() -> [Gist] {
        
        let firstItem = Gist(name: "Denis", createdDate: "10.09.21", updatedDate: "12.09.21")
        let secondItem = Gist(name: "John", createdDate: "10.10.21", updatedDate: "12.09.21")
        let thirdItem = Gist(name: "Egor", createdDate: "10.11.21", updatedDate: "12.09.21")
        let fourItem = Gist(name: "Tony Stark", createdDate: "10.12.21", updatedDate: "12.09.21")
        let fiveItem = Gist(name: "Spiderman", createdDate: "10.13.21", updatedDate: "12.09.21")
        let sixtItem = Gist(name: "Superman", createdDate: "10.14.21", updatedDate: "12.09.21")
        let seventItem = Gist(name: "Noob", createdDate: "10.15.21", updatedDate: "12.09.21")
        
        return [firstItem,secondItem,thirdItem,fourItem,fiveItem,sixtItem,seventItem]
    }
    
    
}
struct Gist {
    
    let name: String            // "description": "It's my test gist"
    let createdDate: String     // "created_at": "2021-09-08T07:39:02Z"
    let updatedDate: String     // "updated_at": "2021-09-08T07:39:02Z"
    
    
    
}
