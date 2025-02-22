import Foundation

struct RuntimeVersion: Codable, Equatable {
    let specVersion: UInt32
    let transactionVersion: UInt32
}

struct RuntimeVersionFull: Codable, Equatable {
    let specVersion: UInt32
    let transactionVersion: UInt32
    let specName: String
}
