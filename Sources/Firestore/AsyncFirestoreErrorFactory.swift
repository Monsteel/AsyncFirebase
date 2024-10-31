//
//  AsyncFirestoreErrorFactory.swift
//  AsyncFirebaseFirestore
//
//  Created by Tony on 2024/10/30.
//  Copyright © 2024 Tony. All rights reserved.
//

import Foundation

internal enum AsyncFirestoreErrorFactory {
  private enum Code: Int {
    case nilResultError = 0
  }

  internal static func nilResultError() -> NSError {
    return NSError(
      domain: "\(Self.self)",
      code: Code.nilResultError.rawValue,
      userInfo: [:]
    )
  }
}
