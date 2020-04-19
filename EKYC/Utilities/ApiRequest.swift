//
//  ApiRequest.swift
//  EKYC
//
//  Created by Sium_MBSTU on 27/3/20.
//  Copyright © 2020 AvF. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIRequest: NSObject {

    enum RequestType {
        case POST
        case GET
        case PUT
        case DELETE
        case PATCH
        case OPTIONS
    }

    static let shared:APIRequest = APIRequest()
    
    //Upload Images
    func uploadImage(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,imagesData:[Data],isHudeShow:Bool,success:@escaping SUCCESS,fail:@escaping FAIL){
//        guard CommonClass.shared.isConnectedToInternet else{
//            ShowToast.newShow(toastMessage: kNoInternetError, backgroundColor: liveColor.liveRed, textColor: .white)
//           // fail(["Error":kNoInternetError])
//            return
//        }
        if isHudeShow{
            DispatchQueue.main.async {
                ProgressHud.show()
            }
        }
        let urlString = baseUrl + (queryString == nil ? "" : queryString!)
     
        
         //let URL = "http://staging.live.stockholmapplab.com/api/amazons3/native/experience/image/upload/image"
         var headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
//         var strAccessToken:String = ""
//        if UserProfile.isUserLoggedIn,let currentUser = UserProfile.getUserProfileFromUserDefault(){
//            strAccessToken = "Bearer \(currentUser.accessToken)"
//         }
//            if let languageId = kUserDefault.value(forKey: "selectedLanguageCode") as? String {
//                headers = ["Content-type": "multipart/form-data","LanguageId": "\(languageId)","Authorization":"\(strAccessToken)"]
//            }else{
//                headers = ["Content-type": "multipart/form-data","Authorization":"\(strAccessToken)"]
//            }
         Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameter ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
         }
         
            for imageData in imagesData {
                multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "file/jpg")
            }
         
         }, usingThreshold: UInt64.init(), to: urlString, method:HTTPMethod(rawValue:"\(requestType)")!, headers: headers) { (result) in
           
         switch result{
         case .success(let upload, _, _):
         upload.responseJSON { response in
            //print(String(data: response.value as! Data, encoding: .utf8)!)
            //do{
            DispatchQueue.main.async {
                ProgressHud.hide()
            }
            
            if let value = response.value {
                success(value)
            }else{
                fail(["Error" : "Failed"])
            }
            //success(String(data: response.data ?? Data(), encoding: .utf8)!)
            //}
            //catch{
                //ShowToast.show(toatMessage: kCommonError)
                
//fail(["error": error.localizedDescription])
//}
            }
//         if let objResponse = response.response,objResponse.statusCode == 200{
//            print(objResponse)
//            if let successResponse = response.value as? [String:Any]{
//                success(successResponse)
//            }else{
//                DispatchQueue.main.async {
//                    ProgressHud.hide()
//                }
//            }
//         }
//         else if let objResponse = response.response,objResponse.statusCode == 401{
//            self.cancelAllAPIRequest(json: response.value)
//         }else if let objResponse = response.response,objResponse.statusCode == 400{
//            if let failResponse = response.value as? [String:Any]{
//                fail(failResponse)
//            }
//         }
//         else if let error = response.error{
//            DispatchQueue.main.async {
//                //ShowToast.show(toatMessage: "\(error.localizedDescription)")
//                fail(["error":"\(error.localizedDescription)"])
//            }
//         }else{
//            DispatchQueue.main.async {
//                //ShowToast.show(toatMessage: "\(kCommonError)")
//                //fail(["error":"\(kCommonError)"])
//            }
//           }
//         }
         case .failure(let error):
            DispatchQueue.main.async {
                //ShowToast.show(toatMessage: "\(error.localizedDescription)")
                fail(["error":"\(error.localizedDescription)"])
            }
         }
         }
    }
    
    //Send Request
        func sendRequest(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,isHudeShow:Bool,success:@escaping SUCCESS,fail:@escaping FAIL){
//            guard CommonClass.shared.isConnectedToInternet else{
//                ShowToast.newShow(toastMessage: kNoInternetError, backgroundColor: liveColor.liveRed, textColor: .white)
//                DispatchQueue.main.async {
//                    ProgressHud.hide()
//                }
//                //fail(["Error":kNoInternetError])
//                return
//            }
            
            if isHudeShow{
                DispatchQueue.main.async {
                    ProgressHud.show()
                }
            }
            if(queryString == "generate_otp"){
                baseUrl = baseUrl1
            }
            
            let urlString = baseUrl + (queryString == nil ? "" : queryString!)
    //        DispatchQueue.main.async {
    //            ShowToast.show(toatMessage: "\(urlString)")
    //        }
            var request = URLRequest(url: URL(string: urlString)!)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.timeoutInterval = 60
            request.httpMethod = String(describing: requestType)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
//            if let languageId = kUserDefault.value(forKey: "selectedLanguageCode") as? String {
//                request.setValue("\(languageId)", forHTTPHeaderField: "LanguageId")
//            } else {
//                request.setValue("1", forHTTPHeaderField: "LanguageId")
//            }
//            if UserProfile.isUserLoggedIn,let currentUser = UserProfile.getUserProfileFromUserDefault(){
//                request.setValue("Bearer \(String(describing: currentUser.accessToken))", forHTTPHeaderField: "Authorization")
//            }
            
//            if let udid = UIDevice.current.identifierForVendor{
//                let deviceID = "\(udid.uuidString)"
//                request.setValue(deviceID, forHTTPHeaderField: "DeviceID")
//            }
//
//            let userAgent = User_Agent().UAString()
//            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            
            if let params = parameter{
                do{
                    let parameterData = try JSONSerialization.data(withJSONObject:params, options:.prettyPrinted)
                    request.httpBody = parameterData
                }catch{
                    DispatchQueue.main.async {
                        ProgressHud.hide()
                    }
                    //ShowToast.show(toatMessage: kCommonError)
                    fail(["error":"kCommonError"])
                }
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    ProgressHud.hide()
                }
//                if let httpUrlResponse = response as? HTTPURLResponse
//                {
//                    if (error != nil) {
//                        print("Error Occurred: \(error?.localizedDescription ?? "")")
//                    } else {
//                        print("\(httpUrlResponse.allHeaderFields["x-total-count"] ?? "")") // Error
//                    }
//                }
                if error != nil{
                    //ShowToast.show(toatMessage: "\(error!.localizedDescription)")
                    fail(["error":"\(error!.localizedDescription)"])
                }
                
                if let _ = data,let httpStatus = response as? HTTPURLResponse{
                    print(httpStatus.statusCode)
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if httpStatus.statusCode == 200 {
                            success(json)
//                        }else if httpStatus.statusCode == 401 {
//                            if UserProfile.isUserLoggedIn {
//                                self.requestNewRefreshToken(withBody: true,jsonData: json, requestType: requestType, queryString: queryString, parameter: parameter, isHudeShow: isHudeShow, succeeded: { (succeeded) in
//                                    success(succeeded)
//                                }, failed: { (failed) in
//                                    fail(failed)
//                                })
//                            }else{
//                                //self.cancelAllAPIRequest(json: json)
//                            }
                        }else{
                            fail(json)
                        }
                        //(httpStatus.statusCode == 200) ? success(json): (httpStatus.statusCode == 401) ? self.cancelAllAPIRequest(json: json):fail(json)

                    }
                    catch{
//                        if httpStatus.statusCode == 401 {
//                            if UserProfile.isUserLoggedIn {
//                                self.requestNewRefreshToken(withBody: true,jsonData: ["error":kCommonError], requestType: requestType, queryString: queryString, parameter: parameter, isHudeShow: isHudeShow, succeeded: { (succeeded) in
//                                    success(succeeded)
//                                }, failed: { (failed) in
//                                    fail(failed)
//                                })
//                            }else{
//                                self.cancelAllAPIRequest(json: ["error":kCommonError])
//                            }
//                        }else{
//                            //ShowToast.show(toatMessage: kCommonError)
//
//                            fail(["error":kCommonError])
//                        }
                        fail(["error":"kCommonError"])
                    }
                }else{
                    //ShowToast.show(toatMessage: kCommonError)
                    fail(["error":"kCommonError"])
                }
            }
            task.resume()
        }
}


