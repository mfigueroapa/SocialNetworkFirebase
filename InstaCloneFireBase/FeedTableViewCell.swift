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
    
            
            
        }
        
        
    }
    
    
    
    
//        @IBAction func likeButtonClicked(_ sender: Any) {
//            let fireStoreData = Firestore.firestore()
//            if let likeCount = Int(likeLabel.text!) {
//
//    //            if likedByUsersArr.contains(<#T##element: String##String#>)
//
//
//                let likeStore = ["likes" : likeCount + 1] as [String : Any] //if let bacause we want to convert it to Int
//
//
//                var usersIdElement = String()
//                usersIdElement = (Auth.auth().currentUser?.email!)!
//                likedByUsersArr.append(usersIdElement)
//
//                let likedByUsers = ["likedByUsers" : likedByUsersArr] as [String : Any]
//
//                fireStoreData.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
//                fireStoreData.collection("Posts").document(documentIdLabel.text!).setData(likedByUsers, merge: true)
//
//
//
//            }
//
//
//        }
    
    
    
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
