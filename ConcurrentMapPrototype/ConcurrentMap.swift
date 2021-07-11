//
//  Concurrentap.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import Foundation

extension Array {
    func concurrentMap<T>(_ transform: @escaping (Element) -> T) async -> [T] {
        let mutable = MutableType<Element, T>(inputArray: self)
        return await mutable.concurrentMap(transform)
    }
}

actor MutableType<InputType, OutputType> {
    var inputArray: [InputType]
    private(set) var dictionary = [Int : OutputType]()
    private(set) var outputArray = [OutputType]()
    
    init(inputArray: [InputType]) {
        self.inputArray = inputArray
    }
    
    func concurrentMap(_ transform: @escaping (InputType) -> OutputType) async -> [OutputType] {
        for index in 0 ..< inputArray.count {
            dictionary[index] = transform(inputArray[index])
            DispatchQueue.main.async {
                
            }
        }
        
        let sortedDictionary = dictionary.sorted {
            $0.key < $1.key
        }
        
        sortedDictionary.forEach {
            outputArray.append($0.value)
        }
        
        return outputArray
    }
}
