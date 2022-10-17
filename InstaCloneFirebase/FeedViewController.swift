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
    var userProfilePictureArray = [String]()
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
                    self.userProfilePictureArray.removeAll(keepingCapacity: false)
                    
                    
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
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                        
                        let postedByUID = document.get("postedByUID")
                        let ref = fireStoreDatabase.collection("Users").document(postedByUID as! String)
                        ref.getDocument { document, error in
                            guard let document = document, document.exists else{ return }
                            let dataDescription = document.data()
                            var userProfIMG = dataDescription?["profile picture"] as! String
                            self.userProfilePictureArray.append(userProfIMG)
                            print("test \(userProfIMG)")
                                
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
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        
        cell.usernameLabel.text = userEmailArray[indexPath.row]
        
        //cell.userProfilePicture.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.userProfilePicture.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.userProfilePicture.layer.borderWidth = 1.0
        cell.userProfilePicture.layer.masksToBounds = false
        cell.userProfilePicture.layer.borderColor = UIColor.white.cgColor
        cell.userProfilePicture.layer.cornerRadius = cell.userProfilePicture.frame.size.width / 2
        cell.userProfilePicture.clipsToBounds = true
        
        cell.userImageView.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    
//tab

}
