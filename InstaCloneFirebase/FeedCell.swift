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
        
//        let fireStoreDatabase = Firestore.firestore()
//        if let likeCount = Int(likeLabel.text!){
//            let likeStore = ["likes" : likeCount + 1] as [String : Any]
//
//            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
//        }
        
        let fireStoreDatabase = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        var username = ""
        let docRef = fireStoreDatabase.collection("Users").document(userID ?? "")
        
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else{
                print("doc does not exist")
                return
            }
            let dataDescription = document.data()
            print(dataDescription?["username"] as! String)
            username = dataDescription?["username"] as! String
        }
            
            //dodaj usera do listy z userid
            fireStoreDatabase.collection("Posts").document(self.documentIdLabel.text!).collection("Likes").document(userID).setData([
                "likedBy" : username,
                "likedByUID" : userID,
                "date of like" : FieldValue.serverTimestamp()
            ])
        
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
