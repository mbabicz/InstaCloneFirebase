//
//  SearchViewController.swift
//  InstaCloneFirebase
//
//  Created by kz on 21/10/2022.
//

import UIKit
import SDWebImage
import Firebase

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var ranadomPostsCollectionView: UICollectionView!
    
    var postsArray = [String]()
    var documentIdArray = [String]()
    var chosenPostID = " "

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirestore()
        
        ranadomPostsCollectionView.delegate = self
        ranadomPostsCollectionView.dataSource = self

    }
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
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
    
    

}
