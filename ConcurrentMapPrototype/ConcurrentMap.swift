//
//  ConcurrentMapV2.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import Foundation

fileprivate actor ConcurrentContainer<T> {
    let count: Int
    var dict = [Int: T]()
    
    init(count: Int) {
        self.count = count
    }
    
    func setValue(_ value: T, for key: Int) {
        self.dict[key] = value
    }
    
    func getArray() -> [T] {
        guard dict.count == count else {
            fatalError("Dict count does not match expected output count")
        }
        
        let resorted = dict.sorted { $0.key < $1.key}
        
        var output = [T]()
        resorted.forEach { (key, value) in
            output.append(value)
        }
        
        return output
    }
}

extension Array {
    // First attempt at an asyncronous map() implementation with concurrency using
    // Swift's new concurrency features
    func concurrentMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        let container = ConcurrentContainer<T>(count: self.count)
        
        // Create a TaskGroup to run transform at each index concurrently
        // Transform should be a pure function
        print("Creating Task Group")
        await withTaskGroup(of: (Int, T).self) { taskGroup in
            for index in 0 ..< self.count {
                taskGroup.async {
                    print("Apply transform at index \(index)")
                    let newValue = await transform(self[index])
                    let tuple: (Int, T) = (index, newValue)
                    
                    return tuple
                }
            }
            
            // Cache each index and associated value into the container actor
            // The container will transform the unordered values back to the
            // original order after the TaskGroup is completed
            print("Cache results into container actor")
            for await result in taskGroup {
                let (index, value) = result
                print("Caching index \(index)")
                await container.setValue(value, for: index)
            }
        }
        
        // Retrieve the data in the correct order as an array
        print("Retrieve reordered transformed data")
        return await container.getArray()
    }
}
