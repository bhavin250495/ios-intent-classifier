//
//  Embeddings.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 11/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import Foundation


class Embeddings {
    
    private let file_name = "Embeddings"
    
    private var token = [String:Double]()
    
    init() {
        read_file()
        
    }
    
    private func read_file() {
        if let path = Bundle.main.path(forResource: file_name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String:Double] {
                    token = jsonResult
                }
            } catch {
                // handle error
            }
        }
    }
    func textToSequence(textArr:[String],length:Int=10) -> [Double]{
        var tokenArr = [Double]()
        
        for word in textArr {
            let token =   getTokenForWord(word: word)
            tokenArr.append(token)
        }
        let difference =  length - tokenArr.count 
        for _ in 0..<difference {
            tokenArr.append(0)
        }
        return tokenArr
    }
    
    func getTokenForWord(word:String) -> Double{
        let token_embedding = token[word.lowercased()] ?? 0
        print(token_embedding)
        return token_embedding
    }
    
    
    
    
}
