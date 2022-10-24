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

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFirestore()
        
        ranadomPostsCollectionView.delegate = self
        ranadomPostsCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true ).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                
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

        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 128,height: 128), scaleMode: .fill)
        cell.postImageView.sd_setImage(with: URL(string: self.postsArray[indexPath.row]), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        return cell
    }

}
