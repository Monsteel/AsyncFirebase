//
//  DocumentReference+Async.swift
//  AsyncFirebaseFirestore
//
//  Created by Tony on 2024/10/30.
//  Copyright © 2024 Tony. All rights reserved.
//

import FirebaseFirestore

extension DocumentReference {
  public func async(includeMetadataChanges: Bool = true) -> AsyncThrowingStream<DocumentSnapshot, Error> {
    AsyncThrowingStream { continuation in
      var registration: ListenerRegistration?

      registration = self.addSnapshotListener (includeMetadataChanges: includeMetadataChanges) { (snapshot, error) in
        if let error = error {
          continuation.finish(throwing: error)
        } else if let snapshot = snapshot {
          continuation.yield(snapshot)
        } else {
          continuation.finish(throwing: AsyncFirestoreErrorFactory.nilResultError())
        }
      }
      
      continuation.onTermination = { [weak registration] _ in
        registration?.remove()
        registration = nil
      }
    }
  }
  
  public func async<D: Decodable>(includeMetadataChanges: Bool = true, as type: D.Type, documentSnapshotMapper: @escaping (DocumentSnapshot) throws -> D? = DocumentSnapshot.defaultMapper()) -> AsyncThrowingStream<D?, Error> {
    AsyncThrowingStream { continuation in
      let listener = self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { (snapshot, error) in
        if let error = error {
          continuation.finish(throwing: error)
        } else if let snapshot = snapshot {
          do {
            let mappedValue = try documentSnapshotMapper(snapshot)
            continuation.yield(mappedValue)
          } catch {
            print("Document snapshot mapper error for \(self.path): \(error)")
            continuation.yield(nil)
          }
        } else {
          continuation.finish(throwing: AsyncFirestoreErrorFactory.nilResultError())
        }
      }
      
      continuation.onTermination = { [weak listener] _ in
        listener?.remove()
      }
    }
  }
  
  func setData<T: Encodable>(
    from value: T,
    encoder: Firestore.Encoder = Firestore.Encoder()
  ) async throws {
    let encoded = try encoder.encode(value)
    try await self.setData(encoded)
  }
}

extension DocumentSnapshot {
  public static func defaultMapper<D: Decodable>() -> (DocumentSnapshot) throws -> D? {
    { try $0.data(as: D.self) }
  }
}
