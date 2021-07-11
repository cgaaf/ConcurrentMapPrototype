//
//  ContentView.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import SwiftUI

struct ContentView: View {
    let array = [1, 2, 3, 4, 5]
    
    @State var completeTime: Double = 0
    
    var body: some View {
        VStack {
            Text("\(completeTime, format: .number) seconds")
            
            Button(action: runWithConcurrency) {
                Label("Run With Concurrency", systemImage: "play.fill")
            }
            .padding()
            .foregroundColor(.indigo)
            
            Button(action: runWithoutConcurrency) {
                Label("Run Without Concurrency", systemImage: "play.fill")
            }
            .padding()
            .foregroundColor(.mint)
        }
    }
    
    func runWithConcurrency() {
        let start = CFAbsoluteTimeGetCurrent()
        async {
            let result = await array.concurrentMap { (int: Int) async -> Int in
                let asyncInt = await withCheckedContinuation({ continuation in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        continuation.resume(returning: int)
                    }
                })
                
                return asyncInt
            }
            let diff = CFAbsoluteTimeGetCurrent() - start
            completeTime = diff
            print(result)
            print("Function ran in \(diff) seconds")
        }
    }
    
    func runWithoutConcurrency() {
        let start = CFAbsoluteTimeGetCurrent()
        async {
            let result = await array.asyncMap { (int: Int) async -> Int in
                let asyncInt = await withCheckedContinuation({ continuation in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        continuation.resume(returning: int)
                    }
                })
                
                return asyncInt
            }
            let diff = CFAbsoluteTimeGetCurrent() - start
            completeTime = diff
            print(result)
            print("Function ran in \(diff) seconds")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
