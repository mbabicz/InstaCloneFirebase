//
//  DetailedPostViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 24/10/2022.
//

import UIKit
import Firebase
import SDWebImage

class DetailedPostViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var chosenPostIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    
    
    var chosenPostID = ""
    let firestoreDatabase = Firestore.firestore()
    var userID = String()
    var postOwnerID = String()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenPostIDLabel.text = chosenPostID
        userID = Auth.auth().currentUser!.uid
        
        getOwnerDataFromFirestore()
        getPostDataFromFirestore()

    }
    
    func getOwnerDataFromFirestore(){
        let ref = firestoreDatabase.collection("Posts").document(chosenPostID)
        ref.getDocument{ document, error in
            guard let document = document, document.exists else { return }
            let dataDescription = document.data()
            self.postOwnerID = dataDescription?["postedByUID"] as! String
            let ref = self.firestoreDatabase.collection("Users").document(self.postOwnerID)
            ref.getDocument{ document, error in
                guard let document = document, document.exists else { return }
                let transformer = SDImageResizingTransformer(size: CGSize(width: 35, height: 32), scaleMode: .fill)
                let dataDescription = document.data()
                if let profilePictureURL = dataDescription?["profile picture"] as? String{
                    self.profileImage.sd_setImage(with: URL(string: profilePictureURL), placeholderImage: nil, context: [.imageTransformer: transformer])
                    self.makeRounded(picture: self.profileImage)

                }
                if let username = dataDescription?["username"] as? String{
                    self.usernameLabel.text = username

                }
            }
        }
        
    }
    
    func getPostDataFromFirestore(){
        let ref = firestoreDatabase.collection("Posts").document(chosenPostID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else { return }
            let dataDescription = document.data()
            
            let transformer = SDImageResizingTransformer(size: CGSize(width: 390, height: 290), scaleMode: .fill)
            if let imageURL = dataDescription?["imageUrl"] as? String{
                self.postImage.sd_setImage(with:URL(string: imageURL), placeholderImage:  nil, context: [.imageTransformer: transformer])
            }
            
            if let description = dataDescription?["commentText"] as? String{
                self.postDescription.text = description
            }
                
            if let likes = dataDescription?["likes"] as? Int{
                self.likesLabel.text = String(likes)
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
