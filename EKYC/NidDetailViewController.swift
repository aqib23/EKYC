//
//  NidDetailViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 27/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class NidDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var applicantName: TweeActiveTextField!
    @IBOutlet weak var motherName: TweeActiveTextField!
    @IBOutlet weak var fatherName: TweeActiveTextField!
    @IBOutlet weak var spouseName: TweeActiveTextField!
    @IBOutlet weak var gender: TweeActiveTextField!
    @IBOutlet weak var profession: TweeActiveTextField!
    @IBOutlet weak var phoneNumber: TweeActiveTextField!
    @IBOutlet weak var presentAddress: TweeActiveTextField!
    @IBOutlet weak var permanentAddress: TweeActiveTextField!
    @IBOutlet weak var nominee: TweeActiveTextField!
    @IBOutlet weak var relation: TweeActiveTextField!
    
    
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
        
        self.fillDataOfTextfield()
    }
    
    func fillDataOfTextfield(){
        self.applicantName.text = self.userDictionary?["name"] as? String
        self.motherName.text = self.userDictionary?["mothers_name"] as? String
        self.fatherName.text = self.userDictionary?["fathers_name"] as? String
    }


    @IBAction func bacBtnSeledctor(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmSelector(_ sender: Any) {
        self.postUserInfo()
    }
    
    func postUserInfo(){
        let parameter: [String : Any] = ["nid" : self.userDictionary?["nid"] ?? "",
                                         "dob" : self.userDictionary?["dob"] ?? "",
                                         "name" : self.applicantName.text ?? "",
                                         "bengali_name" : self.userDictionary?["bengali_name"] ?? "",
                                         "fathers_name" : self.fatherName.text ?? "",
                                         "mothers_name" : self.motherName.text ?? "",
                                         "spouse_name" : self.spouseName.text ?? "",
                                         "gender" : self.gender.text ?? "",
                                         "profession" : self.profession.text ?? "",
                                         " mobile" : self.phoneNumber.text ?? "",
                                         "present_address" : self.presentAddress.text ?? "",
                                         "permanent_address" : self.permanentAddress.text ?? "",
                                         "Nominee" : self.nominee.text ?? "" ,
                                         "Relation" : self.relation.text ?? ""]
        
        APIRequest.shared.sendRequest(requestType: .POST, queryString: "insert_nid_info", parameter: parameter as [String : AnyObject], isHudeShow: true, success: { (success) in
            if let dict = success as? [String : Any] {
                if let status = dict["status"] as? Bool {
                    if status {
                        DispatchQueue.main.async {
                            self.pushToProfilePic()
                        }
                    }
                }
            }
        }) { (fail) in
            print(fail)
        }
        
    }
    
    func pushToProfilePic(){
        DispatchQueue.main.async {
            if let profilePictureViewController: ProfilePictureViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePictureViewController") as? ProfilePictureViewController{
               
                profilePictureViewController.userDictionary = self.userDictionary
                self.navigationController?.pushViewController(profilePictureViewController, animated: false)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
