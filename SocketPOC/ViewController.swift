//
//  ViewController.swift
//  SocketPOC
//
//  Created by Subhra Roy on 14/03/19.
//  Copyright © 2019 ARC. All rights reserved.
//

import UIKit
import SocketIO

private let userToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7IlVzZXJJRCI6MTkyMzIsIkNvbXBhbnlOYW1lIjpudWxsLCJBZGRyZXNzIjoiU2FsdGxha2UiLCJDaXR5IjpudWxsLCJTdGF0ZU5hbWUiOm51bGwsIkNvdW50cnlOYW1lIjoiVW5pdGVkIFN0YXRlcyIsIkNvdW50cnlDb2RlIjoiMSIsIlppcENvZGUiOm51bGwsIlBob25lIjoiOTk5OTk5OTkiLCJNb2RpZml5RGF0ZSI6IjIwMTktMDMtMTNUMDQ6Mzc6MTguODQwWiIsIkVtYWlsIjoiY2ZmZmZANzc3Ny5jb20iLCJGaXJzdE5hbWUiOiJNYW5pZGlwYSIsIk1pZGRsZU5hbWUiOm51bGwsIkxhc3ROYW1lIjpudWxsLCJGdWxsTmFtZSI6Ik1hbmlkaXBhICAiLCJVc2VyVHlwZSI6IlNJR05FRCIsIkxhc3RMb2dpbkRhdGUiOiIyMDE5LTAzLTE4VDAwOjI1OjMyLjAwMFoiLCJQYXJ0bmVySUQiOjE2LCJQV0FjY291bnRJRCI6MTYyMjYzfSwiZGV2aWNlIjp7ImRldmljZUlkIjoiaW9zVGVzdGluZyIsImZhbWlseSI6Ik90aGVyIiwiYnJvd3NlciI6IkNocm9tZSA3Mi4wLjM2MjYiLCJvcyI6IldpbmRvd3MifSwibGFzdExvZ2luIjoxNTUyODY4NzMyMDAwLCJTZXNzaW9uSUQiOiI2YTQydGNqdGUxMHh0MCIsImlhdCI6MTU1Mjg5NDA1NX0.oNOnE-2q_0BMxzg7caO1Cg8YhW9Ffbm-caYOg2-MEf9gqddGz4SLKtr_7nguxaDyyN7Q7ghC97VfhYrFDRRuRoWBx_aRE7K_wTD7gWXFmjMRSYyHzhQ9r9CTVh9BwMu7g8XtbNXcS1v-8qX825AJlNEUiiNqSRUxdce13CUCkmDoiKOkf7WcKA9WZwLXzrTA4hd_uUlPmTVmR0zeNiQ8FZ6XfPyGKRJZH197xKcdG4ru5fNnA4mgz7bBAMlHbLNamz4IJsYoy-Xlfy7gGYvxUyrNZAgtNP4i6bEFcCfGo6Ms6pToClGxYXs5eyXDU457v9DT2eEggFYPoELhQbpq1Q"

class ViewController: UIViewController {

