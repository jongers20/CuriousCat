# CuriousCat iOS App

CuriousCat is a simple light weight(no third party integration) iOS app that presents users with a random image of a cat along with a random cat fact. 

The home screen doesn't include a UIButton for navigation. Instead, the app guides the user through an onboarding process, explaining where to tap to generate a new random image and fact, and how to navigate back to the previous ones. This onboarding appears only the first time the user opens the app.

The app fetches 10 images and their associated fact per request. When the user reaches the last image, tapping for a new one will trigger another request for 10 additional images and fact. The array holding the response will store only the most recent 10 entries, as the app allows navigation back through the images, but we aim to avoid a lengthy data index for the user.

Implemenation:
* MVVM Design
* Combine Framework: For binding
* Swift's async/await syntax to handle API requests efficiently
* Shimmer: A UIView that acts as a placeholder to indicate that the image is still loading
* Dependency Injection
* Generics
* Storyboard
* Stub
* Abstraction
* Single Responsbility



