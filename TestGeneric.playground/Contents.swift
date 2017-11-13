//: Playground - noun: a place where people can play

import UIKit

/// Generic Function

//T is a type parameter is a placeholder for type, not a value
func swapTwoValue<T>(_ a: inout T, _ b: inout T) {
    let temporary = a
    a = b
    b = temporary
}

var a = 10
var b = 20
swap(&a, &b)
a
b

var s1 = "Hello"
var s2 = "world"
swap(&s1, &s2)
s1
s2


/// Generic for class
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfString = Stack<String>()
stackOfString.push("Hello")
stackOfString.push("world")
//stackOfString.pop()
//stackOfString.pop()


/// Extending a Generic Type
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

stackOfString.topItem


///Type Constraint


///Type Constraint Syntax
/*
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    
}
*/

//eg:

func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) ->Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])



/// Associated Types
/*
 When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the protocol’s definition.
 An associated type gives a placeholder name to a type that is used as part of the protocol.
 The actual type to use for that associated type isn’t specified until the protocol is adopted.
 Associated types are specified with the associatedtype keyword.”
 */

/// Aassociated Types in Action

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack: Container {
    typealias Item = Int
    var items = [Int]()
    mutating func append(_ item: Int) {
        self.append(item)
    }
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
}


protocol Service1 {
    associatedtype Model
    func value() -> Model
}

protocol Service2 {
    associatedtype Model
}

class FakeSerivce: Service2 {
    typealias Model = String
}

class Serivce<S: FakeSerivce>: Service1 {
    typealias Model = S.Model
    func value() -> Model {
        return "String"
    }
}

Serivce().value()




