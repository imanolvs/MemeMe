//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Imanol Viana Sánchez on 13/2/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController
{
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBarHidden = false
        
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.itemSize = CGSizeMake(120, 120)
        
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        cell.imageView.contentMode = .ScaleAspectFill
        cell.imageView.image = memes[indexPath.row].image
        cell.topLabel.attributedText = setAttributeText(self.memes[indexPath.row].topText)
        cell.bottomLabel.attributedText = setAttributeText(self.memes[indexPath.row].bottomText)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.detailMeme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)

    }
    
    func setAttributeText(string: String) -> NSAttributedString
    {
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName : -3.0]
        
        return NSAttributedString(string: string, attributes: textAttributes)
    }
    
    @IBAction func sendMeme(sender: UIBarButtonItem) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        controller.shareButtonEnabled = false
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}



