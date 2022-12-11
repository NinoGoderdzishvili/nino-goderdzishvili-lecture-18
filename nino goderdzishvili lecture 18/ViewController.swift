//
//  PostsViewController.swift
//  nino goderdzishvili lecture 18
//
//  Created by Nino Goderdzishvili on 12/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    var userPosts = [[UserPost]]()
    
    @IBOutlet weak var postsTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPersonsTV()
        getUserPosts()
    }
    
    func setupPersonsTV() {
        postsTV.delegate = self
        postsTV.dataSource = self
    }
    
    func getUserPosts() {
        NetworkService.shared.getData(
            urlString: "https://jsonplaceholder.typicode.com/posts",
            expecting: [UserPost].self) { result in
                switch result {
                case .success(let userPosts):
                    DispatchQueue.main.async {
                        self.groupPost(userPosts)
                        self.postsTV.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func groupPost(_ posts: [UserPost]){
        self.userPosts.append(posts)
        
        var newDimArray = [[UserPost]]()
        
        for userPost in posts {
            let postsForCurrentUser = newDimArray.contains { postsSortedByUser in
                postsSortedByUser.contains { currentUserPost in
                    currentUserPost.userId == userPost.userId
                }
            }
            
            let index = newDimArray.firstIndex { postsSortedByUser in
                postsSortedByUser.contains { currentUserPost in
                    currentUserPost.userId == userPost.userId
                }
            }
            
            if !postsForCurrentUser {
                let userPostArray = [userPost]
                newDimArray.append(userPostArray)
            } else {
                newDimArray[index!].append(userPost)
            }
        }
        
        self.userPosts = newDimArray
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PostCommentViewController") as? PostCommentViewController {
            
            let currentUserPosts = userPosts[indexPath.section]
            let currentUserPost = currentUserPosts[indexPath.row]
            
            vc.postId = currentUserPost.id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userPostsArray = userPosts[section]
        return userPostsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostsTVC", for: indexPath) as?
                PostsTVC else {
            return UITableViewCell()
        }
        
        let currentUserPosts = userPosts[indexPath.section]
        let currentUserPost = currentUserPosts[indexPath.row]
        
        cell.titleLabel.text = "Title: \(currentUserPost.title)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        if userPosts.count > 0 {
            let userPosts = userPosts[section]
            let userPost = userPosts.first!
            
            label.text = "Post of user: \(userPost.userId)"
            label.textColor = .white
            label.backgroundColor = .gray
        }
        
        return label
    }
}
