//
//  ContentView.swift
//  ConcurrentMapPrototype
//
//  Created by Chris Gaafary on 7/10/21.
//

import SwiftUI

struct ContentView: View {
    let array = [1, 2, 3, 4, 5]
    var body: some View {
        Button("Run Code") {
            async {
                let mapped = await array.concurrentMap2 { int in
                    
                }
                print(mapped)
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
