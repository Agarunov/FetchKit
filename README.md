# FetchKit

Lightweight Core Data fetch framework.

With FetchKit you can easily fetch data from store without creating `NSFetchRequest`.

## Usage
Example Core Data entity
```swift
@objc(User)
class User: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var salary: Int64
}

extension User: QueryProtocol { }
```

### Find first
Find first `User`. Sorted by firstName.
```swift
let user = try? User.findFirst()
    .sorted(by: \User.firstName)
    .execute(in: context)
```

### Find all
Find all `Users` with first name John
```swift
let allJohns = try? User.findAll()
    .where(\User.firstName, equals: "John")
    .execute(in: context)
```

### Find range
```swift
let ranged = try? User.findRange(2..<5)
    .sorted(by: \User.id)
    .execute(in: context)
```

### Get count
```swift
let usersCount = try? User.getCount()
    .execute(in: context)
```

### Min
Aggregate minimimum value of entity property
```swift
let minId = try? User.getMin(keyPath: \User.id)
    .execute(in: context)
```

### Max
Aggregate maximum value of entity property
```swift
let maxId = try? User.getMax(keyPath: \User.id)
    .execute(in: context)
```

### Delete
Delete all `Users` with first name John and returns count
```swift
let deleteCount = try? User.deleteAll()
    .where(\User.firstName, equals: "John")
    .execute(in: context)
```

### Get Distinct
Fetch dictionaries (instead of managed objects) with specified properties and aggregation functions.
Result can be grouped by properties (SQL GROUP BY)
```swift
let result = try User.getDistinct()
    .propertiesToFetch([\User.firstName])
    .aggregate(keyPath: \User.salary, function: "sum:", saveAs: "totalSalary")
    .group(by: \User.firstName)
    .execute(in: context)
```

### Fetched results controller
Return `NSFetchedResultsContoller` and perform fetch
```swift
let userFetchedResults = try? User.fetchResults()
    .group(by: \User.firstName)
    .sorted(by: \User.firstName)
    .sorted(by: \User.lastName)
    .execute(in: context)
```

## Requirements

- iOS 8.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 9.3+
- Swift 4.1+

## Installation

### CocoaPods
To integrate FetchKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'FetchKit'
```

## License
FetchKit is released under the BSD license. See [LICENSE](LICENSE).
