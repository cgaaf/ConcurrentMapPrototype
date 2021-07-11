//
//  ContentView.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import SwiftUI

struct ContentView: View {
    let array = [1, 2, 3, 4, 5]
    let array2 = ["A", "B", "C", "D", "E"]
    
    var body: some View {
        Button("Run Code") {
            async {
                let mapped1 = await array.concurrentMap2 { (int: Int) async -> Int in
                    let asyncInt = await withCheckedContinuation({ continuation in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            continuation.resume(returning: int)
                        }
                    })
                    
                    return asyncInt
                }
                print(mapped1)
                
                let mapped2 = await array2.asyncMap { (string: String) async -> String in
                    let asyncString = await withCheckedContinuation({ continuation in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            continuation.resume(returning: string)
                        }
                    })
                    return asyncString
                }
                
                print(mapped2)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
