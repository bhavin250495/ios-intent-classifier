//
//  Embeddings.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 11/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import Foundation

 enum EmbeddingType {
    case autocorrect
    case intent_search
}

class Embeddings {
    
    private var file_name = "auto_correct_embeddings"
    
    private var token = [String:Double]()
    
   
    
    init(type: EmbeddingType) {
        read_file(type: type)
        
    }
    
    
    private func read_file(type: EmbeddingType) {
        
        if type == .autocorrect {
            file_name = "auto_correct_embeddings"
        }
        else {
            file_name = "Embeddings"
        }
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
