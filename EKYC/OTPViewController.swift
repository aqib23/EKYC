//
//  OTPViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 30/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var otpTextfield: TweeActiveTextField!
    
    var userDictionary: [String : Any]?
    var otpCode = ""
    
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
        self.getOTpCode()
    }
    

    @IBAction func submitOtpSelector(_ sender: Any) {
        guard self.otpTextfield.text != "" else {
            return
        }
        if otpCode == self.otpTextfield.text {
            print("OTP matched!!!!!")
        }
    }
    

    func getOTpCode() {
        let urlString = "generate_otp"
        
        let parameter: [String : Any] = ["nid" : self.userDictionary?["nid"] ?? ""]
        
        APIRequest.shared.sendRequest(requestType: .POST, queryString: urlString, parameter: parameter as [String : AnyObject], isHudeShow: true, success: { (success) in
            print(success)
            if let dict = success as? [String : Any] {
                self.otpCode = dict["otp"] as! String
            }
        }) { (fail) in
            print(fail)
        }
    }
    
    
}
