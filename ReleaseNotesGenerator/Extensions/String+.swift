//
//  String+.swift
//  ReleaseNotesGenerator
//
//  Created by Mihai Eros on 13.01.2023.
//

import Foundation

extension String {
    func replaceAsterix() -> String {
        replacingMatches(pattern: "\\*\\s") { _ in "" }
    }
    
    func replaceByContents() -> String {
        replacingMatches(pattern: "by @.*") { _ in "" }
    }
    
    func replaceJiraCards() -> String {
        var result: String = ""
        
        for line in self.components(separatedBy: "\n") {
            guard !line.isEmpty else {
                break
            }
            result += "\nhttps://fanduel.atlassian.net/browse/\(line)"
        }
        
        return result
    }
    
    func replacingMatches(pattern: String, replace: (String) -> String?) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            let mutableString = NSMutableString(string: self)
            
            matches.reversed().forEach { match in
                guard let range = Range(match.range, in: self),
                      let replacement = replace(String(self[range])) else {
                    return
                }
                
                regex.replaceMatches(in: mutableString, options: .reportCompletion, range: match.range, withTemplate: replacement)
            }
            
            return String(mutableString)
        } catch {
            return self
        }
    }
}
