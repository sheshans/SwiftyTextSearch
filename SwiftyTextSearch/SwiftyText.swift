//
//  SwiftyText.swift
//  SwiftyTextSearch
//
//  Created by Sheshans Yadav on 7/2/17.
//  Copyright (c) 2017 Sheshans Yadav. All rights reserved.
//

import UIKit

open class SwiftyText: NSObject,NSCoding{
    
    public var root: Node
    
    struct PropertyKey
    {
        static let rootKey: String = "root"
    }
    
    
    //Mark: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(root,forKey: PropertyKey.rootKey )
    }
    
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let root = aDecoder.decodeObject(forKey: PropertyKey.rootKey ) as! Node
        self.init(root: root)
    }
    
    
    public init( root: Node )
    {
        self.root = root
    }
    
    
    override public init() {
        root = Node()
        super.init()
    }
    
    
    public init( arr: [String] )
    {
        root = Node()
        super.init()
        appendStrings(arr: arr)
    }
    
    
    public func appendStrings(arr: [String])
    {
        let setArr = Set(arr.map { $0 })
        let currentTime = CACurrentMediaTime()
        for i in setArr
        {
            addStringToNode(root: &root,parentString: i)
        }
        let responseTime = Int((CACurrentMediaTime() - currentTime) * 1000)
        print(responseTime)
    }
    
    
    public func addStringToNode(root:inout Node,parentString: String)
    {
        let trimmedParentString = parentString.trimmingCharacters(in: .whitespacesAndNewlines  )
        let splitTextArray = splitAndReturnStringArray(primaryString: trimmedParentString)
        root.parentTitle.insert( trimmedParentString )
        for j in splitTextArray
        {
            var tempStr = j.lowercased()
            root = getNodeToAppend(root: root,parentString: trimmedParentString, remainingString: tempStr)
            if let firstChar = tempStr.characters.first
            {
                tempStr.remove(at: tempStr.startIndex)
                var removedVowelString = tempStr.components(separatedBy:  CharacterSet(charactersIn: "aeiou") ).joined(separator: "")
                removedVowelString = String(firstChar) + removedVowelString
                root = getNodeToAppend(root: root,parentString: trimmedParentString, remainingString: removedVowelString)
            }
        }
    }
    
    
    public func getNodeToAppend( root: Node,parentString: String, remainingString: String) -> Node
    {
        var tempString = remainingString
        if( tempString.characters.count == 0 )
        {
            let tempRoot = root
            tempRoot.parentTitle.insert(parentString)
            return tempRoot
        }
        else{
            let char = String(tempString.characters.first!)
            //print(tempString)
            tempString.remove(at: tempString.startIndex )
            if( root.next[char] != nil )
            {
                root.next[char]!.char = char
                root.next[char]!.prevNode = root
                root.next[char]!.prevChar = root.char
                root.next[char]! = getNodeToAppend(root:root.next[char]!, parentString: parentString, remainingString: tempString)
                //print(char)
                return root
            }
            else
            {
                root.next[char] = Node()
                root.next[char]!.char = char
                root.next[char]!.prevNode = root
                root.next[char]!.prevChar = root.char
                root.next[char]! = getNodeToAppend(root: root.next[char]!, parentString: parentString, remainingString: tempString)
                //print(char)
                return root
            }
        }
    }
    
    
    public func searchSubText(searchString: String) -> Set<String>
    {
        let lowerCaseSearchString = searchString.lowercased()
        var currentNode = self.root
        if( searchString.characters.count <= 2)
        {
            return self.root.parentTitle
        }
        if( lowerCaseSearchString.characters.first != nil )
        {
            for i in lowerCaseSearchString.characters
            {
                if currentNode.next[String(i)] != nil
                {
                    currentNode = currentNode.next[String(i)]!
                }
                else if( currentNode.char != nil && currentNode.next[currentNode.char!] != nil )
                {
                    print(currentNode.char!)
                    currentNode = currentNode.next[currentNode.char!]!
                    if currentNode.next[String(i)] != nil
                    {
                        print(i)
                        currentNode = currentNode.next[String(i)]!
                    }
                }
                else{
                    print("break")
                    break
                }
            }
        }
        var returnTitles = getParentTitlesFromLastNodes(currentNode: currentNode )
        returnTitles.formIntersection(self.root.parentTitle)
        return returnTitles
    }
    
    
    public func getParentTitlesFromLastNodes(currentNode: Node) -> Set<String>
    {
        if( currentNode.next.isEmpty )
        {
            return currentNode.parentTitle
        }
        else{
            var tempParentTitle :Set<String> = Set([])
            for i in currentNode.next
            {
                tempParentTitle.formUnion(i.value.parentTitle)
                tempParentTitle.formUnion( self.getParentTitlesFromLastNodes(currentNode: i.value) )
            }
            return tempParentTitle
        }
    }
    
    
    public func deleteParentTitles(currentNode: inout Node,parentTitles: Set<String>,remainingString: String)
    {
        var tempString = remainingString
        if( tempString.characters.count == 0 )
        {
            currentNode.parentTitle.subtract( parentTitles )
            return
        }
        else{
            let char = String(tempString.characters.first!)
            //print(tempString)
            tempString.remove(at: tempString.startIndex )
            if( root.next[char] != nil )
            {
                deleteParentTitles(currentNode: &root.next[char]!, parentTitles: parentTitles, remainingString: tempString)
                //print(char)
                return
            }
            else
            {
                return
            }
        }
    }
    
    
    public func delete( titles: Set<String>)
    {
        var childStrings: Set<String> = Set([])
        for i in titles
        {
            let trimmedParentString = i.trimmingCharacters(in: .whitespacesAndNewlines  )
            let splitTextArray = splitAndReturnStringArray(primaryString: trimmedParentString)
            childStrings.formUnion(Set(splitTextArray.map { $0 }))
            root.parentTitle.remove(trimmedParentString)
        }
        for j in childStrings
        {
            var tempStr = j.lowercased()
            deleteParentTitles(currentNode: &self.root, parentTitles: titles, remainingString: tempStr)
            if let firstChar = tempStr.characters.first
            {
                tempStr.remove(at: tempStr.startIndex)
                var removedVowelString = tempStr.components(separatedBy:  CharacterSet(charactersIn: "aeiou") ).joined(separator: "")
                removedVowelString = String(firstChar) + removedVowelString
                deleteParentTitles(currentNode: &self.root, parentTitles: titles, remainingString: removedVowelString)
            }
        }
    }
    
    public func splitAndReturnStringArray(primaryString: String) -> [String]
    {
        let tempStr = primaryString.trimmingCharacters(in: .whitespacesAndNewlines  )
        let tempArray = tempStr.components(separatedBy: CharacterSet(charactersIn: ",/|%! ;.;-&"))
        return tempArray
    }
    
    
    public func searchText(searchString: String) -> [String]
    {
        let splitTextArray = splitAndReturnStringArray(primaryString: searchString)
        var splitTextResults :[Set<String>] = [Set<String>]( repeatElement( Set([]) , count: splitTextArray.count ) )
        var completeSet :Set<String> = Set([])
        var priority1Set :Set<String> = Set([])
        var priority2Set :Set<String> = Set([])
        var priority3Set :Set<String> = Set([])
        var priority4Set :Set<String> = Set([])
        var priority5Set :Set<String> = Set([])
        for i in 0..<splitTextArray.count
        {
            splitTextResults[i] = self.searchSubText(searchString: splitTextArray[i])
            completeSet.formUnion(splitTextResults[i])
        }
        for i in completeSet
        {
            var count = 0
            for j in splitTextResults
            {
                if( j.contains( i ) )
                {
                    count += 1
                }
            }
            if( count >= 3 )
            {
                if( count == 3 )
                {
                    priority3Set.insert(i)
                }
                else if( count == 4 )
                {
                    priority2Set.insert(i)
                }
                else{
                    priority1Set.insert(i)
                }
            }
            else if (count == 1 )
            {
                priority5Set.insert(i)
            }
            else if (count == 2 )
            {
                priority4Set.insert(i)
            }
        }
        var finalArray = Array( priority1Set )
        finalArray.append(contentsOf: priority2Set )
        finalArray.append(contentsOf: priority3Set )
        finalArray.append(contentsOf: priority4Set )
        finalArray.append(contentsOf: priority5Set )
        return finalArray
    }
}
