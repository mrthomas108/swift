//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

/// An object composed of count elements that are stored contiguously in memory.
///
/// In practice, most types conforming to this protocol will be Collections,
/// but they need not be--they need only have an Element type and count, and
/// provide the withUnsafeBufferPointer function.
@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
public protocol AccelerateBuffer {
  /// The buffer's element type.
  associatedtype Element
  
  /// The number of elements in the buffer.
  var count: Int { get }
  
  /// Calls a closure with a pointer to the object's contiguous storage.
  func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R
}

/// A mutable object composed of count elements that are stored contiguously
/// in memory.
///
/// In practice, most types conforming to this protocol will be
/// MutableCollections, but they need not be.
@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
public protocol AccelerateMutableBuffer: AccelerateBuffer {
  /// Calls the given closure with a pointer to the object's mutable
  /// contiguous storage.
  mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R
}

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
public extension AccelerateBuffer where Self: Collection {
  func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    return try withContiguousStorageIfAvailable(body)!
  }
}

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension AccelerateMutableBuffer where Self: MutableCollection {
  public mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    return try withContiguousMutableStorageIfAvailable(body)!
  }
}

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension Array: AccelerateMutableBuffer { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension ContiguousArray: AccelerateMutableBuffer { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension ArraySlice: AccelerateMutableBuffer { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension UnsafeBufferPointer: AccelerateBuffer { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension UnsafeMutableBufferPointer: AccelerateMutableBuffer { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension Slice: AccelerateBuffer where Base: Collection { }

@available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
extension Slice: AccelerateMutableBuffer where Base: MutableCollection { }
