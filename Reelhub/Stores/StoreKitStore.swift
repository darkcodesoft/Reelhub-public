//
//  StoreKitStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 6/6/23.
//

import Foundation
import StoreKit

@MainActor
class StoreKitStore: ObservableObject {
    // Singleton
    static let shared = StoreKitStore()
    private let productIds = ["reelhub_monthly"]
    private var updates: Task<Void, Error>? = nil
    
    // @Published var products = [Product]()
    @Published private(set) var subscriptions: [Product]
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published var subscribed: Bool = false {
        didSet {
            UserStore.shared.isLoggedIn = subscribed
        }
    }
    
    
    /// Start transaction observer on init.
    init() {
        subscriptions = []
        updates = observeTransactionUpdates()
        Task {
            // load StoreKit subscription product.
            await loadProducts()
            // load subscription status.
            await updateSubscriptionStatus()
        }
     }
    
    /// Remove transaction observer on deinit.
    deinit {
        updates?.cancel()
    }
    
    ///
    /// Load subscription
    func loadProducts() async {
        guard subscriptions.isEmpty else { return }
        do {
            subscriptions = try await Product.products(for: productIds)
        } catch let error {
            print(error)
        }
    }

    ///
    func purchase(_ product: Product) async throws -> Transaction? {
        //Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            //Check whether the transaction is verified. If it isn't,
            //this function rethrows the verification error.
            let transaction = try checkVerified(verification)
            
            //The transaction is verified. Deliver content to the user.
            // await updateCustomerProductStatus()
            await updateSubscriptionStatus()
            
            //Always finish a transaction.
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    ///
    /// Update subscription status
    func updateSubscriptionStatus() async {
        var purchasedSubscriptions: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productType == .autoRenewable {
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                        subscribed = true
                    } else {
                        subscribed = false
                    }
                } else {
                    subscribed = false
                }
             } catch {
                print()
            }
        }
    }
    
    ///
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
        
    ///
    ///
    func observeTransactionUpdates() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)

                    //Deliver products to the user.
                    await self.updateSubscriptionStatus()

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
}

extension StoreKitStore {
    enum StoreError: Error {
        case failedVerification
    }
}
