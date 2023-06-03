//
//  Store.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import StoreKit

class Store: ObservableObject {
    private var productIDs = ["Spex_Lifetime_03"]
    
    @Published var products = [Product]()
    
    @Published var purchasedNonConsumables = Set<Product>()
 //   @Published var purchasedNonRenewables = Set<Product>()
    
//    @Published var purchasedConsumables = [Product]()
 //   @Published var purchasedSubscriptions = Set<Product>()
    
    @Published var entitlements = [Transaction]()
    
    @Published var hasPurchasedSpexLifetime = false {
        didSet {
            print ("HAS PURCHASED SPEX LIFETIME HAS BEEN SET TO - \(hasPurchasedSpexLifetime)")
        }
    }
    
    var hasPurchasedSpexLifetimeBackup: Bool {
        !purchasedNonConsumables.isEmpty
    }
    
    var transacitonListener: Task<Void, Error>?
    
//    var tournamentEndDate: Date = {
//        var components = DateComponents()
//        components.year = 2033
//        components.month = 2
//        components.day = 1
//        return Calendar.current.date(from: components)!
//    }()
    
    init() {
        transacitonListener = listenForTransactions()
        
        Task {
            await requestProducts()
            // Must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
    }
    
    @MainActor
    func requestProducts() async {
        print ("CALLED REQUEST PRODUCTS")
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws {
        print ("CALLED PURCHASE")
        let result = try await product.purchase()
        
        switch result {
        case .success(let transacitonVerification):
            await handle(transactionVerification: transacitonVerification)
            print ("RESULT IS SUCCESS")
        default:
            return
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        print ("CALLED LISTEN FOR TRANSACTIONS")
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    @MainActor
    @discardableResult
    private func handle(transactionVerification result: VerificationResult<Transaction>) async -> Transaction? {
        print ("CALLED HANDLE TRANSACTION VERIFICATION")
        switch result {
        case let .verified(transaction):
            guard let product = self.products.first(where: { $0.id == transaction.productID}) else { return transaction }
            
            guard !transaction.isUpgraded else { return nil }
            
            self.addPurchased(product)
            
            print ("SETTING HAS PURCHASED SPEX LIFETIME TO TRUE")
            hasPurchasedSpexLifetime = true
            
            await transaction.finish()
            
            return transaction
        default:
            return nil
        }
    }
    
    @MainActor
    private func updateCurrentEntitlements() async {
        print ("CALLED UPDATE CURRENT ENTITLEMENTS")
        for await result in Transaction.currentEntitlements {
            if let transaction = await self.handle(transactionVerification: result) {
                entitlements.append(transaction)
            }
        }
    }
    
    private func addPurchased(_ product: Product) {
        print ("CALLED ADD PURCHASED")
        switch product.type {
        case .consumable:
            break
         //   purchasedConsumables.append(product)
        //    Persistence.increaseConsumablesCount()
        case .nonConsumable:
            purchasedNonConsumables.insert(product)
            print ("ADDING A NON-CONSUMABLE PURCHASE")
        case .nonRenewable:
            break
//            if Date() <= tournamentEndDate {
//                purchasedNonRenewables.insert(product)
//            }
        case .autoRenewable:
            break
            // purchasedSubscriptions.insert(product)
        default:
            return
        }
    }
}
