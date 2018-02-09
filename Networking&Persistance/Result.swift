//
//  Result.swift
//  Networking&Persistance
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(APIError)
}
