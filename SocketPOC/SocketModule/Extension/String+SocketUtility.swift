//
//  String+SocketUtility.swift
//  SocketPOC
//
//  Created by Subhra Roy on 15/03/19.
//  Copyright © 2019 Subhra Roy. All rights reserved.
//

import Foundation

extension String {
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
    }
}
