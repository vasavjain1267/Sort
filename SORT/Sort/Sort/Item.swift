//
//  Item.swift
//  Sort
//
//  Created by Vasav Jain on 30/01/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
