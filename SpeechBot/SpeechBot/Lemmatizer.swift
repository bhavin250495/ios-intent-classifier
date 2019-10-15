//
//  Lemmatizer.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 07/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import Foundation


// Use NSLinguisticTagger to lemmatize utterances
class Lemmatizer {
    typealias TaggedToken = (String, String?)

    func tag(text: String, scheme: String) -> [TaggedToken] {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: Int(options.rawValue))

        tagger.string = text
        
        var tokens: [TaggedToken] = []
        
        tagger.enumerateTags(in: NSMakeRange(0, text.count), scheme:NSLinguisticTagScheme(rawValue: scheme), options: options) { tag, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange)
            tokens.append((token, tag?.rawValue))
        }
        
        
        return tokens
    }

    func partOfSpeech(text: String) -> [TaggedToken] {
        return tag(text: text, scheme: NSLinguisticTagScheme.lexicalClass.rawValue)
    }

    func lemmatize(text: String) -> [TaggedToken] {
        return tag(text: text.lowercased(), scheme: NSLinguisticTagScheme.lemma.rawValue)
    }
    
    func getLemmatizedWordTokens(text:String) -> [String]{

        let taggesTokens = lemmatize(text: text)
        
        var words = [String]()
        for tag in taggesTokens {
            
            if let word = tag.1 {
                words.append(word)
            }
            else {
                words.append(tag.0)
            }
        }
        return words
    }
}

