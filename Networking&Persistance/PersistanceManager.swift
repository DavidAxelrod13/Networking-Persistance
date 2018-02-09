//
//  PersistanceManager.swift
//  Networking&Persistance
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class PersistanceManager {
    
    func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory!")
        }
    }
    
    func savePostsToDisk(posts: [Post]) {
        let url = getDocumentsURL().appendingPathComponent("posts.json")
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(posts)
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getPostsFromDisk() -> [Post] {
        let url  = getDocumentsURL().appendingPathComponent("posts.json")
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: url, options: [])
            let posts = try decoder.decode([Post].self, from: data)
            return posts
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
