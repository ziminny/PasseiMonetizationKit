//
//  PMKStoreKitError.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 26/06/25.
//  Copyright © 2025 passei. All rights reserved.
//

public enum PMKStoreKitError: Error {
    case userCancelled
    case pending
    case unverified(Error)
    case unknown(Error)
}
