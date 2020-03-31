//
//  ProfilePictureViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 30/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class ProfilePictureViewController: UIViewController, PassImage {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    var userDictionary: [String : Any]?
    var userInfoDictionary: [String : Any]?
    var nidImages: [UIImage]?
    var profilePicture: UIImage?
    
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
        self.profilePic.layer.cornerRadius = 100
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CameraViewController {
            vc.photoDelegate = self
            vc.frontCamera = true
        }
    }
    
    func passImage(image: UIImage) {
        DispatchQueue.main.async {
            self.profilePic.image = image
            self.profilePicture = image
            self.uploadProfilePic(imgeData: (image.jpegData(compressionQuality: 0.5))!, imageName: "image")
        }
    }
    
    func uploadProfilePic(imgeData: Data, imageName: String){
        let parameters = [
            "file_name": "\(imageName)"
        ]
        
        let urlString = "facce_verification"
        APIRequest.shared.uploadImage(requestType: .POST, queryString: urlString, parameter: parameters as [String : AnyObject], imagesData: [imgeData], isHudeShow: true, success: { (success) in
            print(success)
            if let dict = success as? [String : Any] {
                if let status = dict["status"] as? String {
                    if status == "matched" {
                        DispatchQueue.main.async {
                            self.verifyUserInfo()
                        }
                    }
                }
            }
        }) { (fail) in
            print("Failed to upload image")
        }
    }
    
    func verifyUserInfo(){
        let urlString = "verify_nid_data"
        let imgData = self.profilePicture?.jpegData(compressionQuality: 0.5)!
        
        self.userInfoDictionary!["img"] = imgData?.base64EncodedString()
        
        print(self.userInfoDictionary!)
        
        APIRequest.shared.sendRequest(requestType: .POST, queryString: urlString, parameter: self.userInfoDictionary as [String : AnyObject]?, isHudeShow: true, success: { (success) in
            if let dict = success as? [String : Any] {
                if let status = dict["status"] as? Bool {
                    if status {
                        DispatchQueue.main.async {
                            self.pushToOTPViewController()
                        }
                    }
                }
            }
        }) { (fail) in
            print(fail)
        }
    }
    
    func pushToOTPViewController(){
        DispatchQueue.main.async {
            if let otpViewController: OTPViewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController{
               
                otpViewController.userDictionary = self.userDictionary
                otpViewController.userInfoDictionary = self.userInfoDictionary
                otpViewController.nidImages = self.nidImages
                otpViewController.profilePicture = self.profilePicture
                self.navigationController?.pushViewController(otpViewController, animated: false)
            }
        }
    }
}
