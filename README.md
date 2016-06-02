# CacheManager
CacheManager is a **swift** local caching library built on top of [Realm](http://realm.io).
Used with [Moya](https://github.com/Moya/Moya) it easily helps you to cache remote data from json.

### Features

You have simple to build an **Object** realm class and then create you ObjectManager using **CacheManager<Object>**.

**CacheManager** will allows you to:
* count items
* ignoreOnUpdate key
* sort & sortAscending on a key
* filtering

### Install

#### Pod
```
pod 'CacheManager', '0.0.3'
```

### Usage

- Create a Realm Object Class (eg. MyModel)
- Create ModelManager (eg. MyModelManager)

```swift
import CacheManager
import Foundation

class MyModelManager: CacheManager<MyModel> {
    private let net = Net()

    override func getRemoteItems(completion: (error: NSError?) -> ()) {
        net.listProductsByCategory(catName) { (prods, error) in
            if (error != nil) {
                print(error)
                completion(error: error)
            } else {
                print("Models stored locally")
                super.itemAddFromArray(prods!)
                completion(error: nil)
            }
        }
    }
}
```

This examples makes use of Moya style to retrieve items from remote, you are free to user your favorite method.


### Functions

* getRemoteItems
Force items to be updated from remote

* count
Returns the number of items cached locally

* itemAt
(Optionally) returns an item at defined index
