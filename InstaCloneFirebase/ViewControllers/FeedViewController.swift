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
    var userID = String()

    @IBOutlet weak var profileImage: UIImageView!
    var img = UIImage()
    
    let firestoreDatabase = Firestore.firestore()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser!.uid

        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarIcons()
    }

    func setupTabBarIcons() {
        templateTabBar(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, tabBarIndex: 0)
        templateTabBar(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, tabBarIndex: 1)
        templateTabBar(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_selected")!, tabBarIndex: 2)
        templateTabBar(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, tabBarIndex: 3)
        templateTabBar(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, tabBarIndex: 4)

    }
    
    private func templateTabBar(unselectedImage: UIImage, selectedImage: UIImage, tabBarIndex: Int) {
        let ref =  tabBarController?.tabBar.items![tabBarIndex]
        ref!.image = unselectedImage.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        ref!.selectedImage = selectedImage.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        ref!.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        ref!.title = " "
    }
    
    
    func getDataFromFirestore(){
           
        firestoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
                
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

    
    
    func makeRounded(picture : UIImageView){
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
    }
}
