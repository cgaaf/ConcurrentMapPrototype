//
//  AsyncMap.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import Foundation

extension Array {
    // Simple asyncronous map() implementation without concurrency
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
