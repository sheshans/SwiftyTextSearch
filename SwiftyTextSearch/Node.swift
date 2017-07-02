//
//  Node.swift
//  SwiftyTextSearch
//
//  Created by Sheshans Yadav on 7/2/17.
//  Copyright (c) 2017 Sheshans Yadav. All rights reserved.
//

import UIKit

@objc(Node)
open class Node: NSObject,NSCoding{
    
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
    var next: [String:Node] = [String:Node]()
    var prevChar: String?
    var prevNode: Node?
    
    override public init()
    {
        super.init()
    }
    
    
    public init( char: String?,parentTitle: Set<String>?,next:[String:Node]?,prevChar: String? ,prevNode: Node? )
    {
        self.char = char
        self.parentTitle = parentTitle ?? Set([])
        self.next = next ?? [String:Node]()
        self.prevChar = prevChar
        self.prevNode = prevNode
    }
    
    //Mark: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(char,forKey: PropertyKey.charKey )
        aCoder.encode(parentTitle,forKey: PropertyKey.parentTitleKey )
        aCoder.encode(next ,forKey: PropertyKey.nextKey )
        aCoder.encode(prevChar,forKey: PropertyKey.prevCharKey )
        aCoder.encode(prevNode,forKey: PropertyKey.prevNodeKey )
    }
    
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let char = aDecoder.decodeObject(forKey: PropertyKey.charKey ) as! String?
        let parentTitle = aDecoder.decodeObject(forKey: PropertyKey.parentTitleKey ) as! Set<String>? ?? Set([])
        let next = (aDecoder.decodeObject(forKey: PropertyKey.nextKey ) as! [String:Node]?) ?? [String:Node]()
        let prevChar = aDecoder.decodeObject(forKey: PropertyKey.prevCharKey ) as! String?
        let prevNode = aDecoder.decodeObject(forKey: PropertyKey.prevNodeKey ) as! Node?
        self.init( char: char,parentTitle: parentTitle,next : next,prevChar: prevChar ,prevNode: prevNode )
    }
}
