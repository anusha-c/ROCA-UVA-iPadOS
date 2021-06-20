//
//  RSSParser.swift
//  ROCA-UVA
//
//  Created by Anusha Choudhary on 6/20/21.
//

import Foundation

class RSSParser:NSObject, XMLParserDelegate{
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String:String]()
    var parsedData = [[String:String]]()
    var isHeader = false
    
    func startParsingWithContentsOfURL(rssURL: URL, with completion: (Bool)->()){
        let parser = XMLParser(contentsOf: rssURL)
        parser?.delegate = self
        if let flag = parser?.parse() {
            //for handling the last element in the feed
            parsedData.append(currentData)
            completion(flag)
        }
    }
    
    //keep relevant tag content
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        //not interested in header tag, so we go to <item> tags
        if currentElement == "item"{
            //starts at the (n+1)th entry
            if isHeader == false{
                parsedData.append(currentData)
            }
            
            isHeader = false
            
        }
            
            if isHeader == false {
                //any thumnails that may exist?? our feed most probably
                //doesn't have these
            }
            
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isHeader == false{
            if (currentElement == "title" || currentElement == "itunes:author" || currentElement == "link" ||  currentElement == "guid" || currentElement == "pubDate" || currentElement == "itunes:duration"){
                foundCharacters += string
                //TODO: Find a way to remove HTML tags
            }
        }
    }
    
    //look at closing tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty{
            foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentElement] = foundCharacters
            foundCharacters = ""
            
        }
    }
    
}
