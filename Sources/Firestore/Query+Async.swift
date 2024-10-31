//
//  Query+Async.swift
//  AsyncFirebaseFirestore
//
//  Created by Tony on 2024/10/30.
//  Copyright © 2024 Tony. All rights reserved.
//

import FirebaseFirestore
import Combine

extension Query {
  public func async(includeMetadataChanges: Bool = true) -> AsyncThrowingStream<QuerySnapshot, Error> {
    return AsyncThrowingStream { continuation in
      var listener: ListenerRegistration?
      listener = self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { (querySnapshot, error) in
        if let error = error {
          continuation.finish(throwing: error)
        } else if let querySnapshot = querySnapshot {
          continuation.yield(querySnapshot)
        } else {
          continuation.finish(throwing: AsyncFirestoreErrorFactory.nilResultError())
        }
      }
      
      continuation.onTermination = { [weak listener] _ in
        listener?.remove()
        listener = nil
      }
    }
  }
  
  public func async<D: Decodable>(includeMetadataChanges: Bool = true, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper(), querySnapshotMapper: @escaping (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] = QuerySnapshot.defaultMapper()) -> AsyncThrowingStream<[D], Error> {
    return AsyncThrowingStream { continuation in
      let listener = self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { (querySnapshot, error) in
        if let error = error {
          continuation.finish(throwing: error)
        } else if let querySnapshot = querySnapshot {
          let mappedValues = querySnapshotMapper(querySnapshot, documentSnapshotMapper)
          continuation.yield(mappedValues)
        } else {
          continuation.finish(throwing: AsyncFirestoreErrorFactory.nilResultError())
        }
      }
      
      continuation.onTermination = { [weak listener] _ in
        listener?.remove()
      }
    }
  }
}

extension QuerySnapshot {
  public static func defaultMapper<D: Decodable>() -> (QuerySnapshot, (DocumentSnapshot) throws -> D?) -> [D] {
    { (snapshot, documentSnapshotMapper) in
      var dArray: [D] = []
      snapshot.documents.forEach {
        do {
          if let d = try documentSnapshotMapper($0) {
            dArray.append(d)
          }
        } catch {
          print("Document snapshot mapper error for \($0.reference.path): \(error)")
        }
      }
      return dArray
    }
  }
}
