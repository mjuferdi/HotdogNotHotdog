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
import SVProgressHUD

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
        
        // TODO: 4. Change UIImage as CIImage
        if let userpickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userpickedImage
            
            guard let ciImage = CIImage(image: userpickedImage) else {fatalError("Could not convert UIImage into CIImage")}
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // TODO: 5. Use CoreML to recognize image, is it a hotdog?
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Loading CoreML Model failed.")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("Model failed to process image")}
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    SVProgressHUD.showSuccess(withStatus: "This is a hot dog")
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    self.navigationItem.title = "Hot dog"
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.green]
                    
                } else {
                    SVProgressHUD.showError(withStatus: "This is not a hot dog")
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    self.navigationItem.title = "Not Hot dog"
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]

                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

