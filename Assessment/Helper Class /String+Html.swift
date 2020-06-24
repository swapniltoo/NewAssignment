//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    public func plainString() -> String? {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).convertHtmlSymbols()
    }
    
    public func convertHtmlSymbols() -> String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        }
        catch {
            return ""
        }
//        return ""
    }
}
