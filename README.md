# Name Generator App

A Flutter application that generates random word pairs and allows users to save their favorites. The app features a clean Material Design interface and supports both mobile and desktop layouts.

## Features

- Random word pair generation
- Navigate through previous and next word pairs
- Save favorite word pairs
- Persistent storage of favorites
- Responsive design that adapts to different screen sizes
- Bottom navigation for mobile and navigation rail for desktop

## Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart](https://dart.dev/get-dart) (latest stable version)
- An IDE (VS Code, Android Studio, or IntelliJ)

## Dependencies

This project relies on the following packages:
```yaml
dependencies:
  flutter:
    sdk: flutter
  english_words: ^4.0.0
  provider: ^6.0.0
  shared_preferences: ^2.0.0

dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

## Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
```

2. Navigate to the project directory:
```bash
cd name_generator
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## App Structure

The app consists of several key components:

- `MyApp`: The root widget that sets up the MaterialApp and theme
- `MyAppState`: State management class using Provider
- `MyHomePage`: Main page with responsive layout
- `GenerateNamePage`: Page for generating and viewing word pairs
- `FavoritesPage`: Page for viewing and managing saved favorites
- `BigCard`: Widget for displaying the current word pair

## Features in Detail

### Word Pair Generation
- Generates random word pairs using the english_words package
- Allows navigation through previous and next pairs
- Displays pairs in a visually appealing card format

### Favorites Management
- Save favorite word pairs with a like button
- View all favorites in a dedicated page
- Remove favorites with a delete button
- Persistent storage using SharedPreferences

### Responsive Design
- Automatically adapts layout based on screen width
- Uses NavigationRail for larger screens (>= 500px)
- Uses BottomNavigationBar for smaller screens (< 500px)

## Theme Customization

The app uses Material 3 theming with a custom color scheme. To modify the theme:

1. Locate the following code in `MyApp`:
```dart
theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 34, 240)
  ),
)
```

2. Modify the `seedColor` to change the app's color scheme

## Building for Production

To build the release version of the app:

For Android:
```bash
flutter build apk --release
```

For iOS:
```bash
flutter build ios --release
```

The compiled application will be available in the `build` directory.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built with Flutter
- Uses the english_words package for word pair generation
- Provider package for state management
- SharedPreferences for persistent storage

## Author

### Ajay Krishna D
