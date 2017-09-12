//
//  NolzaAPI.swift
//  Nolza
//
//  Created by 전한경 on 2017. 9. 1..
//  Copyright © 2017년 jeon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let server = "http://13.124.179.107:8080/Nolza/api/v1"

class NolzaAPI {
    var url: String
    let method: HTTPMethod
    var parameters: Parameters
    let header: HTTPHeaders
    let encode = URLEncoding.default
    
    init(path: String, method: HTTPMethod, parameters: Parameters = [:], header: HTTPHeaders = [:]) {
        url = server + path
        self.method = method
        self.parameters = parameters
        self.header = header
    }
    
    func setPath(path: String){
        url = server + path
    }
    
    func requestJoin(completion : @escaping (JSON)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters, headers: header).responseJSON{ response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getMissions(completion : @escaping ([Mission])->Void){
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    
                    var missions = [Mission]()
                    let contents = resp["result"]
//                    print(contents)
                    for idx in 0..<contents.count {
                        
                        let content = Mission(businessHour: contents[idx]["businessHour"].stringValue, charge: contents[idx]["charge"].stringValue, descript: contents[idx]["description"].stringValue, difficulty: contents[idx]["difficulty"].stringValue, id: contents[idx]["id"].intValue, imageUrl: contents[idx]["imageUrl"].stringValue, location: contents[idx]["location"].stringValue, phoneNumber: contents[idx]["phoneNumber"].stringValue, title: contents[idx]["title"].stringValue)
                        
                        missions += [content]
                    }
                    completion(missions)
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    func getThemeMissions(completion : @escaping ([Mission])->Void){
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    print(resp)
                    
                    var missions = [Mission]()
                    let contents = resp["result"]["missionResponses"]
                    print(contents.count)
                    for idx in 0..<contents.count {
                        
                        let content = Mission(businessHour: contents[idx]["businessHour"].stringValue, charge: contents[idx]["charge"].stringValue, descript: contents[idx]["description"].stringValue, difficulty: contents[idx]["difficulty"].stringValue, id: contents[idx]["id"].intValue, imageUrl: contents[idx]["imageUrl"].stringValue, location: contents[idx]["location"].stringValue, phoneNumber: contents[idx]["phoneNumber"].stringValue, title: contents[idx]["title"].stringValue)
                        
                        missions += [content]
                    }
                    completion(missions)
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }

    
    func searchMission(completion : @escaping ([Mission])->Void){
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    
                    var missions = [Mission]()
                    let contents = resp["result"]

                    for idx in 0..<contents.count {
                        
                        let content = Mission(businessHour: contents[idx]["businessHour"].stringValue, charge: contents[idx]["charge"].stringValue, descript: contents[idx]["description"].stringValue, difficulty: contents[idx]["difficulty"].stringValue, id: contents[idx]["id"].intValue, imageUrl: contents[idx]["imageUrl"].stringValue, location: contents[idx]["location"].stringValue, phoneNumber: contents[idx]["phoneNumber"].stringValue, title: contents[idx]["title"].stringValue)
                        
                        missions += [content]
                    }
                    completion(missions)
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    
    func requestToken(completion : @escaping (String)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    switch (resp["meta"]["code"].intValue){
                    case 0:
                        //토큰을 주고
                        completion(resp["data"]["token"].stringValue)
                        break
                    default:
                        //로그인으로
                        completion("OPEN_LOGINVC")
                        break
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestLogin(completion : @escaping (JSON)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func missionUpload(imageData: Data, email: String, missionId: Int, completion : @escaping (Int)->Void){
        //Data(bytes: &mId,count: MemoryLayout.size(ofValue: mId))
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(email.data(using: .utf8)!, withName: "email")
                multipartFormData.append(missionId.description.data(using: .utf8)!, withName: "missionId")
                multipartFormData.append(imageData, withName: "image", fileName: "default.jpeg", mimeType: "image/jpeg")
        },
            to: url,
            headers:header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let resp = JSON(response.result.value!)
                        completion(resp["code"].intValue)
                    }
                case .failure(let encodingError):
                    //completion(encodingError as! String)
                    print(encodingError as! String)
                    completion(700)
                }
        }
        )
    }
    
    func requestHotPic(hotPicSub : @escaping([String])->Void,hotPicCreator : @escaping([String])->Void,hotPicDate : @escaping([String])->Void,hotPicImg : @escaping([UIImage])->Void, hotPicContentId : @escaping([Int])->Void){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    var hotpicArr : [UIImage] = []
                    var hotPicSubArr : [String] = []
                    var hotPicCreatorArr : [String] = []
                    var hotPicDateArr : [String] = []
                    var hotPicContentIdArr : [Int] = []
                    
                    for idx in 0..<resp["data"]["contents"].count{
                        let hotPicUrl = resp["data"]["contents"][idx]["content"]["picture"].stringValue
                        let hotPicImg = UIImage(data: NSData(contentsOf: NSURL(string: hotPicUrl)! as URL)! as Data)!
                        hotpicArr.append(hotPicImg)
                        
                        let creator = resp["data"]["contents"][idx]["nickname"].stringValue
                        hotPicCreatorArr.append(creator)
                        
                        let subject = resp["data"]["contents"][idx]["mission"]["text"].stringValue
                        hotPicSubArr.append(subject)
                        
                        let date = resp["data"]["contents"][idx]["missionDate"].stringValue
                        hotPicDateArr.append(date)
                        
                        let contentId = resp["data"]["contents"][idx]["contentId"].intValue
                        hotPicContentIdArr.append(contentId)
                        
                    }
                    
                    hotPicImg(hotpicArr)
                    hotPicCreator(hotPicCreatorArr)
                    hotPicDate(hotPicDateArr)
                    hotPicSub(hotPicSubArr)
                    hotPicContentId(hotPicContentIdArr)
                }
                break
            case .failure(_):
                break
            }
        }
    }

    func requestUserInfo(completion : @escaping(Any)->Void){
        Alamofire.request(url,method: method,headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["nickname"].description)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestDeleteContent(completion : @escaping(Int)->Void){
        Alamofire.request(url,method: method, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestModifyContent(completion : @escaping(Int)->Void){
        
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode ,headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    
}

