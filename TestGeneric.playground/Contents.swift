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
    //bind class
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


/// Extending an Existing Type to Specify an Associated Type

extension Array: Container {}


/// Using Type Annotation to Constrain an Associated Type

protocol EquableContainer {
    associatedtype Item: Equatable //Annotation to Constrain
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}


/// Generic Where Clauses

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    // Check that both containers contain the same number of items.
    if someContainer.count != anotherContainer.count {
        return false
    }
    
    // Check each pair of items to see if they're equivalent.
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    
    // All items match, so return true.
    return true
}

extension Stack: Container {
    typealias Item = Element
    
    var count: Int {
        return items.count
    }
    
    mutating func append(_ item: Element) {
        items.append(item)
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// Prints "All items match.


/// Extension with a Generic Where Clause

//You can also use a generic where clause as part of an extension.
//The example below extends the generic Stack structure from the previous examples to add an isTop(_:) method.


/// Extension a class
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings.isTop("tres") {
    print("top element is tres")
}

/// Extension a protocol
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
// Prints "Starts with something else.


// you can also write a generic where clauses that require Item to be a specific type. For example:
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}

print([1260.0, 1200.0, 98.6, 37.0].average())

/// Associated Types with a Generic Where Clause

protocol IteratableContainer {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

// For a protocol that inherits from another protocol, you add a constraint to an inherited associated type by including the generic where clause in the protocol declaration.

protocol ComparableContainer: Container where Item: Comparable {
    
}


/// Generic Subscrips

// Subscripts can be generic, and they can include generic where clauses. You write the placeholder type name inside angle brackets after subscript, and you write a generic where clause right before the opening curly brace of the subscript’s body. For example:
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
