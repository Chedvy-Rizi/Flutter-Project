# 🍳 Recipe Hub – Flutter Recipe Application

A modern, fast, and visually appealing Flutter application that allows users to explore and discover culinary recipes from around the world. Powered by **TheMealDB API**, users can search for any ingredient or dish, view structured lists of matching recipes, and dive into full-screen interactive detail pages featuring rich imagery, comprehensive ingredient checklists, and clear step-by-step preparation instructions.

---

## ✨ Features

- 🔍 **Real-Time Recipe Search:** Quickly lookup recipes using names or core ingredients (e.g., *chicken*, *pasta*, *cake*).
- 📱 **Clean & Appetizing UI:** Designed with an elegant, modern amber/orange theme that elevates the food-discovery experience.
- 🗺️ **Full-Screen Seamless Navigation:** Tap any card to transition into an intensive recipe view with an embedded back navigation system.
- 🛒 **Dynamic Ingredient Collection:** Automatically extracts and maps scattered structural API keys into a structured, unified shopping checklist.
- 🏷️ **Categorized Insights:** View contextual recipe chips indicating cooking categories and geographical origins (e.g., *Italian*, *Dessert*).
- ⚡ **Asynchronous State Management:** Implements fluid, responsive UI transitions with built-in loading wheels and graceful error catchers.

---

## 🛠️ Technology Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel Stable, Material 3 Enabled)
- **Language:** [Dart](https://dart.dev/)
- **Networking:** `http` package for robust REST API orchestration.
- **Data Source:** [TheMealDB REST API](https://www.themealdb.com/)

---

## 🚀 How to Run the Project Locally

Since this app is fully optimized for web-browser simulation without the heavy dependency of Android Studio or local emulators, you can boot it up in seconds!

1. Clone the repository: `git clone https://github.com/tamifalk/ProjectFlutter.git`
2. Navigate into the project directory: `cd api_app`
3. Fetch dependencies: `flutter pub get`
4. Run on Chrome (Mobile Emulation mode recommended): `flutter run -d chrome`

---

## 📂 Project Architecture

The core implementation is safely modularized within standard Flutter development targets:
- `lib/main.dart`: Contains the root entry point, application theme presets (`ThemeData`), stateful landing search controllers, asynchronous HTTP network blocks, and the full-screen interactive detail screen context.

---

## 💡 API Usage Overview

The app communicates directly with TheMealDB endpoint structure:
- **Search Endpoint:** `https://www.themealdb.com/api/json/v1/1/search.php?s={query}`
- **Response Layout Parsing:**
  ```json
  {
    "meals": [
      {
        "idMeal": "52772",
        "strMeal": "Teriyaki Chicken Casserole",
        "strCategory": "Chicken",
        "strArea": "Japanese",
        "strInstructions": "...",
        "strMealThumb": "https://..."
      }
    ]
  }