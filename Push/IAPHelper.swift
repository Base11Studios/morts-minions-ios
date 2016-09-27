//
//  Created by Ray Fix on 5/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//
//  Copyright (c) 2010, 2011 Ray Wenderlich
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Modified by Dan Bellinski - 3/7/16
//

import StoreKit
import LocalAuthentication

/// Notification that is generated when a product is purchased.
public let IAPHelperProductPurchasedNotification = "IAPHelperProductPurchasedNotification"

/// Notification that is generated when a transaction fails.
public let IAPHelperProductPurchaseFailedNotification = "IAPHelperProductPurchaseFailedNotification"

/// Product identifiers are unique strings registered on the app store.
public typealias ProductIdentifier = String

/// Completion handler called when products are fetched.
public typealias RequestProductsCompletionHandler = (_ success: Bool, _ products: [SKProduct]) -> ()


/// A Helper class for In-App-Purchases, it can fetch products, tell you if a product has been purchased,
/// purchase products, and restore purchases.  Uses NSUserDefaults to cache if a product has been purchased.
public class IAPHelper : NSObject  {
  
  /// MARK: - Private Properties
  
  // Used to keep track of the possible products and which ones have been purchased.
    let productIdentifiers: Set<ProductIdentifier>
  //private var purchasedProductIdentifiers = Set<ProductIdentifier>()
  
  // Used by SKProductsRequestDelegate
    var productsRequest: SKProductsRequest?
    var completionHandler: RequestProductsCompletionHandler?
  
  /// MARK: - User facing API
  
  /// Initialize the helper.  Pass in the set of ProductIdentifiers supported by the app.
  public init(productIdentifiers: Set<ProductIdentifier>) {
    self.productIdentifiers = productIdentifiers
    
    /*
    for productIdentifier in productIdentifiers {
      let purchased = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
      }
    }
    */
    
    super.init()
    
    SKPaymentQueue.default().add(self)
  }
  
  /// Gets the list of SKProducts from the Apple server calls the handler with the list of products.
  public func requestProductsWithCompletionHandler(_ handler: @escaping RequestProductsCompletionHandler) {
    completionHandler = handler
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }
  
  /// Initiates purchase of a product.
  public func purchaseProduct(_ product: SKProduct) {
    let payment = SKPayment(product: product)
    
    SKPaymentQueue.default().add(payment)
  }
  
    /*
  /// Given the product identifier, returns true if that product has been purchased.
  public func isProductPurchased(productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
    */
  
  /// If the state of whether purchases have been made is lost  (e.g. the
  /// user deletes and reinstalls the app) this will recover the purchases.
  public func restoreCompletedTransactions() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
}

// This extension is used to get a list of products, their titles, descriptions,
// and prices from the Apple server.

extension IAPHelper: SKProductsRequestDelegate {
  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let products = response.products
    
    self.completionHandler?(true, products)
    
    clearRequest()
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    self.completionHandler?(false, [SKProduct]())
    
    clearRequest()
  }
  
  private func clearRequest() {
    self.productsRequest = nil
    self.completionHandler = nil
  }
}


extension IAPHelper: SKPaymentTransactionObserver {
  /// This is a function called by the payment queue, not to be called directly.
  /// For each transaction act accordingly, save in the purchased cache, issue notifications,
  /// mark the transaction as complete.
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        completeTransaction(transaction)
        break
      case .failed:
        failedTransaction(transaction)
        break
      case .restored:
        restoreTransaction(transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
  
  private func completeTransaction(_ transaction: SKPaymentTransaction) {
    provideContentForProductIdentifier(transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  private func restoreTransaction(_ transaction: SKPaymentTransaction) {
    /*
    if let productIdentifier = transaction.originalTransaction?.payment.productIdentifier {
        provideContentForProductIdentifier(productIdentifier) TODO renable if we do restoring. We don't want them to get the gems from restore purchase since this is a consumable
    }*/
    
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  // Helper: Saves the fact that the product has been purchased and posts a notification.
  private func provideContentForProductIdentifier(_ productIdentifier: String) {
    //purchasedProductIdentifiers.insert(productIdentifier)

    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperProductPurchasedNotification), object: productIdentifier)
  }
  
  private func failedTransaction(_ transaction: SKPaymentTransaction) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperProductPurchaseFailedNotification), object: transaction.error)
    
    SKPaymentQueue.default().finishTransaction(transaction)
  }
}
