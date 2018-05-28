//
//  ViewController.swift
//  SeeFood
//
//  Created by Mario Muhammad on 29.05.18.
//  Copyright © 2018 Mario Muhammad. All rights reserved.
//

import UIKit
import CoreML
import Vision

// TODO: 1. Delegate the controller
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    // TODO: 2. Create a new oject
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 3. Set up image picker to allow user use front/back camera.
        // Image cannot be edited, allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userpickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userpickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

