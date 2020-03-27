//
//  ViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 25/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PassImage {

    var nidImage: UIImage?
    
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
    }

    func passImage(image: UIImage) {
        self.nidImage = image
        self.uploadNid(imgeData: (self.nidImage?.jpegData(compressionQuality: 0.5))!, imageName: "image")
    }
    
    func uploadNid(imgeData: Data, imageName: String){
        let parameters = [
            "file_name": "\(imageName)"
        ]
        
        let urlString = "parse_nid"
        APIRequest.shared.uploadImage(requestType: .POST, queryString: urlString, parameter: parameters as [String : AnyObject], imageData: imgeData, isHudeShow: true, success: { (success) in
            print(success)
            var dict: [String: Any] = [:]
            if var str = success as? String {
                str = str.replacingOccurrences(of: "\n", with: "")
                str = str.replacingOccurrences(of: " ", with: "")
                let d = self.convertToDictionary(text: str)
                print(d ?? [])
                let nidArr = str.components(separatedBy: ",")
                for component in nidArr {
                    let arr = component.components(separatedBy: ":")
                    dict[arr[0]] = arr[1]
                }
            }
            self.pushToNidInfo(dict: dict)
        }) { (fail) in
            print("Failed to upload image")
        }
    }
    
    func pushToNidInfo(dict: [String : Any]){
        DispatchQueue.main.async {
            if let nidDetailViewController: NidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "NidDetailViewController") as? NidDetailViewController{
               
                    nidDetailViewController.userDictionary = dict
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
    }
}
