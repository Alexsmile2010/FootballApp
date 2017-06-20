//
//  Post.swift
//  FootballList
//
//  Created by user on 20.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import RealmSwift

enum PostType: Int{
    case defaultType = 0
    case fullNews = 1
}



class Post: Object
{
    dynamic var showBanner: Bool = false
    dynamic var uid: String = ""
    dynamic var autor: String = ""
    dynamic var title: String = ""
    dynamic var url: String = ""
    dynamic var timestamp: Int64 = 0
    dynamic var votes: Int = 0
    dynamic var key: String = ""
    dynamic var desc: String = ""
    dynamic var type: Int = 0
    dynamic var imgW: Int = 0
    dynamic var imgH: Int = 0

    
    //Так как мы не можем записать в Realm Url делаем игнорируемое свойство которе возвращает URL из строки
    var imgUrl: URL {
        return URL(string: self.url)!
    }
    
    var postType: PostType? {
        return PostType(rawValue: self.type)
    }
    
    //Игнорируем это свойство чтобы оно не было доступно как Realm свойсвто а как обычный ivar
    override static func ignoredProperties() -> [String]
    {
        return ["imgUrl", "postType"]
    }

    //переопределяем Equatable метод дле "Contains" функции массива
    override func isEqual(_ object: Any?) -> Bool
    {
        let post = object as? Post
        return self.key == post?.key && self.title == post?.title && self.url == post?.url && self.desc == post?.desc
    }
    
    //Функционал лайка
    func addSubtrackVote(addVote: Bool)
    {
        RealmManager.shared.update {
            
            if addVote == true
            {
                self.votes += 1
            }
            else
            {
                self.votes -= 1
            }
            
            Firebase.shared.getNewsRef(newsKey: self.key).child(FRBKEYS.VOTES).setValue(self.votes)
        }
    }
}
