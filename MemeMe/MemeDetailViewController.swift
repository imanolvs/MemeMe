//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Imanol Viana Sánchez on 13/2/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    
    var detailMeme: Meme!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        tabBarController?.tabBar.hidden = true
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("editButtonMethod"))
        self.navigationItem.rightBarButtonItem = editButton
        
        imageView.image = detailMeme.memedImage
    }
    
    func editButtonMethod()
    {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        controller.defaultImage = detailMeme.image
        controller.defaultTopText = detailMeme.topText
        controller.defaultBottomText = detailMeme.bottomText
        controller.shareButtonEnabled = true
        navigationController?.pushViewController(controller, animated: true)
    }
}