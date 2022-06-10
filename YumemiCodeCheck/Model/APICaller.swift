//
//  APICaller.swift
//  iOSEngineerCodeCheck
//
//  Created by 高橋蓮 on 2022/06/05.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import Foundation
import UIKit
//MARK: -API call class
//APIをとってくるクラス
final class APICaller {
    static let shared = APICaller()
    struct Constants {
        static let baseurl = "https://api.github.com"
    }
    //SearchBarのtext取得し、APIの情報を取得する
    public func Searchs(with query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        let urlString = URL(string: Constants.baseurl + "/search/repositories?q=\(queryString)")!
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(Articles.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

//MARK: -Models

struct Articles: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let description: String?
    let html: String
    
    let owner: Owner
    
    var avatarImageUrl: URL? {
        return URL(string: owner.avatarUrl)
    }
    //enumを使うことでアンスコ_を使わない様にする
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case description = "description"
        case owner = "owner"
        case html = "html_url"
    }
}

struct Owner: Codable {
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
