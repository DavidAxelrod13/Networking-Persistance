//
//  Post.swift
//  Networking&Persistance
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}
