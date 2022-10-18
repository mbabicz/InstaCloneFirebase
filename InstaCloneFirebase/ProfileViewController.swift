//
//  ProfileViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 10/10/2022.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var username = String()
    var userID = String()
    let firestoreDatabase = Firestore.firestore()
    @IBOutlet weak var profileImage: UIImageView!
    
    var userImagesArray = [String]()
    var documentIdArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser!.uid
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        getDataFromFirestore()
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsernameLabel()
        loadNumberOfPosts()
        loadNumberOfFollowers()
        loadNumberOfFollowing()
        loadDescription()
        loadProfileImage()
    }
    

    @IBAction func profileSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "toProfileSettings", sender: nil)
    }
    
    func loadUsernameLabel(){
        
        let ref = firestoreDatabase.collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            self.username = dataDescription?["username"] as! String
            self.usernameLabel.text = self.username
        }
    }
    
    func loadNumberOfPosts(){
        
        
        self.postsLabel.text = String(1)
    }
    
    func loadNumberOfFollowers(){
        
        self.followersLabel.text = String(2)
    }
    
    func loadNumberOfFollowing(){
        
        self.followingLabel.text = String(3)
    }
    
    func loadDescription(){
        let ref = firestoreDatabase.collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else{ return }
            let dataDescription = document.data()
            var userDescription = dataDescription?["description"] as! String
            self.descriptionLabel.text = userDescription
        }
        
    }
    
    func loadProfileImage(){
        let ref = firestoreDatabase.collection("Users").document(userID)
        ref.getDocument { document, error in
            guard let document = document, document.exists else { return }
            let dataDescription = document.data()
            var userImage = dataDescription?["profile picture"] as! String
            self.profileImage.sd_setImage(with:URL(string: userImage))
            self.profileImage.layer.borderWidth = 1.0
            self.profileImage.layer.masksToBounds = false
            self.profileImage.layer.borderColor = UIColor.white.cgColor
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
        }
        
    }
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                
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
                    //self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostsCell
        cell.postsImageView.sd_setImage(with: URL(string: self.userImagesArray[indexPath.row]))
        return cell
    }

}
