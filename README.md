# 🍕 DeliveryApp's main screen

#### This project is an implementation of a delivery app's main screen with food categories, your city selector, and ad banners. I've built it to learn and refresh my knowledge of the VIPER pattern. The app focuses on both responsiveness and implementation of business logic. The project has a two-stage caching system implemented to store and later reuse images and menu items. Menu item cells have a shimmer effect loading state, and all the networking services and caching services are covered by unit testing.
#### A tutorial on how to implement this app is in development.

## 📦 Technologies:

* `UIKit`
* `VIPER`
* `CoreData`
* `File Manager`
* `Unit Testing`
* `Networking`
* [`Spoonacular API`](https://spoonacular.com/food-api)

## 🚦 Running the Project

To run the project on your device, follow these steps:

* Clone the repository.
* This project doesn't use any third-party libraries, so just build it and it should work.

## 📸 - Video demonstration of the app

#### On app launch the shimmer loading state is shown, indicating that the data is being downloaded. The app performs a search for the data first in the quick NSCache and then in CoreData, if the data is not on the device, it makes a URL request fetching data from an API. Once the data is fetched the TableView's cells are reloaded. 

https://github.com/AisultanAskarov/delivery-app-main-screen/assets/36818367/650b40c1-5534-4b62-b149-912df78b2ab5

#### I've also implemented a sticky header that contains 2 views. The first one is an ad banners collection, and the second is food-type filters. The challenge was to only make the food-type filters stick to the top while scrolling. The shadow is also applied to the food-type filters header after reaching a certain scrolling point.

https://github.com/AisultanAskarov/delivery-app-main-screen/assets/36818367/aa0c1c35-5abd-49fd-a359-77f00908e478

#### When a food-type filter is picked it scrolls to the top item of the selected section.

https://github.com/AisultanAskarov/delivery-app-main-screen/assets/36818367/32e99081-8b3a-45cc-9fcf-24c6dee4a13b

#### A Menu UI element was used to implement a city of delivery picker. The data is stored in the UserDefaults because it is not something that would be over-written often in the real app but would be retrieved frequently.

https://github.com/AisultanAskarov/delivery-app-main-screen/assets/36818367/ca5f4276-85da-444e-9d42-ea81dcfd3b29

