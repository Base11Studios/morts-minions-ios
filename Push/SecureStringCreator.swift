//
//  SecureStringCreator.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 2/27/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class SecureStringCreator {
    static func computeSHA256DigestForData(_ data : Data) -> NSMutableString {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &hash)
        
        // Setup our Objective-C output
        let output: NSMutableString = NSMutableString(capacity: Int(CC_SHA256_DIGEST_LENGTH) * 2)
        
        // Parse through the CC_SHA256 results (stored inside of hash[])
        for i in 0 ..< Int(CC_SHA256_DIGEST_LENGTH) {
            output.appendFormat("%02x", hash[i])
        }
        return output

    }
}
