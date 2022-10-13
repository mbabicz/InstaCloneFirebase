//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by kz on 04/10/2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    

    @IBOutlet weak var documentIdLabel: UILabel!
    
    @IBAction func likeButton(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        
        let ref = fireStoreDatabase.collection("Posts").document(self.documentIdLabel.text!).collection("Likes").document(userID)
        
        //checking if user has already liked this post
        ref.getDocument { document, error in
            if (document?.exists)! {
                print("like exists")
                ref.delete() { err in
                    if let err = err {
                        print("can't delete like, error: \(err)")
                    } else{
                        print("like deleted successfully")
                        //counting likes
                        if let likeCount = Int(self.likeLabel.text!){
                            let likeStore = ["likes" : likeCount - 1] as [String : Any]
                            fireStoreDatabase.collection("Posts").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                        }
                    }
                }
            }
            else{
                //* giving like
                //getting username
                var username = String()
                let docRef = fireStoreDatabase.collection("Users").document(userID)
                docRef.getDocument { document, error in
                    guard let document = document, document.exists else{ return }
                    let dataDescription = document.data()
                    username = dataDescription?["username"] as! String
                }
                
                //adding like with liker details to database
                fireStoreDatabase.collection("Posts").document(self.documentIdLabel.text!).collection("Likes").document(userID).setData([
                    "likedBy" : username,
                    "likedByUID" : userID,
                    "date of like" : FieldValue.serverTimestamp()
                ])
                
                //counting likes
                if let likeCount = Int(self.likeLabel.text!){
                    let likeStore = ["likes" : likeCount + 1] as [String : Any]
                    fireStoreDatabase.collection("Posts").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                }
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
