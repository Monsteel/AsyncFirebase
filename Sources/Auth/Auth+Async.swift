//
//  Auth+Async.swift
//  AsyncFirebaseAuth
//
//  Created by Tony on 10/30/24.
//

import FirebaseAuth

extension Auth {
  public func stateDidChangeAsync() -> AsyncStream<User?> {
    return AsyncStream { continuation in
      let handle = self.addStateDidChangeListener { auth, user in
        continuation.yield(user)
      }
      
      continuation.onTermination = { @Sendable _ in
        self.removeStateDidChangeListener(handle)
      }
    }
  }
}
