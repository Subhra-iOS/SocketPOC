//
//  SocketHandler.swift
//  SocketPOC
//
//  Created by Subhra Roy on 15/03/19.
//  Copyright © 2019 ARC. All rights reserved.
//

import Foundation
import UIKit

protocol SocketHandlerProtocol : NSObjectProtocol {
    func didReceiveMessage(message : MessageModel) -> Void
}

class SocketHandler : NSObject {
    
    weak var messageDelegate : SocketHandlerProtocol?
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    
    private var userToken : String?
    private let maxReadLength = 1024
    
    //1) Set up the input and output streams for message sending
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "http://westcoast1.arctechh.com:3005/" as CFString,
                                           80,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: RunLoop.Mode.common)
        outputStream.schedule(in: .main, forMode: RunLoop.Mode.common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func addUserToken(token: String) {
        let data = "user:\(token)".data(using: .ascii)!
        self.userToken = token
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    func sendMessage(message: String) {
        let data = "msg:\(message)".data(using: .ascii)!
        
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    func stopSocketSession() {
        inputStream.close()
        outputStream.close()
    }
    
}

extension SocketHandler : StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
            case Stream.Event.hasBytesAvailable:
                print("new message received")
                self.readAvailableBytes(stream: aStream as! InputStream)
            case Stream.Event.endEncountered:
                self.stopSocketSession()
            case Stream.Event.errorOccurred:
                print("error occurred")
            case Stream.Event.hasSpaceAvailable:
                print("has space available")
            default:
                print("some other event...")
        }
        
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0 {
                if let _ = inputStream.streamError {
                    break
                }
            }
            
            if let message : MessageModel = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                
                 self.messageDelegate?.didReceiveMessage(message: message)
                
            }
            
        }
        
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> MessageModel? {
        
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .ascii,
                                       freeWhenDone: true)?.components(separatedBy: ":"),
            let token = stringArray.first,
            let message = stringArray.last else {
                return nil
        }
        
        return MessageModel(sendText: message, token: token )
    }
    
}
