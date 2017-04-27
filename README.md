# FetchKit

Lightweight Core Data fetch framework.

With FetchKit you can easy fetch data from store without creating `NSFetchRequest`.

## Usage
Example Core Data entity
```swift
@objc(User)
class User: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
}
```

### Find first
Find first `User`. Sorted by firstName.
```swift
let user = try? findFirst<User>()
    .sorted(by: #keyPath(User.firstName))
    .execute(in: context)
```

### Find all
Find all `Users` with first name John
```swift
let allJohns = try? findAll<User>()
    .where(#keyPath(User.firstName), equals: "John")
    .execute(in: context)
```

### Find range
```swift
let ranged = try? findRange<User>(2..<5)
    .sorted(by: #keyPath(User.id))
    .execute(in: context)
```

### Get count
```swift
let usersCount = try? getCount<User>()
    .execute(in: context)
```

### Min
Aggregate minimimum value of entity property
```swift
let minId = try? getMin<User>(property: #keyPath(User.id))
    .execute(in: context)
```

### Max
Aggregate maximum value of entity property
```swift
let maxId = try? getMax<User>(property: #keyPath(User.id))
    .execute(in: context)
```

### Delete
Delete all `Users` with first name John and returns count
```swift
let deleteCount = try? deleteAll<User>()
    .where(#keyPath(User.firstName), equals: "John")
    .execute(in: context)
```

### Fetched results controller
Return `NSFetchedResultsContoller` and perform fetch
```swift
let userFetchedResults = try? fetchResults<User>()
    .group(by: #keyPath(User.firstName))
    .sorted(by: #keyPath(User.firstName))
    .sorted(by: #keyPath(User.lastName))
    .execute(in: context)
```

## Requirements

- iOS 8.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

### CocoaPods
To integrate FetchKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'FetchKit'
```

## License
FetchKit is released under the BSD license. See [LICENSE](LICENSE).
