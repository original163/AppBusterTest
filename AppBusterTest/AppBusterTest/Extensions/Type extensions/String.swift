//
//  String.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 12.01.2022.
//

import Foundation

extension String {
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
