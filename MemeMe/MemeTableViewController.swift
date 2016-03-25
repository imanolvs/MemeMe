//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Imanol Viana Sánchez on 13/2/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var memes : [Meme]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBarHidden = false
        memes = getCurrentMemesArray()
        
        self.tableView.reloadData()
    }

    
    func getCurrentMemesArray() -> [Meme]
    {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    func removeMemeFromArray(row: Int)
    {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell
        
        cell.customImageView.image = self.memes[indexPath.row].image
        cell.topLabel.attributedText = setAttributeText(self.memes[indexPath.row].topText)
        cell.bottomLabel.attributedText = setAttributeText(self.memes[indexPath.row].bottomText)
        cell.titleLabel.text = self.memes[indexPath.row].topText + " " + self.memes[indexPath.row].bottomText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.detailMeme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            removeMemeFromArray(indexPath.row)
            memes = getCurrentMemesArray()
            tableView.reloadData()
        }
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
    
    @IBAction func sendMeme(sender: UIBarButtonItem)
    {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        controller.shareButtonEnabled = false
        
        navigationController?.pushViewController(controller, animated: true)
    }
}