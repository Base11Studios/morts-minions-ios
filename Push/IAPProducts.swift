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

import Foundation

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum IAPProducts {
  
  private static let Prefix = "gem.purchase."
  
  /// MARK: - Supported Product Identifiers
  public static let GemA = Prefix + "pouch"
  public static let GemB = Prefix + "sack"
  public static let GemC = Prefix + "chest"
  public static let GemD = Prefix + "mountain"
  
  // All of the products assembled into a set of product identifiers.
  private static let productIdentifiers: Set<ProductIdentifier> = [IAPProducts.GemA,
                                                                   IAPProducts.GemB,
                                                                   IAPProducts.GemC,
                                                                   IAPProducts.GemD]
  
  /// Static instance of IAPHelper.
  public static let store = IAPHelper(productIdentifiers: IAPProducts.productIdentifiers)
    
    public static func getProductGems(_ id: String) -> Int {
        if id == GemA {
            return 100
        } else if id == GemB {
            return 600
        } else if id == GemC {
            return 3000
        } else if id == GemD {
            return 9750
        } else {
            return 0
        }
    }
    
    public static func getProductFromEnum(_ id: String, products: [SKProduct]) -> SKProduct? {
        // Iterate products and return the right one
        for product in products {
            if product.productIdentifier == id {
                return product
            }
        }
        
        return nil
    }
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
