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
    
    @IBOutlet weak var postImage: UIImageView!
    
    
    
    
    var chosenPostID = ""
    let firestoreDatabase = Firestore.firestore()
    var userID = String()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenPostIDLabel.text = chosenPostID
        userID = Auth.auth().currentUser!.uid
        
        loadPostImage()

        // Do any additional setup after loading the view.
    }
    
    
    func loadProfileImage(){
//        let ref = firestoreDatabase.collection("Users").document(userID)
//        ref.getDocument { document, error in
//            guard let document = document, document.exists else { return }
//            let dataDescription = document.data()
//            var userImage = dataDescription?["profile picture"] as! String
//            let transformer = SDImageResizingTransformer(size: CGSize(width: 120,height: 120), scaleMode: .fill)
//            self.profileImage.sd_setImage(with:URL(string: userImage) ,placeholderImage: nil, context: [.imageTransformer: transformer])
//            self.makeRounded(picture: self.profileImage)
        //}
        
    }
    
    
    func loadPostImage(){
        let ref = firestoreDatabase.collection("Posts").document(chosenPostID)
        ref.getDocument{ document, error in
            guard let document = document, document.exists else { return }
            let dataDescription = document.data()
            var imageURL = dataDescription?["imageUrl"] as! String
            let transformer = SDImageResizingTransformer(size: CGSize(width: 390, height: 290), scaleMode: .fill)
            self.postImage.sd_setImage(with:URL(string: imageURL), placeholderImage:  nil, context: [.imageTransformer: transformer])
   
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
