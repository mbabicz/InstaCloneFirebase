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
    var postedByUIDArray = [String]()

    
    let firestoreDatabase = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
           
        firestoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
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
                    self.postedByUIDArray.removeAll(keepingCapacity: false)

                    
                    
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
                        
                        if let postedByUID = document.get("postedByUID") as? String{
                            self.postedByUIDArray.append(postedByUID)
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
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 120,height: 120), scaleMode: .fill)

        cell.postedByUIDLabel.text = postedByUIDArray[indexPath.row]

        cell.userImageView.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }

}
