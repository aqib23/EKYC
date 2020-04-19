//
//  Constants.swift
//  EKYC
//
//  Created by Sium_MBSTU on 27/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import Foundation
import UIKit

var baseUrl1 =  "http://35.240.221.96:6000/"
var baseUrl = "https://mockekyc.free.beeceptor.com/"


let parse_nid          = "parse_nid"
let facce_verification = "facce_verification"
let insert_nid_info    = "insert_nid_info"
let verify_nid_data    = "verify_nid_data"
let generate_otp       = "generate_otp"


typealias SUCCESS = (_ response:Any)->()
typealias FAIL = (_ response:Any)->()



@IBDesignable
class ProgressHud: UIView {
    fileprivate static let rootView = {
        return UIApplication.shared.keyWindow!
    }()
    
    fileprivate static let blurView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.alpha = 0.2
        return view
    }()
    fileprivate static let hudView:UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.clear
         view.layer.cornerRadius = 6.0
         view.clipsToBounds = true
         view.layoutIfNeeded()
         return view
    }()
    fileprivate static let activity:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.style = .whiteLarge
        view.hidesWhenStopped = false
        view.color = UIColor.black
        
       return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    static func show(){
        rootView.addSubview(blurView)
        self.addObserver()
        self.addActivity()
    }
    static func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc static func rotated(){
        print(UIScreen.main.bounds)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("landscape")
        default:
            print("Portrait")
        }
        blurView.frame = UIScreen.main.bounds
        //blurView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        
    }
    static func addActivity(){
        rootView.addSubview(hudView)
        hudView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        hudView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        hudView.centerXAnchor.constraint(equalTo: hudView.superview!.centerXAnchor).isActive = true
        hudView.centerYAnchor.constraint(equalTo: hudView.superview!.centerYAnchor).isActive = true
        
        hudView.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: activity.superview!.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: activity.superview!.centerYAnchor).isActive = true
        rootView.isUserInteractionEnabled = false
        
    }
    static func hide(){
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            rootView.isUserInteractionEnabled = true
            blurView.removeFromSuperview()
            hudView.removeFromSuperview()
        }
     
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
