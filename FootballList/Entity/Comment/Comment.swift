//
//  Comment.swift
//  FootballList
//
//  Created by user on 01.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import RealmSwift

class Comment: Object
{
    dynamic var uid: String = ""
    dynamic var comment: String = ""
    dynamic var timestamp: Int64 = 0
    dynamic var author: String = ""
    
    
    //переопределяем Equatable метод дле "Contains" функции массива
    override func isEqual(_ object: Any?) -> Bool
    {
        let comment = object as? Comment
        return self.uid == comment?.uid && self.comment == comment?.comment && self.timestamp == comment?.timestamp && self.author == comment?.author
    }
}
