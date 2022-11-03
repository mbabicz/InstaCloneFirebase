//
//  SearchViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 21/10/2022.
//

import UIKit
import SDWebImage
import Firebase

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ranadomPostsCollectionView: UICollectionView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentUsersTableView: UITableView!
    
    var postsArray = [String]()
    var documentIdArray = [String]()
    var chosenPostID = String()
    var chosenUserID = String()
    var chosenUsername = String()

    
    var usersID = [String]()
    var usernames = [String]()
    var filteredData = [String]()
    
    var recentlySearchedIDs = [String]()
    var recentlySearchedNames = [String]()
    var recentlySearchedPictures = [String]()


    let firestoreDatabase = Firestore.firestore()
    let loggedUserID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirestore()
        getUsersFromFirestore()
        getRecentlySearchedUsers()
        //getDetailedUserInfo()
        
        ranadomPostsCollectionView.delegate = self
        ranadomPostsCollectionView.dataSource = self
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        recentUsersTableView.delegate = self
        recentUsersTableView.dataSource = self
        
        searchBar.delegate = self
        
        self.ranadomPostsCollectionView.isHidden = false
        self.usersTableView.isHidden = true
        self.recentUsersTableView.isHidden = true
        filteredData = usernames
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getUsersFromFirestore(){
        firestoreDatabase.collection("Users").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription as Any)
            } else {
                if(snapshot?.isEmpty != true && snapshot != nil){
                    
                    self.usersID.removeAll(keepingCapacity: false)
                    self.usernames.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let userID = document.documentID
                        self.usersID.append(userID)
                        
                        if let username = document.get("username") as? String{
                            self.usernames.append((username))
                        }
                    }
                    self.usersTableView.reloadData()
                }
            }
        }
    }
    
    func getDataFromFirestore(){
        firestoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
            }
            else{
                if(snapshot?.isEmpty != true && snapshot != nil){
                    
                    self.postsArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.postsArray.append(imageUrl)
                        }
                    }
                    self.ranadomPostsCollectionView.reloadData()
                }
            }
        }
    }
    
    func getRecentlySearchedUsers(){
        firestoreDatabase.collection("Users").document(loggedUserID).collection("Recently searched").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription as Any)
            } else {
                if(snapshot?.isEmpty != true && snapshot != nil){
                    
                    self.recentlySearchedIDs.removeAll(keepingCapacity: false)
                    self.recentlySearchedNames.removeAll(keepingCapacity: false)
                    self.recentlySearchedPictures.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        if let userID = document.get("userID") as? String{
                            self.recentlySearchedIDs.append(userID)
                        }
                    }
                    self.recentUsersTableView.reloadData()
                }
            }
        }
        
    }
    
    
    //MARK: display all posts
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ranadomPostsCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! RandomPostCell
        
        cell.postImageView.sd_setImage(with: URL(string: self.postsArray[indexPath.row]), placeholderImage: nil, context: nil)
        cell.postImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenPostID = documentIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailedPostVC", sender: self)
    }
    
    //MARK: TableView config

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === usersTableView{
            return filteredData.count
            
        } else if tableView === recentUsersTableView{
            return recentlySearchedIDs.count
        }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath ) as! UserCell

        if tableView === usersTableView{
            
            cell.usernameLabel.text = filteredData[indexPath.row]
        } else if tableView === recentUsersTableView{
            cell.userIDLabel.text = recentlySearchedIDs[indexPath.row]
            //cell.usernameLabel.text = recentlySearchedNames[indexPath.row]
            //cell.profileImage.sd_setImage(with: URL(string: self.recentlySearchedPictures[indexPath.row]), placeholderImage: nil, context: nil)
            //cell.profileImage.contentMode = .scaleAspectFill
            //self.makeRounded(picture: cell.profileImage)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenUserID = usersID[indexPath.row]
        chosenUsername = usernames[indexPath.row]
        
        if tableView === usersTableView{
            performSegue(withIdentifier: "toDetailedProfileVC", sender: nil)
            addUserIntoRecentList()
        } else if tableView === recentUsersTableView{
            performSegue(withIdentifier: "toDetailedProfileVC", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView === recentUsersTableView{
            return "Recently searched"
        } else if tableView === usersTableView{
            return nil
        } else{
            return nil
        }
    }
    
    func addUserIntoRecentList(){
        let ref = firestoreDatabase.collection("Users").document(loggedUserID).collection("Recently searched").document(chosenUserID)
            ref.setData([
                "userID" : chosenUserID,
                "username" : chosenUsername,
                "date" : FieldValue.serverTimestamp()
            ])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedPostVC"{
            let destinationTableView = segue.destination as! DetailedPostViewController
            destinationTableView.chosenPostID = chosenPostID
        }
        if segue.identifier == "toDetailedProfileVC"{
            let destinationTableView = segue.destination as! DetailedProfileViewController
            destinationTableView.chosenUserID = chosenUserID
            self.navigationItem.title = ""
        }
    }
    
}
    
    //MARK: searchBar config
    extension SearchViewController: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredData = []
            
            if searchText == ""{
                filteredData = usernames
                self.usersTableView.isHidden = true
                self.recentUsersTableView.isHidden = false
                //self.recentUsersTableView.reloadData()
            } else{
                self.recentUsersTableView.isHidden = true
                self.usersTableView.isHidden = false
                for user in usernames{
                    if user.lowercased().contains(searchText.lowercased()){
                        filteredData.append(user)
                    }
                }
            }
            self.usersTableView.reloadData()
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.ranadomPostsCollectionView.isHidden = true
            self.recentUsersTableView.isHidden = false
            self.usersTableView.isHidden = true
            self.usersTableView.reloadData()
            self.searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.ranadomPostsCollectionView.isHidden = false
            self.recentUsersTableView.isHidden = true
            self.usersTableView.isHidden = true
            self.searchBar.endEditing(true)
            self.searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func makeRounded(picture : UIImageView){
            picture.layer.borderWidth = 1.0
            picture.layer.masksToBounds = false
            picture.layer.borderColor = UIColor.white.cgColor
            picture.layer.cornerRadius = picture.frame.size.width / 2
            picture.clipsToBounds = true
        }
    }
