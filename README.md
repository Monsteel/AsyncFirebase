# AsyncFirebase

#### Swift의 AsyncStream을 활용하여 Firebase 요소를 observe할 수 있습니다.

[There is also an explanation in English.](https://github.com/Monsteel/AsyncFirebase/tree/main/README_EN.md)

## 사용방법

### Auth

```swift
import AsyncFirebaseAuth
import FirebaseAuth

let auth = Auth.auth()

Task {
  // Example of using stateDidChangeAsync() function
  for await user in auth.stateDidChangeAsync() {
    if let user = user {
      print("User is signed in: \(user.uid)")
    } else {
      print("User is signed out")
    }
  }
}
```

### Database

```swift
import AsyncFirebaseDatabase
import FirebaseDatabase

let databaseRef = Database.database().reference()

// Example of using async(eventType:) function
Task {
  let query = databaseRef.child("some/path")
  for await snapshot in query.async(eventType: .value) {
    print("Received snapshot: \(snapshot)")
  }
}

// Example of using observeSingleEvent(_:) function
Task {
  let query = databaseRef.child("some/other/path")
  do {
    let snapshot = try await query.observeSingleEvent(.value)
    print("Single event snapshot: \(snapshot)")
  } catch {
    print("Error observing single event: \(error)")
  }
}
```

### Firestore (collection)

```swift
import AsyncFirebaseFirestore
import FirebaseFirestore

let firestore = Firestore.firestore()
let query = firestore.collection("your_collection_name")

// Example of using async() function
Task {
  for await snapshot in query.async() {
    print("Received snapshot: \(snapshot)")
  }
}

// Example of using async(as:documentSnapshotMapper:querySnapshotMapper:) function
Task {
  struct YourModel: Decodable {
    let id: String
    let name: String
  }

  let documentMapper: (DocumentSnapshot) throws -> YourModel? = { document in
    guard let data = document.data() else { return nil }
    return YourModel(id: document.documentID, name: data["name"] as? String ?? "")
  }

  let queryMapper: (QuerySnapshot, (DocumentSnapshot) throws -> YourModel?) -> [YourModel] = { querySnapshot, documentMapper in
    return querySnapshot.documents.compactMap { try? documentMapper($0) }
  }

  for await models in query.async(as: YourModel.self, documentSnapshotMapper: documentMapper, querySnapshotMapper: queryMapper) {
    for model in models {
      print("Received model: \(model)")
    }
  }
}
```

### Firestore (document)

```swift
import AsyncFirebaseFirestore
import FirebaseFirestore

// Example of using async() function with DocumentReference
let documentRef = firestore.collection("your_collection_name").document("your_document_id")

Task {
  for await snapshot in documentRef.async() {
    print("Received document snapshot: \(snapshot)")
  }
}

// Example of using async(as:documentSnapshotMapper:) function with DocumentReference
struct YourModel: Decodable {
  let id: String
  let name: String
}

let documentMapper: (DocumentSnapshot) throws -> YourModel? = { document in
  guard let data = document.data() else { return nil }
  return YourModel(id: document.documentID, name: data["name"] as? String ?? "")
}

Task {
  for await model in documentRef.async(as: YourModel.self, documentSnapshotMapper: documentMapper) {
    if let model = model {
      print("Received model: \(model)")
    }
  }
}
```

### Storage

```swift
import AsyncFirebaseStorage
import FirebaseStorage

// Example of using asyncStream(status:) function with StorageObservableTask

let storageRef = Storage.storage().reference().child("your_file_path")
let uploadTask = storageRef.putData(yourData, metadata: nil)

Task {
  for await snapshot in uploadTask.asyncStream(status: .success) {
    print("Upload progress: \(snapshot.progress?.fractionCompleted ?? 0)")
  }
}
```

## Swift Package Manager(SPM) 을 통해 사용할 수 있어요

```swift
dependencies: [
  .package(url: "https://github.com/Monsteel/AsyncFirebase.git", .upToNextMajor(from: "0.0.1"))
]
```

## 사용하고 있는 곳.

| 회사                                                                                                    | 설명                                                                                                                                                           |
| ------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/ddca8614-c940-425c-a0d1-6a0e8f9d2458" height="50"> | Firebase 및 Firestore를 사용중인 [정육각 런즈 앱](https://apps.apple.com/kr/app/%EC%A0%95%EC%9C%A1%EA%B0%81-%EB%9F%B0%EC%A6%88/id1544435627)에서 사용중입니다. |

## 함께 만들어 나가요

개선의 여지가 있는 모든 것들에 대해 열려있습니다.<br>
PullRequest를 통해 기여해주세요. 🙏

## License

AsyncFirebase 는 MIT 라이선스로 이용할 수 있습니다. 자세한 내용은 [라이선스](https://github.com/Monsteel/AsyncFirebase/tree/main/LICENSE) 파일을 참조해 주세요.<br>
AsyncFirebase is available under the MIT license. See the [LICENSE](https://github.com/Monsteel/AsyncFirebase/tree/main/LICENSE) file for more info.

## Auther

이영은(Tony) | dev.e0eun@gmail.com

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FMonsteel%2FAsyncFirebase&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
