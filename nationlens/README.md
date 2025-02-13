# NationLens - Country Information App

NationLens is a feature-rich mobile application built with Flutter that provides detailed information about countries worldwide. It offers a clean, intuitive interface with powerful filtering and search capabilities.

## Features

### Core Features
- **Country List:** Browse all countries in an alphabetically grouped list.
- **Detailed Country Information:**
  - Official name
  - Capital city
  - Population
  - Official language
  - Currency
  - Time zones
  - Continent
  - Flag images
  - Coat of arms
- **Search Functionality:** Find countries by name.
- **Filtering Options:**
  - Filter by continent
  - Filter by time zone
- **Theme Support:**
  - Light and dark mode
- **Responsive Design:** Optimized for all screen sizes.

### Advanced Features
- **Image Carousel:** Swipeable gallery for flags and coat of arms.
- **Data Visualization:**
  - Population formatted for readability
  - Time zones displayed in a user-friendly format
- **Caching:** Efficient image and data caching for better performance.
- **Error Handling:** Graceful handling of missing data and network issues.

## Setup Instructions

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio/VSCode with Flutter plugin

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/aderemi-alo/nationlens.git
   cd nationlens
2. **Install dependencies**
   ```bash
   flutter pub get
3. **Run the app**
   ```bash
   flutter run

## Usage Guide
### Home Screen
1. **Search**: Use the sarch bar to find countries by name
2. **Filters**:
    - Tap the filter button to open filter options
    - Select continents and time zones
    - Use "Reset" to clear selections
    - "Show Results" to see results
3. **Country List**:
    - Scroll through alphabetically grouped countries
    - Tap any country to view details

### Country Detail Screen
1. **Image Carousel**: Swipe left/right to view flag and coat of arms.
2. **Information Sections**:
    - View detailed country information
    - Time zones displayed in comma-separated format

### Settings
1. **Theme Selection**:
    - Tap the theme icon in the app bar
    - Choose between light/dark mode or system default