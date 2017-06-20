//
//  VidmeVideoPost.swift
//  FootballList
//
//  Created by Олексій on 10.05.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import RealmSwift
import JSONJoy


class VidmeVideoPost: Object, JSONJoy
{
    dynamic var title: String = ""
    dynamic var complete_url: String = ""
    dynamic var thumbnail_url: String = ""
    dynamic var date_published: String = ""
    dynamic var video_id: String = ""
    
    dynamic var votes: Int = 0
    dynamic var key: String = ""
    
    public required convenience init(_ decoder: JSONDecoder) throws
    {
        self.init()
    }
    
    public required convenience init(_ decoder: JSONDecoder, _ index: Int) throws
    {
        self.init()
        self.title = try decoder["videos"][index]["title"].get()
        self.complete_url = try decoder["videos"][index]["complete_url"].get()
        self.thumbnail_url = try decoder["videos"][index]["thumbnail_url"].get()
        self.date_published = try decoder["videos"][index]["date_published"].get()
        self.video_id = try decoder["videos"][index]["video_id"].get()
    }
    
    //Так как мы не можем записать в Realm Url делаем игнорируемое свойство которе возвращает URL из строки
    var videoUrl: URL {
        return URL(string: self.complete_url)!
    }
    var thumbnailUrl: URL {
        return URL(string: self.thumbnail_url)!
    }
    
    //Игнорируем это свойство чтобы оно не было доступно как Realm свойсвто а как обычный ivar
    override static func ignoredProperties() -> [String]
    {
        return ["videoUrl", "thumbnailUrl"]
    }
    
    //переопределяем Equatable метод дле "Contains" функции массива
    override func isEqual(_ object: Any?) -> Bool
    {
        let post = object as? VidmeVideoPost
        return self.video_id == post?.video_id && self.date_published == post?.date_published && self.title == post?.title && self.complete_url == post?.complete_url && self.thumbnail_url == post?.thumbnail_url
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
            
            Firebase.shared.getVideosRef(videoKey: self.key).child(FRBKEYS.VOTES).setValue(self.votes)
        }
    }
}


