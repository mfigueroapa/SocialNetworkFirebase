//
//  FeedViewController.swift
//  InstaCloneFireBase
//
//  Created by Mauricio Figueroa on 27/02/20.
//  Copyright © 2020 Mauricio Figueroa. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        cell.userEmailLabel.text = "userEmail"
        cell.likeLabel.text = " 000 "
        cell.commentLabel.text = "texttt"
        cell.userImageView.image = UIImage()
        return cell//
        
    }
    
    
    
}
