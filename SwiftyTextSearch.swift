//
//  SwiftyTextSearch.swift
//
//
//  Created by Sheshans Yadav on 7/2/17.
//
//

import UIKit

@objc(node)
class node: NSObject,NSCoding{
    
    struct PropertyKey
    {
        static let charKey: String = "char"
        static let parentTitleKey: String = "parenTitle"
        static let nextKey: String = "next"
        static let prevCharKey: String = "prevChar"
        static let prevNodeKey: String = "prevNode"
        
    }
    var char: String?
    var parentTitle: Set<String> = Set([])
    var next: [String:node] = [String:node]()
    var prevChar: String?
    var prevNode: node?
    override init()
    {
        super.init()
    }
    init( char: String?,parentTitle: Set<String>?,next:[String:node]?,prevChar: String? ,prevNode: node? )
    {
        self.char = char
        self.parentTitle = parentTitle ?? Set([])
        self.next = next ?? [String:node]()
        self.prevChar = prevChar
        self.prevNode = prevNode
    }
    
    //Mark: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(char,forKey: PropertyKey.charKey )
        aCoder.encode(parentTitle,forKey: PropertyKey.parentTitleKey )
        aCoder.encode(next ,forKey: PropertyKey.nextKey )
        aCoder.encode(prevChar,forKey: PropertyKey.prevCharKey )
        aCoder.encode(prevNode,forKey: PropertyKey.prevNodeKey )
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let char = aDecoder.decodeObject(forKey: PropertyKey.charKey ) as! String?
        let parentTitle = aDecoder.decodeObject(forKey: PropertyKey.parentTitleKey ) as! Set<String>? ?? Set([])
        let next = (aDecoder.decodeObject(forKey: PropertyKey.nextKey ) as! [String:node]?) ?? [String:node]()
        let prevChar = aDecoder.decodeObject(forKey: PropertyKey.prevCharKey ) as! String?
        let prevNode = aDecoder.decodeObject(forKey: PropertyKey.prevNodeKey ) as! node?
        self.init( char: char,parentTitle: parentTitle,next : next,prevChar: prevChar ,prevNode: prevNode )
    }
}

class SwiftyText: NSObject,NSCoding{
    private var root: node
    
    struct PropertyKey
    {
        static let rootKey: String = "root"
    }
    
    //Mark: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(root,forKey: PropertyKey.rootKey )
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let root = aDecoder.decodeObject(forKey: PropertyKey.rootKey ) as! node
        self.init(root: root)
    }
    
    init( root: node )
    {
        self.root = root
    }
    override init() {
        root = node()
        super.init()
        let testArr: [String] = ["Action required","Action Completed","MacBook Pro","Hajmola Imli","Power Bank","Graduation Day","The Big Bang Theory","Mr. Robot","Breaking Bad","Game of Thromes","How to Get Away With Murder","Friends","Narendra Modi","Modern Family","Data Analytics","india","Harry Potter","Bit Coin","MacBook Air","MacBook","HP Spectre","Lenovo Laptop","Samsung Laptop","Windows Laptop","Lenovo Mobiles","Samsung Mobiles","Windows Mobiles","xyz Mobiles","xyz Laptops"]
        appendStrings(arr: testArr)
    }
    
    init( arr: [String] )
    {
        root = node()
        super.init()
        appendStrings(arr: arr)
    }
    
    func appendStrings(arr: [String])
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
    
    func addStringToNode(root:inout node,parentString: String)
    {
        let trimmedParentString = parentString.trimmingCharacters(in: .whitespacesAndNewlines  )
        let splitTextArray = splitAndReturnStringArray(primaryString: trimmedParentString)
        root.parentTitle.insert( trimmedParentString )
        for j in splitTextArray
        {
            root = getNodeToAppend(root: root,parentString: trimmedParentString, remainingString: j.lowercased())
            var tempStr = j
            if let firstChar = tempStr.characters.first
            {
                tempStr.remove(at: tempStr.startIndex)
                tempStr.lowercased()
                var removedVowelString = tempStr.components(separatedBy:  CharacterSet(charactersIn: "aeiou") ).joined(separator: "")
                removedVowelString = String(firstChar) + removedVowelString
                root = getNodeToAppend(root: root,parentString: trimmedParentString, remainingString: removedVowelString)
            }
        }
    }
    
    func getNodeToAppend( root: node,parentString: String, remainingString: String) -> node
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
                root.next[char] = node()
                root.next[char]!.char = char
                root.next[char]!.prevNode = root
                root.next[char]!.prevChar = root.char
                root.next[char]! = getNodeToAppend(root: root.next[char]!, parentString: parentString, remainingString: tempString)
                //print(char)
                return root
            }
        }
    }
    
    func searchSubText(searchString: String) -> Set<String>
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
    func getParentTitlesFromLastNodes(currentNode: node) -> Set<String>
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
    func deleteParentTitles(currentNode: inout node,parentTitles: Set<String>,remainingString: String)
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
    
    func delete( titles: Set<String>)
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
            deleteParentTitles(currentNode: &self.root, parentTitles: titles, remainingString: j.lowercased())
            var tempStr = j
            if let firstChar = tempStr.characters.first
            {
                tempStr.remove(at: tempStr.startIndex)
                tempStr.lowercased()
                var removedVowelString = tempStr.components(separatedBy:  CharacterSet(charactersIn: "aeiou") ).joined(separator: "")
                removedVowelString = String(firstChar) + removedVowelString
                deleteParentTitles(currentNode: &self.root, parentTitles: titles, remainingString: removedVowelString)
            }
        }
    }
    
    func splitAndReturnStringArray(primaryString: String) -> [String]
    {
        let tempStr = primaryString.trimmingCharacters(in: .whitespacesAndNewlines  )
        let tempArray = tempStr.components(separatedBy: CharacterSet(charactersIn: ",/|%! ;.;-&"))
        return tempArray
    }
    func searchText(searchString: String) -> [String]
    {
        let splitTextArray = splitAndReturnStringArray(primaryString: searchString)
        splitTextArray.count
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
        completeSet.count
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
