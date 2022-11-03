//
//  UserCell.swift
//  InstaCloneFirebase
//
//  Created by kz on 03/11/2022.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {

    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    let firestoreDatabase = Firestore.firestore()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //getUserInfoFromDatabase()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getUserInfoFromDatabase(){
        self.firestoreDatabase.collection("Users").document(userIDLabel.text!).getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            
            if let username = dataDescription?["username"] as? String{
                self.usernameLabel.text = username
            }
//            if let userImage = dataDescription?["profile picture"] as? String{
//                //self.recentlySearchedPictures.append(userImage)
//            }
        }
    }

}
