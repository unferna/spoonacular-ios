# Spoonacular-ios

## Requirements
- iOS 15.5+
- XCode 14.0+
- CocoaPods 1.11.X+

## Installation
This project gets its dependencies from [CocoaPods](https://cocoapods.org/) which means that you need to install it before compiling the project.
Once you already have CocoaPods installed, run `pod install` at the root of the project in your terminal. From this, you must open the project using the `.xcworkspace` file generated.

## Build
Build the project by pressing `⌘ + B` and run the project.

## Architecture
The chosen architecture for this project is **Model View Presenter** (MVP), since we won't have a big business logic far beyond fetching and persisting objects. Just a presenter is needed to ask the model (DataService) for information. After that DataService is in charge of getting the data and it validates if it needs to be loaded from the server or locally. The biggest logic is to fetch and save `recipe details` when an item is bookmarked from the `Home Screen`.

## Design Pattern
The chosen design pattern for this project is **Dependency Injection**. Since dependencies can change on the time, and it's a possibility that the logic should be changed because of that dependency change, I decided to adopt this design pattern using the power of `protocols`. As far as data sources adopt the protocol defined to handle that data, it won't mind how or what library is used to retrieve/save the data. DataServices should be given the needed data sources in the entry point of the app (Normally in `AppDelegate`), then they will be ready to return the data Presenters ask for.

### Problems found
1) Pull up to fetch more content. At this moment the project can load only ten items in the home search. In order to load more, an implementation to increase the limit of the query should be added.  
State: Pending

2) Pull down to refresh. Reload table by pulling the scroll down.  
State: Done (Home)

2) HTML. The summary text that is coming in recipe details is HTML. `NSAttributedString` has the capability to render HTML based on given rules.  
State: Done

3) Links. Once HTML is rendered properly, some `delegates` should be created to open links coming in the summary text.  
State: Done

3) Load items offline: Since we are persisting recipes at home and their details, the app should be able to load them offline.  
State: Done

4) Unit Testing.  
State: Pending
