//
//  CameraController.swift
//  EKYC
//
//  Created by Sium_MBSTU on 25/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: NSObject {
    
    var captureSession: AVCaptureSession?
    
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var movieOutput: AVCaptureMovieFileOutput?

    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            //1
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = (session.devices.compactMap { $0 })//, !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
             
            //2
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
             
                if camera.position == .back {
                    self.rearCamera = camera
             
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            //3
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

            //4
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)

                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }

                self.currentCameraPosition = .rear
                
            }else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)

                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }

                self.currentCameraPosition = .front
            }

            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
               self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
               
        }
        
        func configureMoviewOutput() throws {
             guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.movieOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.movieOutput!) {
                captureSession.addOutput(self.movieOutput!)
            }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try configureMoviewOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
           self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
           self.previewLayer?.connection?.videoOrientation = .portrait
        
           view.layer.insertSublayer(self.previewLayer!, at: 0)
           self.previewLayer?.frame = view.frame
    }
    
    func switchCameras() throws {
        
        //5
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
         
        //6
        captureSession.beginConfiguration()
        
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
         
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
         
            captureSession.removeInput(rearCameraInput)
         
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
         
                self.currentCameraPosition = .front
            }
         
            else { throw CameraControllerError.invalidOperation }
        }
         
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
         
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
         
            captureSession.removeInput(frontCameraInput)
         
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
         
                self.currentCameraPosition = .rear
            }
         
            else { throw CameraControllerError.invalidOperation }
        }
        
        //7
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
         
        case .rear:
            try switchToFrontCamera()
        }
         
        //8
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }

        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode

        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    func captureMovie(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")//URLByAppendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput?.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
    resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}

