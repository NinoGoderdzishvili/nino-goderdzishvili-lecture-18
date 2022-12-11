//
//  PostCommentViewController.swift
//  nino goderdzishvili lecture 18
//
//  Created by Nino Goderdzishvili on 12/10/22.
//

import UIKit

class PostCommentViewController: UIViewController {
    
    var postId: Int? = nil
    var userPostComments: [PostComment] = []
    
    @IBOutlet weak var postCommentTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        getUserPostComments()
    }
    
    func setupTV() {
        postCommentTV.delegate = self
        postCommentTV.dataSource = self
    }
    
    func getUserPostComments () {
        NetworkService.shared.getData(
            urlString: "https://jsonplaceholder.typicode.com/posts/\(postId!)/comments",
            expecting: [PostComment].self) { result in
                switch result {
                case .success(let userPostComments):
                    DispatchQueue.main.async {
                        self.userPostComments = userPostComments
                        self.postCommentTV.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension PostCommentViewController: UITableViewDelegate, UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userPostComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentsTVC", for: indexPath) as? PostCommentsTVC else {
            return UITableViewCell()
        }
        
        cell.commentLabel.numberOfLines = 5;
        
        let currentUserPostComment = userPostComments[indexPath.row]
        
        cell.commentLabel.text = "Body: \(currentUserPostComment.body)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.text = "User post comments:"
        label.textColor = .white
        label.backgroundColor = .gray
        
        return label
    }
}

