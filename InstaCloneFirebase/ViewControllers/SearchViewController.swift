//
//  SearchViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 21/10/2022.
//

import UIKit
import SDWebImage
import Firebase

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var ranadomPostsCollectionView: UICollectionView!
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var postsArray = [String]()
    var documentIdArray = [String]()
    var chosenPostID = " "
    let firestoreDatabase = Firestore.firestore()
    
    var usersIDArray = [String]()
    var usernamesArray = [String]()
    var filteredData = [String]()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirestore()
        getUsersFromFirestore()
        
        ranadomPostsCollectionView.delegate = self
        ranadomPostsCollectionView.dataSource = self
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        searchBar.delegate = self
        
        self.ranadomPostsCollectionView.isHidden = false
        self.usersTableView.isHidden = true
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
                        
                        //getting value of postedBy in firebase structure
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
    }
    
    //MARK: usersTableView config
    
    func tableView(_ usersTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return usersIDArray.count
        return filteredData.count
    }
    
    func tableView(_ usersTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        //content.text = usernamesArray[indexPath.row]
        content.text = filteredData[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ usersTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chosenLandmarkName = landmarkNames[indexPath.row]
//        chosenLandmarkImage = landmarkImages[indexPath.row]
//
//        performSegue(withIdentifier: "toDetailsTableView", sender: nil)
    }
    
    //MARK: searchBar config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""{
            filteredData = usernamesArray
        } else{
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
        self.usersTableView.isHidden = false
        self.usersTableView.reloadData()
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.ranadomPostsCollectionView.isHidden = false
        self.usersTableView.isHidden = true
        self.searchBar.endEditing(true)
        self.searchBar.setShowsCancelButton(false, animated: true)

        
    }
    

    
    
    

}
