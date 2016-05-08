# CacheManager

## Features

Variables
* count
* ignoreOnUpdate
* sort & sortAscending
* filter

Func
* getRemoteItems

## Usage

- Create Model
- Create ModelManager 

```
import CacheManager
import Foundation

class ProductManager: CacheManager<Product> {
    private let net = Net()

    var catName = ""

    override init() {
        super.init()
    }

    override func getRemoteItems(completion: (error: NSError?) -> ()) {
        net.listProductsByCategory(catName) { (prods, error) in
            if (error != nil) {
                Log.error(error)
                completion(error: error)
            } else {
                Log.debug("Products for cat \(self.catName) stored locally")
                super.itemAddFromArray(prods!)
                completion(error: nil)
            }
        }
    }
}
```


