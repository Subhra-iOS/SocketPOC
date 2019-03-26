//
//  ViewController.swift
//  SocketPOC
//
//  Created by Subhra Roy on 14/03/19.
//  Copyright © 2019 Subhra Roy. All rights reserved.
//

import UIKit
import SocketIO

private let userToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7IlVzZXJJRCI6MTkyMzIsIkNvbXBhbnlOYW1lIjpudWxsLCJBZGRyZXNzIjoiU2FsdGxha2UiLCJDaXR5IjpudWxsLCJTdGF0ZU5hbWUiOm51bGwsIkNvdW50cnlOYW1lIjoiVW5pdGVkIFN0YXRlcyIsIkNvdW50cnlDb2RlIjoiMSIsIlppcENvZGUiOm51bGwsIlBob25lIjoiOTk5OTk5OTkiLCJNb2RpZml5RGF0ZSI6IjIwMTktMDMtMTNUMDQ6Mzc6MTguODQwWiIsIkVtYWlsIjoiY2ZmZmZANzc3Ny5jb20iLCJGaXJzdE5hbWUiOiJNYW5pZGlwYSIsIk1pZGRsZU5hbWUiOm51bGwsIkxhc3ROYW1lIjpudWxsLCJGdWxsTmFtZSI6Ik1hbmlkaXBhICAiLCJVc2VyVHlwZSI6IlNJR05FRCIsIkxhc3RMb2dpbkRhdGUiOiIyMDE5LTAzLTE4VDAwOjI1OjMyLjAwMFoiLCJQYXJ0bmVySUQiOjE2LCJQV0FjY291bnRJRCI6MTYyMjYzfSwiZGV2aWNlIjp7ImRldmljZUlkIjoiaW9zVGVzdGluZyIsImZhbWlseSI6Ik90aGVyIiwiYnJvd3NlciI6IkNocm9tZSA3Mi4wLjM2MjYiLCJvcyI6IldpbmRvd3MifSwibGFzdExvZ2luIjoxNTUyODY4NzMyMDAwLCJTZXNzaW9uSUQiOiI2YTQydGNqdGUxMHh0MCIsImlhdCI6MTU1Mjg5NDA1NX0.oNOnE-2q_0BMxzg7caO1Cg8YhW9Ffbm-caYOg2-MEf9gqddGz4SLKtr_7nguxaDyyN7Q7ghC97VfhYrFDRRuRoWBx_aRE7K_wTD7gWXFmjMRSYyHzhQ9r9CTVh9BwMu7g8XtbNXcS1v-8qX825AJlNEUiiNqSRUxdce13CUCkmDoiKOkf7WcKA9WZwLXzrTA4hd_uUlPmTVmR0zeNiQ8FZ6XfPyGKRJZH197xKcdG4ru5fNnA4mgz7bBAMlHbLNamz4IJsYoy-Xlfy7gGYvxUyrNZAgtNP4i6bEFcCfGo6Ms6pToClGxYXs5eyXDU457v9DT2eEggFYPoELhQbpq1Q"

class ViewController: UIViewController {

    private var socket : SocketIOClient!
    private var  socketManager : SocketManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.connectSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        self.socket.disconnect()
    }

}

extension ViewController{
    
    private func connectSocket() -> Void{
        
        self.socketManager = SocketManager(socketURL: URL(string: "ws://westcoast1.arctechh.com:3005")!, config: [.log(true) ])
        self.socket = socketManager.defaultSocket
        self.setSocketEvent()
        
    }
    
    private func setSocketEvent() -> Void{
        
        let socketJSON  : [String : Any] = [
            "'device_id" : "46857FC7-0FBE-4CBA-8E4E-C8AB0E765279",
            "type"  : "ios",
            "bot_token" : "46857FC7-0FBE-4CBA-8E4E-C8AB0E765279",
            "x-access-token"  : userToken,
            "message": "show me the order status 2827333",
            "position" : [ "Longitude": "88.426400",
                                  "Latitude": "22.579090"]
        ]
        
        print("Json: \(socketJSON)")
        self.socket.connect()
        self.socket.on(clientEvent: .connect) { (data, ack) in
            print("socket connected")
            self.socket.emit("chat message",socketJSON)
        }
     
    }
    
}
