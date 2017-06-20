//
//  Favorite.swift
//  FootballList
//
//  Created by user on 20.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object
{
    dynamic var uid: String = ""
    let posts = List<Post>()
}
