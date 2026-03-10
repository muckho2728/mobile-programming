# Map Demo

This is a Flutter application demonstrating Google Maps integration and route finding using OpenRouteService.

## Setup Instructions

To run this project securely, API keys have been hidden from the repository. You must provide your own API keys.

### 1. OpenRouteService Key
1. Get a free API key from [OpenRouteService](https://openrouteservice.org/).
2. In the root of this project, you will find a file named `.env.example`.
3. Create a new file named `.env` in the same directory.
4. Copy the contents of `.env.example` into `.env` and replace `YOUR_OPENROUTE_SERVICE_API_KEY_HERE` with your actual API key.

### 2. Google Maps API Key
1. Get a Maps SDK API key from [Google Cloud Console](https://console.cloud.google.com/).
2. Open the file `android/local.properties` (create it if it doesn't exist).
3. Add the following line at the bottom, replacing the text with your actual key:
   ```properties
   MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY_HERE
   ```

After completing these setup steps, you can run the app normally using:
```bash
flutter run
```
