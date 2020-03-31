//
//  CongratulationViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 31/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class CongratulationViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var applicantName: UILabel!
    @IBOutlet weak var mothername: UILabel!
    @IBOutlet weak var fatherName: UILabel!
    @IBOutlet weak var spouseName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var presentAddress: UILabel!
    @IBOutlet weak var permanentAddress: UILabel!
    @IBOutlet weak var nominee: UILabel!
    @IBOutlet weak var relation: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    
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
        self.loadData()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    func loadData(){
        self.profilePic.layer.cornerRadius = 75
        self.profilePic.image = self.profilePicture
        self.applicantName.text = "Name: \(self.userInfoDictionary?["name"] as? String ?? "")"
        self.mothername.text = "Mother's name:  \(self.userInfoDictionary?["mothers_name"] as? String ?? "")"
        self.fatherName.text = "Father's name: \(self.userInfoDictionary?["fathers_name"] as? String ?? "")"
        self.spouseName.text = "Spouse name: \(self.userInfoDictionary?["spouse_name"] as? String ?? "")"
        self.gender.text = "Gender: \(self.userInfoDictionary?["gender"] as? String ?? "")"
        self.profession.text = "Profession: \(self.userInfoDictionary?["profession"] as? String ?? "")"
        self.phoneNumber.text = "Phone Number: \(self.userInfoDictionary?["mobile"] as? String ?? "")"
        self.presentAddress.text = "Present Address: \(self.userInfoDictionary?["present_address"] as? String ?? "")"
        self.permanentAddress.text = "Permanent Address: \(self.userInfoDictionary?["permanent_address"] as? String ?? "")"
        self.nominee.text = "Nominee: \(self.userInfoDictionary?["Nominee"] as? String ?? "")"
        self.relation.text = "Relation With nominee: \(self.userInfoDictionary?["Relation"] as? String ?? "")"
        self.frontImage.image = self.nidImages?[0]
        self.backImage.image = self.nidImages?[1]
    }

   

}
