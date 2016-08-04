//
//  TextFormatter.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 3/19/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

class TextFormatter {
    static func formatText(_ text: String) -> String {
        return text//text.lowercased()
    }
    
    static func formatTextLowercase(_ text: String) -> String {
        return text.lowercased()
    }
    
    static func formatTextUppercase(_ text: String) -> String {
        return text.capitalized
    }
}
