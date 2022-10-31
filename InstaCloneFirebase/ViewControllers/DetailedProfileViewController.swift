//
//  DetailedProfileViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 28/10/2022.
//

import UIKit
import Firebase
import SDWebImage

class DetailedProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var chosenUserID = String()
    let firestoreDatabase = Firestore.firestore()
    
    var userImagesArray = [String]()
    var documentIdArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDLabel.text = chosenUserID
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self

        getUserDataFromFirestore()
        getPostsFromFirestore()
    }
    
    func getUserDataFromFirestore(){
        let ref = firestoreDatabase.collection("Users").document(chosenUserID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            
            if let username = dataDescription?["username"] as? String{
                self.usernameLabel.text = username
            }

            if let description = dataDescription?["description"] as? String{
                self.descriptionLabel.text = description
            }
            
           if let userImage = dataDescription?["profile picture"] as? String{
                self.profileImage.sd_setImage(with:URL(string: userImage) ,placeholderImage: nil, context: nil)
                self.profileImage.contentMode = .scaleAspectFill
                self.makeRounded(picture: self.profileImage)
            }
            
            //tbc
            self.postsLabel.text = String(1)
            self.followersLabel.text = String(2)
            self.followingLabel.text = String(3)

        }

    }
    
    func getPostsFromFirestore(){
        let ref =         firestoreDatabase.collection("Posts").whereField("postedByUID", isEqualTo: chosenUserID).order(by: "date", descending: true )
        ref.addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
            }
            else{
                if(snapshot?.isEmpty != true && snapshot != nil){
                    
                    self.userImagesArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        //getting value of postedBy in firebase structure
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImagesArray.append(imageUrl)
                        }
                    }
                    
                    self.postsCollectionView.reloadData()
                }
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostsCell

        cell.postsImageView.sd_setImage(with: URL(string: self.userImagesArray[indexPath.row]), placeholderImage: nil, context: nil)
        cell.postsImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        chosenPostID = documentIdArray[indexPath.row]
//        performSegue(withIdentifier: "toDetailedPostVC", sender: self)
//    }


}
