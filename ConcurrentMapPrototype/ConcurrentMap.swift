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
    func concurrentMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        let container = ConcurrentContainer<T>(count: self.count)
        await withTaskGroup(of: (Int, T).self) { taskGroup in
            for index in 0 ..< self.count {
                taskGroup.async {
                    print("Apply transform at index \(index)")
                    let newValue = await transform(self[index])
                    let tuple: (Int, T) = (index, newValue)
                    
                    return tuple
                }
            }
            
            for await result in taskGroup {
                await container.setValue(result.1, for: result.0)
            }
        }
        
        return await container.getArray()
    }
    
    func asyncMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        var output = [T]()
        for index in 0..<self.count {
            print("Apply transform at index \(index)")
            let newElement = await transform(self[index])
            output.append(newElement)
        }
        return output
    }
}
