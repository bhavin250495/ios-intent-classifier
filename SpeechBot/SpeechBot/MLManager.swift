//
//  MLManager.swift
//  SpeechBot
//
//  Created by Suthar, Bhavin Udavji on 11/10/19.
//  Copyright © 2019 Suthar, Bhavin Udavji. All rights reserved.
//

import Foundation
import CoreML
import NaturalLanguage

protocol Results {
    func predicted_label(text:String)
}

class MLManager {
    
    var delegate:Results?
    
    func classifyTheIntent(text:String)  {
                
        let tokens = preProcessData(text: text)
        print(tokens)
        let modelInput = convertToModelInput(tokens: tokens)
        infer(input: modelInput)
        
    }
    
    func convertToModelInput(tokens:[Double]) -> MLMultiArray{
        let arr = try! MLMultiArray.init(shape: [10,1,1], dataType: .double)
        for i in 0..<tokens.count {
            arr[i] = NSNumber.init(value: tokens[i])
        }
        print(arr)
        return arr
    }
    
    func infer(input:MLMultiArray) {
        let ip =  pain_level_trainingInput.init(input1:input)
        do {
            let op = try pain_level_training().prediction(input: ip)
            print(op.classLabel)
            delegate?.predicted_label(text: op.classLabel)
        }
        catch{
            print(error)
        }
    }
    
    func preProcessData(text:String) -> [Double]{
        
        let embeddings = Embeddings()
        let lemmatize = Lemmatizer()
        let test_str =  preprocess_text(text: text)
        let test_str_arr =  lemmatize.getLemmatizedWordTokens(text: test_str)
        let tokens = embeddings.textToSequence(textArr: test_str_arr)

        return tokens
    }
    
    func postProcess(output:MLMultiArray) {
        

    }
}
extension MLManager {
    func preprocess_text(text:String) -> String{
        //lower case string
        var sentence = text.lowercased()
        
        //remove special characters
        let special_char_regex = try? NSRegularExpression.init(pattern: "\\W", options: .caseInsensitive)
        var range = NSRange.init(location: 0,length: sentence.count)
        sentence = special_char_regex?.stringByReplacingMatches(in: sentence, options: [], range: range, withTemplate: " ") ?? ""
        
        //remove all single character
        let single_char_regex = try? NSRegularExpression.init(pattern: "\\s+[a-zA-Z]\\s", options: .caseInsensitive)
        range = NSRange.init(location: 0,length: sentence.count)
        sentence = single_char_regex?.stringByReplacingMatches(in: sentence, options: [], range: range, withTemplate: " ") ?? ""
        
        //remove single character in start
        let start_single_char_regex = try? NSRegularExpression.init(pattern: "^[a-zA-Z]\\s", options: .caseInsensitive)
        range = NSRange.init(location: 0,length: sentence.count)
        sentence = start_single_char_regex?.stringByReplacingMatches(in: sentence, options: [], range: range, withTemplate: " ") ?? ""
        
        //substituting starting white space with no space
        let starting_space_regex = try? NSRegularExpression.init(pattern: "^\\s+", options: .caseInsensitive)
        range = NSRange.init(location: 0,length: sentence.count)
        sentence = starting_space_regex?.stringByReplacingMatches(in: sentence, options: [], range: range, withTemplate: "") ?? ""
        
        //Make sure there is no white space in starting or else tokenizer will not work
        let tokenizer = NLTokenizer.init(unit: .word)
        tokenizer.string = sentence
        
        let tokens = tokenizer.tokens(for: sentence.startIndex..<sentence.endIndex)
        
        var wordTokens = [String]()
        
        for token in tokens{
            wordTokens.append("\(sentence[token])")
        }
        print(wordTokens)
        return sentence
    }
}
