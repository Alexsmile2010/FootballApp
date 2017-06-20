//
//  Firebase.swift
//  FootballList
//
//  Created by user on 19.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import FirebaseAuth

typealias EmeilLoginCompletionBlock = () -> Swift.Void

class Firebase
{
    static let shared : Firebase = {
        let instance = Firebase()
        return instance
    }()
    
    var mainRef: FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
}

//MARK: - USER

extension Firebase
{
    open func getUser() -> FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.USERS).child(self.getUserUID())
    }
    
    open func getUserUID() -> String
    {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
}

//MARK: - COMMENTS

extension Firebase
{
    open func getPostCommentsRef(key: String) -> FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.COMMENTS).child(key)
    }
}

//MARK: - VOTE

extension Firebase
{
    open func getVoteRef(newsKey: String) -> FIRDatabaseReference
    {
        return self.getUser().child(FRBKEYS.VOTES).child(newsKey)
    }
    
    open func getUserVoteByPostRef(postKey: String) -> FIRDatabaseReference
    {
        return self.getUser().child(FRBKEYS.VOTES).child(postKey)
    }
}

//MARK: - POSTS

extension Firebase
{
    open func getNewsRef(newsKey: String) ->FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.POSTS).child(newsKey)
    }
    
    open func getPostsRef() -> FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.POSTS)
    }
    
}

//MARK: - VIDEOPOSTS

extension Firebase
{
    open func getVideosRef(videoKey: String) ->FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.VIDEOPOSTS).child(videoKey)
    }
}

//MARK: - USERNAMES

extension Firebase
{
    open func getUserNamesRef() ->FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.USERNAMES)
    }
    
    open func getUserNameByIdRef(userId: String) ->FIRDatabaseReference
    {
        return self.mainRef.child(FRBKEYS.USERNAMES).child(userId)
    }
}
