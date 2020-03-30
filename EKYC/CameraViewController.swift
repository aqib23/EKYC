//
//  CameraViewController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 25/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController {

    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var cameraOptionButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var captureView: UIView!
    
    let cameraController = CameraController()
    var photoDelegate: PassImage?
    var frontCamera = false
    
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
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
         
                try? self.cameraController.displayPreview(on: self.captureView)
            }
        }
        
        func styleCaptureButton() {
            captureButton.layer.borderColor = UIColor.black.cgColor
            captureButton.layer.borderWidth = 2
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        styleCaptureButton()
        
        configureCameraController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if self.frontCamera {
                self.cameraOptionSelector(UIButton())
            }
        }
    }
    
    @IBAction func flashSelector(_ sender: Any) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "ic_flash_off"), for: .normal)
        }else {
            cameraController.flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "ic_flash_on"), for: .normal)
        }
    }
    
    @IBAction func cameraOptionSelector(_ sender: Any) {
        do {
            try cameraController.switchCameras()
        }

        catch {
            print(error)
        }

        switch cameraController.currentCameraPosition {
        case .some(.front):
            cameraOptionButton.setImage(#imageLiteral(resourceName: "ic_camera_front"), for: .normal)

        case .some(.rear):
            cameraOptionButton.setImage(#imageLiteral(resourceName: "ic_camera_rear"), for: .normal)

        case .none:
            return
        }
    }
    
    @IBAction func captureButtonSelector(_ sender: Any) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }

//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
            
            self.photoDelegate?.passImage(image: image)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}


protocol PassImage {
    func passImage(image: UIImage)
}
