//
//  ViewController.swift
//  CameraAndPhotoLibrary
//
//  Created by Sunny NG on 21/2/2017.
//  Copyright © 2017 Sunny NG. All rights reserved.
//

import UIKit
import MobileCoreServices


// implements UIImagePickerControllerDelegate and UINavigationControllerDelegate
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    // outlect connecting to image view in storyboard
    @IBOutlet weak var imageView: UIImageView!
    
    // indicates whether it's a new photo or not
    var isANewPhoto: Bool?
    
    
    // User chooses to take a photo with camera
    @IBAction func takePhoto(_ sender: Any) {
        //print("taking photo ...")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            isANewPhoto = true
        }
    }
    
    
    // User chooses to choose a existing photo from photo library
    @IBAction func chooseFromPhotoLibrary(_ sender: Any) {
        //print("open up UIImagePickerController")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            isANewPhoto = false
        }
    }
    
    
    // delete methods to be invoked by UIImagePickerController after user successfully take a photo or choose a photo from photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            
            // if this a new photo that user take with camera, we will probably like to save it to photo libray
            if isANewPhoto == true {
              UIImageWriteToSavedPhotosAlbum(image, self, 
                                          #selector(ViewController.image(image:didFinishSavingWithError:contextInfo:)),
                                          nil)
            }
        }
        else if mediaType.isEqual(to: kUTTypeMovie as String) {
            // if need to handle video type request, add codes to save video
        }
     
    }
    
    // delegate method to invoke if it fails to save the media
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Failed!", message: "Failed to save photo", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    // delegate method to invoke when user choose to cancel take a photo or exit from choosing file
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        //print("user cancel action")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

