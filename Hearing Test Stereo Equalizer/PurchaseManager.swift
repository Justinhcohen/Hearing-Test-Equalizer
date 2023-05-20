//
//  PurchaseManager.swift
//  Hearing Test Stereo Equalizer
//
//  Created by Justin Cohen on 5/19/23.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {

    private let productIds = ["Spex_Lifetime_01"]

    @Published private(set) var products: [Product] = []
    private var productsLoaded = false
    
    @Published
       private(set) var purchasedProductIDs = Set<String>()

       var hasPurchasedSpexLifetime: Bool {
          return !self.purchasedProductIDs.isEmpty
       }

       func updatePurchasedProducts() async {
           for await result in Transaction.currentEntitlements {
               guard case .verified(let transaction) = result else {
                   continue
               }

               if transaction.revocationDate == nil {
                   self.purchasedProductIDs.insert(transaction.productID)
               } else {
                   self.purchasedProductIDs.remove(transaction.productID)
               }
           }
       }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    private var updates: Task<Void, Never>? = nil

       init() {
           updates = observeTransactionUpdates()
       }

       deinit {
           updates?.cancel()
       }

       private func observeTransactionUpdates() -> Task<Void, Never> {
           Task(priority: .background) { [unowned self] in
               for await _ in Transaction.updates {
                   // Using verificationResult directly would be better
                   // but this way works for this tutorial
                   await self.updatePurchasedProducts()
               }
           }
       }
}
