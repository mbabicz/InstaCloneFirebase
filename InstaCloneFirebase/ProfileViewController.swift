//
//  ProfileViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 10/10/2022.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var username = String()
    var userID = String()

    @IBOutlet weak var profileImage: UIImageView!
    
    var userImagesArray = [String]()
    var documentIdArray = [String]()
    
    let firestoreDatabase = Firestore.firestore()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser!.uid
        
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
        getDataFromFirestore()
        
//        if let flowLayout = postsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//        }
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUsernameLabel()
        loadNumberOfPosts()
        loadNumberOfFollowers()
        loadNumberOfFollowing()
        loadDescription()
        //loadProfileImage()
    }
    
    override func viewWillLayoutSubviews() {
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
            let transformer = SDImageResizingTransformer(size: CGSize(width: 120,height: 120), scaleMode: .fill)
            self.profileImage.sd_setImage(with:URL(string: userImage) ,placeholderImage: nil, context: [.imageTransformer: transformer])
            self.makeRounded(picture: self.profileImage)
        }
        
    }
    
    func getDataFromFirestore(){
        
        firestoreDatabase.collection("Posts").whereField("postedByUID", isEqualTo: userID).order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
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
        //cell.postsImageView.sd_setImage(with: URL(string: self.userImagesArray[indexPath.row]))
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 128,height: 128), scaleMode: .fill)
        cell.postsImageView.sd_setImage(with: URL(string: self.userImagesArray[indexPath.row]), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        return cell
    }

}
