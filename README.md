# Potato Disease Detection Application

This repository contains the code for a mobile application designed to detect potato plant diseases. Users can select an image of a potato plant from their gallery or capture a new one, and the app will predict if the plant is diseased. This solution aims to assist farmers and agricultural specialists with early disease detection using a deep learning model integrated into a Flutter app.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Data Storage](#data-storage)
- [APIs and Packages Used](#apis-and-packages-used)
- [Challenges and Solutions](#challenges-and-solutions)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

---

### Overview
Potato plants are vulnerable to diseases that affect crop yield and quality. The Potato Disease Detection app provides a simple, user-friendly tool for identifying common diseases in potato plants using machine learning. It leverages a TensorFlow Lite model trained on Kaggle data, integrated into Flutter for mobile compatibility on both Android and iOS platforms.

### Features
- **Image-Based Disease Detection:** Capture or select a potato plant image to get instant disease diagnosis.
- **User Profile Management:** Firebase Authentication for user sign-in/sign-up, with personalized user data fetched from Firestore.
- **Cloud Storage:** Firebase Storage for storing images, with Firestore linking for easy data access.
- **Responsive UI:** Flutter ensures the app layout adapts to various screen sizes on both phones and tablets.

### Data Storage
Firebase was chosen as the backend solution for this app:
- **Firebase Authentication:** Manages user sign-ins and sign-ups.
- **Firebase Firestore:** Stores user profile information (name, profile image).
- **Firebase Storage:** Stores images captured or selected by users, with URLs linked in Firestore.

*Justification:* Firebase's seamless integration with Flutter and support for real-time data synchronization made it an ideal choice for handling user data and image storage.

### APIs and Packages Used
- **Firebase:** 
  - Firebase Authentication for user accounts
  - Firebase Firestore for user data
  - Firebase Storage for image storage
- **tflite_flutter:** TensorFlow Lite model integration for image classification.
- **image_picker:** Allows users to select or capture images.
- **Image Compression:** Reduces image size to optimize upload time to Firebase Storage.

### Challenges and Solutions
- **Model Integration Issues:** The `tflite` package was recently updated to `tflite_flutter`, causing compatibility issues. Updating dependencies and refactoring code solved this issue.
- **Image Storage in Firebase:** Initially, storing images and generating URLs was challenging. Adjusting Firebase Storage rules and data handling methods resolved this.
- **Slow Image Uploads:** Large images caused long upload times. Compressing images before upload solved this issue.
- **Image Format Conversion:** The model required images in a specific format. Preprocessing steps, including resizing and normalizing images, were added to ensure compatibility.

### Screenshots

![login](https://github.com/user-attachments/assets/d9814474-eec3-4258-9398-517bdffd26dd)
![signup](https://github.com/user-attachments/assets/83541cc9-13f4-4289-aaf8-be649de763e1)
![home_screen](https://github.com/user-attachments/assets/bf123cc9-8422-4c8d-81e3-e734af5c6183)
![profile](https://github.com/user-attachments/assets/6ac725e9-18cc-4588-a6d0-8cd8332c230d)
![prediction](https://github.com/user-attachments/assets/a5786803-d49c-4df8-af55-452610087aa5)


### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/potato-disease-detection.git
   ```
2. Navigate to the project directory:
   ```bash
   cd potato-disease-detection
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Set up Firebase for your app (instructions in [Firebase Docs](https://firebase.google.com/docs/flutter/setup)) and add the `google-services.json` file for Android or `GoogleService-Info.plist` for iOS.
5. Run the app:
   ```bash
   flutter run
   ```

### Contributing
Feel free to contribute by submitting a pull request or opening an issue. Make sure your code follows the best practices and is thoroughly tested.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

