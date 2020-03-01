//
//  FeedTableViewCell.swift
//  InstaCloneFireBase
//
//  Created by Mauricio Figueroa on 01/03/20.
//  Copyright © 2020 Mauricio Figueroa. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreData = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any] //if let bacause we want to convert it to Int
            
            fireStoreData.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true) //call the desired post with id
            
        }
        
        
    }
    
}
