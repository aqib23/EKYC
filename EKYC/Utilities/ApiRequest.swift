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
    func uploadImage(requestType:RequestType,queryString:String?,parameter:[String:AnyObject]?,imageData:Data,isHudeShow:Bool,success:@escaping SUCCESS,fail:@escaping FAIL){
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
         
         // if let data = imageData{
         multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "file/jpg")
         //}
         
         }, usingThreshold: UInt64.init(), to: urlString, method:HTTPMethod(rawValue:"\(requestType)")!, headers: headers) { (result) in
           
         switch result{
         case .success(let upload, _, _):
         upload.responseJSON { response in
            print(String(data: response.data ?? Data(), encoding: .utf8)!)
            //do{
            DispatchQueue.main.async {
                ProgressHud.hide()
            }
            success(String(data: response.data ?? Data(), encoding: .utf8)!)
                
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
}


