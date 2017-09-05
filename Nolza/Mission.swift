//
//  Mission.swift
//  Nolza
//
//  Created by 전한경 on 2017. 9. 1..
//  Copyright © 2017년 jeon. All rights reserved.
//

import Foundation

class Mission: NSObject {
    
    public var businessHour : String?
    public var charge : String?
    public var descript : String?
    public var difficulty : String?
    public var id : Int?
    public var imageUrl : String?
    public var location : String?
    public var phoneNumber : String?
    public var title : String?
    
    init(businessHour: String?, charge: String?, descript: String?, difficulty: String?, id: Int?, imageUrl: String?, location: String?, phoneNumber: String?, title: String?) {
        self.businessHour = businessHour
        self.charge = charge
        self.descript = descript
        self.difficulty = difficulty
        self.id = id
        self.imageUrl = imageUrl
        self.location = location
        self.phoneNumber = phoneNumber
        self.title = title
    }
    

    

}
