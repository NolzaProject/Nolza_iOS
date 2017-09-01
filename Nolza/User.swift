//
//  User.swift
//  Nolza
//
//  Created by 전한경 on 2017. 9. 1..
//  Copyright © 2017년 jeon. All rights reserved.
//

import Foundation

class User: NSObject {
    
    public var duration : String?
    public var email : String?
    public var nation : String?
    public var userName : String?
    public var password : String?
    
    init(duration: String?, email: String?, nation: String?, userName: String?, password: String?) {
        self.duration = duration
        self.email = email
        self.nation = nation
        self.userName = userName
        self.password = password
    }
}
