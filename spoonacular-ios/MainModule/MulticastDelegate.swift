//
//  MulticastDelegate.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 21/11/22.
//

import Foundation

class MulticastDelegate<T> {
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    func addDelegate(_ delegate: T?) {
        guard let delegate = delegate else { return }
        delegates.add(delegate as AnyObject?)
    }
    
    func removeDelegate(_ delegate: T?) {
        guard let delegate = delegate else { return }
        delegates.remove(delegate as AnyObject?)
    }
    
    func invokeDelegates(_ invocation: (T) -> Void) {
        delegates.allObjects.forEach {
            if let delegate = $0 as? T {
                invocation(delegate)
            }
        }
    }
    
    func removeDelegates() {
        delegates.removeAllObjects()
    }
}
