//
//  ViewController.swift
//  Networking&Persistance
//
//  Created by David on 05/02/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var posts = [Post]()
    let client = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    
        client.getPosts(for: 1) { (result) in
            switch result {
            case .success(let posts):
                self.posts = posts
                posts.forEach { print($0.title ?? "") }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    
        let postToSubmit = Post(userId: 2, id: 24352, title: "Hello World", body: "How is everyone doing these days?")
        client.submitPost(post: postToSubmit) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    
    }

}