    //private var socketHandler : SocketHandler = SocketHandler()
    private var socket : SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*socketHandler.messageDelegate = self
        socketHandler.setupNetworkCommunication()
        socketHandler.addUserToken(token: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7IlVzZXJJRCI6MTkyMzIsIkNvbXBhbnlOYW1lIjpudWxsLCJBZGRyZXNzIjoiU2FsdGxha2UiLCJDaXR5IjpudWxsLCJTdGF0ZU5hbWUiOm51bGwsIkNvdW50cnlOYW1lIjoiVW5pdGVkIFN0YXRlcyIsIkNvdW50cnlDb2RlIjoiMSIsIlppcENvZGUiOm51bGwsIlBob25lIjoiOTk5OTk5OTkiLCJNb2RpZml5RGF0ZSI6IjIwMTktMDMtMTNUMDQ6Mzc6MTguODQwWiIsIkVtYWlsIjoiY2ZmZmZANzc3Ny5jb20iLCJGaXJzdE5hbWUiOiJNYW5pZGlwYSIsIk1pZGRsZU5hbWUiOm51bGwsIkxhc3ROYW1lIjpudWxsLCJGdWxsTmFtZSI6Ik1hbmlkaXBhICAiLCJVc2VyVHlwZSI6IlNJR05FRCIsIkxhc3RMb2dpbkRhdGUiOiIyMDE5LTAzLTE4VDAwOjI1OjMyLjAwMFoiLCJQYXJ0bmVySUQiOjE2LCJQV0FjY291bnRJRCI6MTYyMjYzfSwiZGV2aWNlIjp7ImRldmljZUlkIjoiaW9zVGVzdGluZyIsImZhbWlseSI6Ik90aGVyIiwiYnJvd3NlciI6IkNocm9tZSA3Mi4wLjM2MjYiLCJvcyI6IldpbmRvd3MifSwibGFzdExvZ2luIjoxNTUyODY4NzMyMDAwLCJTZXNzaW9uSUQiOiI2YTQydGNqdGUxMHh0MCIsImlhdCI6MTU1Mjg5NDA1NX0.oNOnE-2q_0BMxzg7caO1Cg8YhW9Ffbm-caYOg2-MEf9gqddGz4SLKtr_7nguxaDyyN7Q7ghC97VfhYrFDRRuRoWBx_aRE7K_wTD7gWXFmjMRSYyHzhQ9r9CTVh9BwMu7g8XtbNXcS1v-8qX825AJlNEUiiNqSRUxdce13CUCkmDoiKOkf7WcKA9WZwLXzrTA4hd_uUlPmTVmR0zeNiQ8FZ6XfPyGKRJZH197xKcdG4ru5fNnA4mgz7bBAMlHbLNamz4IJsYoy-Xlfy7gGYvxUyrNZAgtNP4i6bEFcCfGo6Ms6pToClGxYXs5eyXDU457v9DT2eEggFYPoELhQbpq1Q")*/
        
        //self.perform(#selector(ViewController.sendText), with: nil, afterDelay: 5.0)
        
        self.connectSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //socketHandler.stopSocketSession()
        self.socket.disconnect()
    }
    
    @objc private func sendText() -> Void{
        
       // socketHandler.sendMessage(message: "What's the order status of  2827333")
    }

}

/*extension ViewController : SocketHandlerProtocol{
    
    func didReceiveMessage(message: MessageModel) {
        
        print("\(String(describing: message.responseBody))")
        print("\(String(describing: message.userToken))")
        
    }
    
}*/

extension ViewController{
    
    private func connectSocket() -> Void{
        
        let socketManager = SocketManager(socketURL: URL(string: "http://westcoast1.arctechh.com:3005/")!, config: [.log(true), .connectParams(["x-access-token" : userToken ]) ]) // [.log(true), .connectParams(["x-access-token" : userToken])]
        self.socket = socketManager.defaultSocket
        self.setSocketEvent()
       self.socket.connect()
        
    }
    
    private func setSocketEvent() -> Void{
        
        self.socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket Connect")
        }
        
        let socketJSON = [
            "lng": "",
            "lat": "",
            "id": "What's the order status of  2827333"
        ]
        self.socket.on("connect") {data, ack in
            print("socket connected")
            self.socket.emit("setLocation",socketJSON)
            print("Mostrando el Json: \(socketJSON)")
        }
        self.socket.on("locationChanged", callback: {_,_ in
            print("disconnected")
            self.socket.disconnect()
        })
     
    }
    
}

/*
 class soket {
 var lat = ""
 var lng = ""
 let appDelegate = UIApplication.shared.delegate as!AppDelegate
 init(lat: String, lng: String) {
 self.lat = lat
 self.lng = lng
 }
 func connect()  {
 print("llamada al socket")
 print(contantes.init().addres)
 let socket = SocketIOClient(socketURL: URL(string: contantes.init().addres)!,config: [.connectParams(["accessToken" : appDelegate.token]),.forcePolling(true),.nsp("/vendedor"), .log(true)])
 let myJSON = [
 "lng":lng,
 "lat":lat,
 "idvendedor":appDelegate.idSeller
 ]
 socket.on("connect") {data, ack in
 print("socket connected")
 socket.emit("setLocation",myJSON)
 print("Mostrando el Json: \(myJSON)")
 }
 socket.on("locationChanged", callback: {_,_ in
 print("disconnected")
 socket.disconnect()
 })
 socket.connect()
 }
 }*/
