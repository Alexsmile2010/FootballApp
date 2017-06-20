//
//  Constants.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import Foundation

typealias Dict = Dictionary<String, AnyObject>

struct APP
{
    static let URL = "itms-apps://itunes.apple.com/app/id1235024709"
}

struct FIREBASE_API
{
    static let MAIN_URL = "https://footballlist-73b8a.firebaseio.com"
    static let NEWS_REF = "\(MAIN_URL)/posts"
    static let USER_REF = "\(MAIN_URL)/users"
    static let USERNAMES_REF = "\(MAIN_URL)/usernames"
}


struct COLORS
{
    static let MENU_BACKGROUND_COLOR: UIColor = UIColor(hexString: "1E2028")!
    static let FIRST_GRADIEND_COLOR: UIColor = UIColor(hexString: "f4f4f4")!
    static let SECOND_GRADIENT_COLOR: UIColor = UIColor(hexString: "f4f4f4")!
    static let NAV_BAR_COLOR: UIColor = UIColor(hexString: "1565C0")!
}

struct IMAGES
{
    static let NEWS = "News"
    static let COMMENTS = "Comments"
}

struct STRINGS
{
    static let MENU_ITEMS = ["Главная","Видео"]
    static let COMMENT_PLACEHOLDER = "Ваш комментарий"
    
    struct WARNINGS
    {
        static let NAME_EXIST = "Это имя уже используется"
        static let NAME_TOO_SHORT = "Имя слишком короткое"
        static let AUTH_ERROR = "Произошла ошибка авторизации. Скорее всего вы ввели не верные данные почты или пароля"
        static let NON_AUTH_MESSAGE = "Вы не авторизированы, для того чтобы пользоваться всеми функциями приложения нужно авторизироваться"
        static let WRONG_INPUT_DATA = "Данные введены не верно. Проверте правильность ввода email. Проверте совпадают ли пароли"
    }
    struct MESSAGES
    {
        static let USER_REGISTRED = "Пользователь успешно зарегистрирован"
        static let COMMENT_EMPTY = "Нельзя оставить пустой комментарий!"
    }
    struct TITLES {
        static let ATTENTION = "Внимание"
        static let AUTH = "Авторизация"
        static let CANCEL_BUTTON = "Пожалуй, я пас"
        static let REGISTR_SUCCESS = "Регистрция успешна"
        static let ERROR = "Ошибка"
        static let INVALID_INPUT = "Некоректный ввод"
        static let OK = "Ok"
    }
}

struct FRBKEYS
{
    static let UID = "uid"
    static let AUTHOR = "author"
    static let POSTS = "posts"
    static let USERS = "users"
    static let VOTES = "votes"
    static let COMMENT = "comment"
    static let COMMENTS = "comments"
    static let USERNAMES = "usernames"
    static let VIDEOPOSTS = "videoPosts"
    static let USERNAME = "username"
    static let TIMESTAMP = "timestamp"

}

struct FB
{
    static let URL = "https://www.facebook.com/"
    static let LOGIN_PERMISSION_SCOPE = [PUBLIC_PROFILE,EMAIL]
    
    private static let PUBLIC_PROFILE = "public_profile"
    private static let EMAIL = "email"
}

struct VIDME_API
{
    static let MAIN_URL = "https://api.vid.me"
    static let CHANNEL = "\(MAIN_URL)/channel"
    static let VIDEOS = "\(MAIN_URL)/videos/featured"
    ///user/16740192/videos"
    static let LIMIT = "?limit="
    static let OFFSET = "?offset="
}
