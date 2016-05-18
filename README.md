# CacheManager
CacheManager is a **swift** local caching library built on top of [Realm](http://realm.io).
Used with [Moya](https://github.com/Moya/Moya) it easily helps you to cache remote data from json.

### Features

You have simple to build an ***Object*** realm class and then create you ObjectManager using ***CacheManager<Object>***.

***CacheManager*** will allows you to:
* count items
* ignoreOnUpdate key
* sort & sortAscending on a key
* filtering

### Install

#### Pod
```
pod 'CacheManager', '0.0.1'
```

### Usage

- Create an Object Class
- Create ModelManager

```swift
import CacheManager
import Foundation

class ProductManager: CacheManager<Product> {
    private let net = Net()

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
