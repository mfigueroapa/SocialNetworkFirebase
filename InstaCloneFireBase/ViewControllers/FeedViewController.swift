//
//  FeedViewController.swift
//  InstaCloneFireBase
//
//  Created by Mauricio Figueroa on 27/02/20.
//  Copyright © 2020 Mauricio Figueroa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
import OneSignal

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    let fireStoreDatabase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getFireStoreData()
        
        ///Player IDs
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let playerId = status.subscriptionStatus.userId
        
        if let playerNewId = playerId {
            fireStoreDatabase.collection("PlayerId").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
                if error == nil {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let playerIDFromFirebase = document.get("player_id") as? String {
                                let documentId = document.documentID
                                
                                if playerNewId != playerIDFromFirebase {
                                    let playerIdDictionary = ["email" : Auth.auth().currentUser!.email!, "player_id": playerId]
                                    self.fireStoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { (error) in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                        }//end if
                                    }//end closure
                                }
    
                            }
                        }
                    } else {
                        let playerIdDictionary = ["email" : Auth.auth().currentUser!.email!, "player_id": playerId]
                        self.fireStoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { (error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }//end if
                        }
                    }
                }
            }
        }//end if let
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell//
        
    }
    
    func getFireStoreData() {
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    /////////Cleaning each array to avoid duplicates
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents { //contains all of the documents of the posts collection
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
              
                        if let postedBy = document.get("postedBy") as? String { //casting
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
               
            }
        }
    }
    
    
    
}
