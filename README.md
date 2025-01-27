Project Title
Health tracking APP 
Description:
The app's frontend provides a user-friendly interface with four main sections: Vitals, Diet, Exercise, and Women’s Health. Each section is designed for easy navigation, allowing users to track their daily routines effortlessly. The clean and interactive design ensures a seamless experience, making health management simple and engaging.

Setup Instructions: Step-by-step guide to run the application locally
To fetch all the necessary dependencies:
flutter pub get
Run the app:
flutter run


Dependencies: List of all Flutter packages used and their purposes.
Dependencies:
  flutter:
  sdk: flutter
  http: ^1.3.0
  provider: ^6.1.2
  health: ^12.0.1
  intl: ^0.20.2
  flutter_svg: ^2.0.17
  google_fonts: ^6.2.1
  cupertino_icons: ^1.0.6
  table_calendar: ^3.2.0
dev_dependencies:
  flutter_test:
    sdk: flutter
    flutter_lints: ^3.0.0
assets:
    - assets/images/vital.png
    - assets/images/diet.png
    - assets/images/exercise.png
    - assets/images/women.png
    - assets/icons/  
    flutter: uses-material-design: true


The core framework for building Flutter applications, providing a wide range of widgets and tools to create cross-platform UIs.

http:
A package for making HTTP requests. Used for fetching and sending data to web APIs.

provider:
A state management solution that simplifies managing application state and updating the UI in response to data changes.

health:
A plugin to access health-related data from native platforms (Google Fit or Apple Health). It enables tracking user health metrics.

intl:
Used for internationalization and localization, including formatting numbers, dates, and other locale-specific values.

flutter_svg:
Enables rendering SVG (Scalable Vector Graphics) files in Flutter applications, which are useful for high-quality, scalable visuals.

cupertino_icons:
Includes a library of iOS-style icons to give the application a native Cupertino (iOS) look and feel.

table_calendar:
A feature-rich calendar widget that can be customized to display events or schedules, essential for tracking routines or appointments.

flutter_test:
Provides tools for writing unit tests, widget tests, and integration tests to ensure the app's correctness and reliability.

flutter_lints :
Supplies a set of recommended lints to help maintain consistent and clean coding practices.



Features: Highlight key features of the application.
User-Friendly Design: Clean interface with seamless navigation.
Four Key Sections: Vitals, Diet, Exercise, and Women’s Health for holistic health tracking.
Daily Tracking: Easily monitor routines and progress.
Interactive UI: Engaging design with SVG graphics and custom fonts.


Future Enhancements:
Reminders: Add notifications for workouts, meal timings, or medication schedules.
Social Features: Allow users to share progress and connect with a community.
Personalization: Enable AI-based suggestions for diet, exercise, and health tips.
