//
//  FeedTableViewCell.swift
//  InstaCloneFireBase
//
//  Created by Mauricio Figueroa on 01/03/20.
//  Copyright © 2020 Mauricio Figueroa. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var likedByUsersArr = [String]()
    var likeStore = [String:Any]()
    override func awakeFromNib() {
        super.awakeFromNib()
        getFireStoreData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        if likeButton.titleLabel?.text == "Like"{
            likeButton.setTitle("Unlike", for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
        }
        
        let fireStoreData = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            var usersIdElement = String()
            usersIdElement = (Auth.auth().currentUser?.email!)!
            
            if likedByUsersArr.contains(usersIdElement) && likeCount > 0 {
                self.likeStore = ["likes" : likeCount - 1] as [String : Any]
                let farr = likedByUsersArr.filter {$0 != usersIdElement}
                likedByUsersArr = farr
            } else {
                self.likeStore = ["likes" : likeCount + 1] as [String : Any]
                likedByUsersArr.append(usersIdElement)
            }
            let likedByUsers = ["likedByUsers" : likedByUsersArr] as [String : Any]
            
            fireStoreData.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            fireStoreData.collection("Posts").document(documentIdLabel.text!).setData(likedByUsers, merge: true)
        }//end if let
        
        
        /// get the user id
        let userEmail = userEmailLabel.text!
        fireStoreData.collection("PlayerId").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        if let playerId = document.get("player_id") as? String {
                            OneSignal.postNotification(["contents": ["en": "\(Auth.auth().currentUser!.email!) like your post! "], "include_player_ids": ["\(playerId)"]])
                        }//end if let
                    }//end for
                }//end if snapshot
            }//end if error
        }//end closure
        
        
        
        
    }
    
    
    
    func getFireStoreData() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    /////////Cleaning each array to avoid duplicates
                    self.likedByUsersArr.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents { //contains all of the documents of the posts collection
              
                        if let likedByUsers = document.get("likedByUsers") as? [String] { //casting
                            for user in likedByUsers {
                                self.likedByUsersArr.append(user)
                            }//end for
                        }//end if let
                    }//end for document
                }//enf if snapshot
            }//end else
        }//end closure
    }//end getFireStoreData
    
}
