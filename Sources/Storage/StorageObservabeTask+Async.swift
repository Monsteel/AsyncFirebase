//
//  StorageObservableTask+Async.swift
//  AsyncFirebaseStorage
//
//  Created by Tony on 2024/10/30.
//  Copyright © 2024 Tony. All rights reserved.
//

import FirebaseStorage

extension StorageObservableTask {
  public func asyncStream(status: StorageTaskStatus) -> AsyncStream<StorageTaskSnapshot> {
    return AsyncStream { continuation in
      let handle = self.observe(status) { snapshot in
        continuation.yield(snapshot)
      }
      
      continuation.onTermination = { _ in
        self.removeObserver(withHandle: handle)
      }
    }
  }
}
