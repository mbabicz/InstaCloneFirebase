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
    let firestoreDatabase = Firestore.firestore()
    
    var usersIDArray = [String]()
    var usernamesArray = [String]()
    var filteredData = [String]()
    var chosenUserID = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirestore()
        getUsersFromFirestore()
        
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
        filteredData = usernamesArray
        
    }
    
    func getUsersFromFirestore(){
        firestoreDatabase.collection("Users").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription as Any)
            } else {
                if(snapshot?.isEmpty != true && snapshot != nil){
                    self.usersIDArray.removeAll(keepingCapacity: false)
                    self.usernamesArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let userID = document.documentID
                        self.usersIDArray.append(userID)
                        
                        if let username = document.get("username") as? String{
                            self.usernamesArray.append((username))
                            print(username)
                        }
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedPostVC"{
            let destinationTableView = segue.destination as! DetailedPostViewController
            destinationTableView.chosenPostID = chosenPostID
        }
        if segue.identifier == "toDetailedProfileVC"{
            let destinationTableView = segue.destination as! DetailedProfileViewController
            destinationTableView.chosenUserID = chosenUserID
        }
    }
    
    //MARK: usersTableView config

    func tableView(_ usersTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return usersIDArray.count
        return filteredData.count
    }
    
    func tableView(_ usersTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = filteredData[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ usersTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenUserID = usersIDArray[indexPath.row]
        performSegue(withIdentifier: "toDetailedProfileVC", sender: nil)
        //add user to recent list
        addUserIntoRecentList()
    }
    
    func addUserIntoRecentList(){
        let loggedUserID = Auth.auth().currentUser!.uid
        let ref = firestoreDatabase.collection("Users").document(loggedUserID).collection("Recently searched").document(chosenUserID)
            ref.setData([
                "userID" : chosenUserID,
                "date" : FieldValue.serverTimestamp()
            ])
    }
    
}
    
    
    //MARK: searchBar config
    extension SearchViewController: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredData = []
            
            if searchText == ""{
                filteredData = usernamesArray
                self.usersTableView.isHidden = true
                self.recentUsersTableView.isHidden = false
                //jesli self.recentUsersTableView.reloadData()
                
            } else{
                self.recentUsersTableView.isHidden = true
                self.usersTableView.isHidden = false
                for user in usernamesArray{
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
    }
