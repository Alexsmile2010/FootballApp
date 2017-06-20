//
//  RealmManager.swift
//  FootballList
//
//  Created by user on 20.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import RealmSwift

typealias updateBlock = () -> Void

class RealmManager
{
    static let shared : RealmManager = {
        let instance = RealmManager()
        return instance
    }()
    
    open var likedPosts: [String] = []
    
    fileprivate let realm = try! Realm()
    
    open func write(object: Object)
    {
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    open func delete(object: Object)
    {
        try! self.realm.write {
            self.realm.delete(object)
        }
    }
    
    open func update(block: updateBlock)
    {
        try! self.realm.write {
            block()
        }
    }
    
    open func saveUser(user: User)
    {
        let savedUser = self.realm.objects(User.self).first
        
        if savedUser == nil
        {
            self.write(object: user)
        }
        else if savedUser?.id != user.id
        {
            self.delete(object: savedUser!)
            self.write(object: user)
        }
    }
    
    open func getUser() -> User?
    {
        return self.realm.objects(User.self).first
    }
    
    
    open func isFavoritePost(post: Post) -> (isFavorite: Bool, post: Post?, favorite: Favorite?)
    {
        let favories = self.realm.objects(Favorite.self).filter("uid =='\(Firebase.shared.getUserUID())' AND ANY posts.key == '\(post.key)'")
        
        if (favories.count == 0 || favories.first?.posts.count == 0) { return (false, nil, nil) }
        
        if let posts = favories.first?.posts.filter("key == '\(post.key)'"), posts.count == 1
        {
            return (true, posts.first, favories.first)
        }
        else
        {
            return (false, nil, nil)
        }
    }
    
    open func addPostToFavorite(post: Post)
    {
        //Ищем раннее сохраненные посты
        let posts = self.realm.objects(Post.self).filter("key == '\(post.key)'")
        //Если постов нет то записываем этот пост в базу чтобы в дальшейнем не удалять его и не записывать заново
        if posts.count == 0
        {
            self.write(object: post)
        }
        
        //Ищем наш объект с избранным
        let favorites = self.realm.objects(Favorite.self).filter("uid =='\(Firebase.shared.getUserUID())'")
        
        //Если нашли
        if favorites.count == 1
        {
            let favorite = favorites.first
            self.update(block: { 
                favorite?.posts.append(post)
            })
        }
        else
        {
            let favorite = Favorite()
            favorite.posts.append(post)
            favorite.uid = Firebase.shared.getUserUID()
            RealmManager.shared.write(object: favorite)
        }
    }
    
    open func removeFromFavorites(post: Post, favorite: Favorite)
    {
        self.update { 
            favorite.posts.remove(objectAtIndex: favorite.posts.index(of: post)!)
        }
    }
}
