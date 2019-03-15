//
//  MessageModel.swift
//  SocketPOC
//
//  Created by Subhra Roy on 15/03/19.
//  Copyright © 2019 ARC. All rights reserved.
//

import Foundation

struct MessageModel {
    
    public var messageBody : String?
    public var userToken : String?
    public var responseBody : String?
    
    init(sendText : String? = nil, token : String?, response : String? = nil) {
        
        self.messageBody = sendText
        self.userToken = token
        self.responseBody = response
        
    }
    
    
}
