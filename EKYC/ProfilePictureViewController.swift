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
            self.uploadProfilePic(imgeData: (image.jpegData(compressionQuality: 0.5))!, imageName: "image")
        }
    }
    
    func uploadProfilePic(imgeData: Data, imageName: String){
        let parameters = [
            "file_name": "\(imageName)"
        ]
        
        let urlString = "facce_verification"
        APIRequest.shared.uploadImage(requestType: .POST, queryString: urlString, parameter: parameters as [String : AnyObject], imageData: imgeData, isHudeShow: true, success: { (success) in
            print(success)
            if let dict = success as? [String : Any] {
                DispatchQueue.main.async {
                    self.pushToOTPViewController()
                }
            }
        }) { (fail) in
            print("Failed to upload image")
        }
    }
    
    func pushToOTPViewController(){
        DispatchQueue.main.async {
            if let otpViewController: OTPViewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController{
               
                otpViewController.userDictionary = self.userDictionary
                self.navigationController?.pushViewController(otpViewController, animated: false)
            }
        }
    }
}
