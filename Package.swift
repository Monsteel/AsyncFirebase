// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "AsyncFirebase",
  platforms: [.iOS(.v15), .macCatalyst(.v15), .macOS(.v10_15), .tvOS(.v15), .watchOS(.v7)],
  products: [
    .library(
      name: "AsyncFirebase",
      targets: ["AsyncFirebase"]
    ),
    .library(
      name: "AsyncFirebaseAuth",
      targets: ["AsyncFirebaseAuth"]
    ),
    .library(
      name: "AsyncFirebaseDatabase",
      targets: ["AsyncFirebaseDatabase"]
    ),
    .library(
      name: "AsyncFirebaseFirestore",
      targets: ["AsyncFirebaseFirestore"]
    ),
    .library(
      name: "AsyncFirebaseStorage",
      targets: ["AsyncFirebaseStorage"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "12.6.0")),
  ],
  targets: [
    .target(
      name: "AsyncFirebase",
      dependencies: [
        "AsyncFirebaseAuth",
        "AsyncFirebaseDatabase",
        "AsyncFirebaseFirestore",
        "AsyncFirebaseStorage",
      ],
      path: "Sources/Core"
    ),
    .target(
      name: "AsyncFirebaseAuth",
      dependencies: [
        .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
      ],
      path: "Sources/Auth"
    ),
    .target(
      name: "AsyncFirebaseDatabase",
      dependencies: [
        .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
      ],
      path: "Sources/Database"
    ),
    .target(
      name: "AsyncFirebaseFirestore",
      dependencies: [
        .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
      ],
      path: "Sources/Firestore"
    ),
    .target(
      name: "AsyncFirebaseStorage",
      dependencies: [
        .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
      ],
      path: "Sources/Storage"
    )
  ]
)
