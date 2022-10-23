//
//  PostsCell.swift
//  InstaCloneFirebase
//
//  Created by kz on 18/10/2022.
//

import UIKit

class PostsCell: UICollectionViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var postsImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postsImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailedPostVC))
        postsImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func detailedPostVC(){
        //erformSegue(withIdentifier: "toDetailedPostVC", sender: nil)
    }

    
}

