//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Imanol Viana Sánchez on 10/2/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    var defaultImage = UIImage()
    var defaultTopText = "TOP"
    var defaultBottomText = "BOTTOM"
    var shareButtonEnabled = false
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName : -3.0]

    
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.contentMode = .ScaleAspectFit
        initTextField(topTextField)
        initTextField(bottomTextField)
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        imageView.image = defaultImage
        shareButton.enabled = shareButtonEnabled
        
    }
    
    func initTextField(textField: UITextField) {
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBarHidden = true

        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        shareButton.enabled = shareButtonEnabled
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = image
        }
        
        shareButtonEnabled = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem)
    {
        pickAnImageFrom(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem)
    {
        pickAnImageFrom(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject)
    {
        let activityController: UIActivityViewController
        let memedImage = generatedMemedImage()
        
        activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler =
        {
            (activity, success, items, error) in
            if success
            {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else
            {
                self.navigationController?.navigationBarHidden = true
            }
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if bottomTextField.editing
        {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func save(memedImage: UIImage)
    {        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generatedMemedImage() -> UIImage
    {
        //Hide toolbar and navbar
        toolbar.hidden = true
        shareToolbar.hidden = true
        navigationController?.navigationBarHidden = true
        let backgroundColor = self.view.backgroundColor
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Hide toolbar and navbar
        toolbar.hidden = false
        shareToolbar.hidden = false
        navigationController?.navigationBarHidden = false
        self.view.backgroundColor = backgroundColor
        
        return memedImage
    }
}












