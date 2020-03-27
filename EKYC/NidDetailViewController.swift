//
//  NidDetailViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 27/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class NidDetailViewController: UIViewController {
    
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
        print(self.userDictionary!)
        self.applicantName.text = self.userDictionary?["name"] as? String
    }


    @IBAction func bacBtnSeledctor(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmSelector(_ sender: Any) {
    }
}
