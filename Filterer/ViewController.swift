//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var originalImage: UIImage?
    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func tapImage(sender: AnyObject) {

    }
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var blackout: UIButton!
    @IBOutlet weak var darken: UIButton!
    @IBOutlet weak var brighten: UIButton!
    @IBOutlet weak var doubleContrast: UIButton!
    @IBOutlet weak var halfBrightness: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compareButton.enabled = false
        originalImage = imageView.image
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func onFilterSelect(sender: UIButton) {
        let pixel = Filter()
        filteredImage = pixel.blackout(imageView.image!)
        compareButton.enabled = true
        return imageView.image = filteredImage
    }
    
    @IBAction func onDarkenButton(sender: UIButton) {
        let pixel = Filter()
        filteredImage = pixel.brightness(imageView.image!, factor: -20)
        compareButton.enabled = true
        return imageView.image = filteredImage
    }
    
    @IBAction func onBrightenButton(sender: UIButton) {
        let pixel = Filter()
        filteredImage = pixel.brightness(imageView.image!, factor: 20)
        compareButton.enabled = true
        return imageView.image = filteredImage
    }
    
    @IBAction func onHalfBrightness(sender: UIButton) {
        let pixel = Filter()
        filteredImage = pixel.halfBrightness(imageView.image!)
        compareButton.enabled = true
        return imageView.image = filteredImage
    }
    
    @IBAction func onDoubleContrast(sender: UIButton) {
        let pixel = Filter()
        filteredImage = pixel.contrast(imageView.image!, factor: 2)
        compareButton.enabled = true
        return imageView.image = filteredImage
    }
    
    @IBAction func onCompare(sender: UIButton) {
        if (sender.selected) {
            UIView.transitionWithView(imageView,
                duration:0.8,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { self.imageView.image = self.filteredImage },
                completion: nil)
            imageView.image = filteredImage
            sender.selected = false
        } else {
            UIView.transitionWithView(imageView,
                duration:0.8,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { self.imageView.image = self.originalImage },
                completion: nil)
            imageView.image = originalImage
            sender.selected = true
        }
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func swapImageWithFade(to: UIImage, from: UIImage) {
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            compareButton.enabled = false
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

