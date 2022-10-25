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
import SDWebImage

class FeedCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var postedByUIDLabel: UILabel!
    
    let firestoreDatabase = Firestore.firestore()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setPostOwnerProfileImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        
        let ref = firestoreDatabase.collection("Posts").document(self.documentIdLabel.text!).collection("Likes").document(userID)
        
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
                            self.firestoreDatabase.collection("Posts").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                        }
                    }
                }
            }
            else{
                //* giving like
                //getting username
                var username = String()
                let docRef = self.firestoreDatabase.collection("Users").document(userID)
                docRef.getDocument { document, error in
                    guard let document = document, document.exists else{ return }
                    let dataDescription = document.data()
                    username = dataDescription?["username"] as! String
                }
                
                //adding like with liker details to database
                self.self.firestoreDatabase.collection("Posts").document(self.documentIdLabel.text!).collection("Likes").document(userID).setData([
                    "likedBy" : username,
                    "likedByUID" : userID,
                    "date of like" : FieldValue.serverTimestamp()
                ])
                
                //counting likes
                if let likeCount = Int(self.likeLabel.text!){
                    let likeStore = ["likes" : likeCount + 1] as [String : Any]
                    self.firestoreDatabase.collection("Posts").document(self.documentIdLabel.text!).setData(likeStore, merge: true)
                }
            }
        }
        
    }
    
    func setPostOwnerProfileImage(){
        
        let ref = firestoreDatabase.collection("Users").document(self.postedByUIDLabel.text!)
            ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let transformer = SDImageResizingTransformer(size: CGSize(width: 120,height: 120), scaleMode: .fill)
            let dataDescription = document.data()
                
            if let imageUrl = dataDescription?["profile picture"] as? String{
                self.userProfilePicture.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, context: [.imageTransformer: transformer])
                self.makeRounded(picture: self.userProfilePicture)
            }
        }
        
    }
    
    func makeRounded(picture : UIImageView){
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
    }
    



}
