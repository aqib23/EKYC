//
//  ViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 25/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PassImage ,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    
    var nidFrontImage: UIImage = UIImage(named: "EKYC_logo")!
    var nidBackImage: UIImage = UIImage(named: "EKYC_logo")!
    var frontSegue = false
    var backSegue = false
    var otpCode = "1558"
    var imag = 1
     var imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            } else {
                UIApplication.shared.statusBarStyle = .default
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.passImage(image: self.nidBackImage)
        
      
        
    }
    
    
    
 
    

    func passImage(image: UIImage) {
        if self.frontSegue {
            self.nidFrontImage = image
        }else if self.backSegue {
            self.nidBackImage = image
        }
        //if self.nidFrontImage != nil , self.nidBackImage != nil {
            DispatchQueue.main.async {
                self.uploadButton.backgroundColor = UIColor(red: 86.0/255.0, green: 199.0/255.0, blue: 240.0/255.0, alpha: 1.0)
                self.uploadButton.isUserInteractionEnabled = true
            }
        //}
    }
    
    func uploadNid(){
        let frontImage = self.nidFrontImage
        let backImage = self.nidBackImage
        
        let parameters = [
            "file_name1": "frontNIDImage",
            "file_name2": "backNIDImage"
        ]
        
        let imagesData: [Data] = [frontImage.jpegData(compressionQuality: 0.1)!, backImage.jpegData(compressionQuality: 0.1)!]
        
        let urlString = "parse_nid"
        APIRequest.shared.uploadImage(requestType: .POST, queryString: urlString, parameter: parameters as [String : AnyObject], imagesData: imagesData, isHudeShow: true, success: { (success) in
            print(success)
            if let dict = success as? [String : Any] {
                print(dict)
                self.pushToNidInfo(dict: dict)
            }
        }) { (fail) in
            print("Failed to upload image")
        }
    }
    
    func pushToNidInfo(dict: [String : Any]){
        DispatchQueue.main.async {
            if let nidDetailViewController: NidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NidDetailViewController") as? NidDetailViewController{
               
                    nidDetailViewController.userDictionary = dict
                nidDetailViewController.nidImages = [self.nidFrontImage,self.nidBackImage]
                self.navigationController?.pushViewController(nidDetailViewController, animated: false)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CameraViewController {
            vc.photoDelegate = self
        }
        
        if segue.identifier == "frontPhoto" {
            self.frontSegue = true
            self.backSegue = false
        }
        
        if segue.identifier == "backPhoto" {
            self.frontSegue = false
            self.backSegue = true
        }
    }
    
    @IBAction func uploadButtonSelector(_ sender: Any) {
        self.uploadNid()
    }
    
    @IBAction func firstPhoto(_ sender: Any) {
        imag = 1
        fromGallery()
    }
    
    
    @IBAction func secondPhoto(_ sender: Any) {
        imag = 2
        fromGallery()
    }
    
    func fromGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if(imag == 1){
            self.nidFrontImage = image
        }else {
            self.nidBackImage = image
        }
        
        DispatchQueue.main.async {
            self.uploadButton.backgroundColor = UIColor(red: 86.0/255.0, green: 199.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            self.uploadButton.isUserInteractionEnabled = true
        }
        
        
         
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
