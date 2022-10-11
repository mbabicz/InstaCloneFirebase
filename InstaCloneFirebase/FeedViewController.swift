//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 01/10/2022.
//


import UIKit
import Firebase
import SDWebImage
 
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
  
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                
            }
            else{
                if(snapshot?.isEmpty != true && snapshot != nil){
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        //getting value of postedBy in firebase structure
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("commentText") as? String{
                            self.userCommentArray.append(postComment)
                        }
//                        if let likes = document.get("likes") as? Int{
//                            self.likeArray.append(likes)
//                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                        
                        
                        let docRef = fireStoreDatabase.collection("Posts").document(documentID).collection("Likes").addSnapshotListener{ (snapshot, error) in
                        if error != nil{
                            print(error?.localizedDescription)
                            
                        }
                        else{
                            if(snapshot?.isEmpty != true && snapshot != nil){
                                
                                var count = 0
                                for document in snapshot!.documents{
                                    count += 1
                                }
                                self.likeArray.append(count)
                            }
                            else{
                                self.likeArray.append(0)
                            }
                        }
                    }
                        

                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.likeLabel.text = "Polubienia: \(String(likeArray[indexPath.row]))"
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.usernameLabel.text = userEmailArray[indexPath.row]
        cell.userImageView.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }

}
