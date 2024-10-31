//
//  DatabaseQuery+Async.swift
//  AsyncFirebaseDatabase
//
//  Created by Tony on 2024/10/30.
//  Copyright © 2024 Tony. All rights reserved.
//

import FirebaseDatabase

extension DatabaseQuery {
  public func async(eventType: DataEventType) -> AsyncThrowingStream<DataSnapshot, Error> {
    return AsyncThrowingStream { continuation in
      let handle = self.observe(eventType, with: { snapshot in
        continuation.yield(snapshot)
      }, withCancel: { error in
        continuation.finish(throwing: error)
      })
      
      continuation.onTermination = { _ in
        self.removeObserver(withHandle: handle)
      }
    }
  }
  
  public func observeSingleEvent(_ eventType: DataEventType) async throws -> DataSnapshot {
    return try await withCheckedThrowingContinuation { continuation in
      self.observeSingleEvent(of: eventType, with: { (snapshot) in
        continuation.resume(returning: snapshot)
      }, withCancel: { (error) in
        continuation.resume(throwing: error)
      })
    }
  }
}
