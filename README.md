# Muday - Ethiopian Expense Tracker

<div align="center">

<!-- ![Muday Logo](assets/logo.png) -->

[![Build Status](https://github.com/yourusername/muday/workflows/Build/badge.svg)](https://github.com/yourusername/muday/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![API Level](https://img.shields.io/badge/API-24%2B-brightgreen.svg)](https://android-arsenal.com/api?level=24)

</div>

Muday is a comprehensive expense tracking application designed specifically for Ethiopian users. It automatically tracks your expenses by parsing SMS notifications from major Ethiopian banks and mobile money services, including Telebirr, Commercial Bank of Ethiopia (CBE), and Bank of Abyssinia.

## Features

### 🔄 Automatic Transaction Tracking
- Real-time SMS parsing for automatic expense tracking
- Support for multiple Ethiopian banks and payment services:
  - Telebirr
  - Commercial Bank of Ethiopia (CBE)
  - Bank of Abyssinia
  - More banks coming soon
- Automatic parsing of transaction details including:
  - Transaction amount
  - Balance
  - Reference numbers
  - Sender/receiver information
  - Commission and VAT charges

### 📊 Smart Analytics
- Detailed transaction analytics and visualization
- AI-powered expense categorization using Google's Gemini AI
- Custom categorization options
- Flexible date range filtering:
  - Daily
  - Weekly
  - Monthly
  - Yearly
  - Custom date ranges

### 💰 Budget Management
- Set and track budgets for different time periods
- Budget alerts and notifications
- Category-based budget allocation

### ☁️ Cloud Features
- Secure cloud backup with Firebase
- Cross-device synchronization
- Data export in multiple formats:
  - CSV
  - JSON
  - PDF reports
- Share transactions with other Muday users

## Getting Started

### Prerequisites
- VS Code or Android Studio
- Android SDK 24 or higher
- Firebase account for cloud features
- Google Cloud account for AI features

### Installation
1. Clone the repository:
```bash
git clone https://github.com/chapimenge3/Muday.git
```

2. Open the project in Android Studio or VS Code

3. Create a Firebase project and add the `google-services.json` file to the app directory(NOT IMPLEMENTED SKIP this)

4. Configure your Google Cloud credentials for Gemini AI integration(NOT IMPLEMENTED SKIP this)

5. Build and run the project

### Configuration
1. Enable SMS permissions when prompted
2. Set up your preferred banks and payment services
3. Configure cloud backup settings (optional)
4. Set up your budget preferences

## Architecture (TO BE IMPLEMENTED)
Muday follows the MVVM architecture pattern and is built with modern Android development practices:

- **UI Layer**: Jetpack Compose
- **Business Logic**: ViewModel + Use Cases
- **Data Layer**: Repository Pattern
- **Local Storage**: Room Database
- **Cloud Storage**: Firebase
- **Dependencies**: Hilt for dependency injection

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Development Setup
1. Fork the repository
2. Create a new branch for your feature
3. Implement your changes
4. Submit a pull request

## Privacy & Security

Muday takes your financial privacy seriously:
- All sensitive data is encrypted
- SMS parsing happens locally on your device
- Cloud sync is optional and secured with Firebase Authentication
- No sensitive data is shared without explicit user consent

## Support

For support, please:
- Check our [Documentation](docs/README.md)
- Visit our [Issues](https://github.com/chapimenge3/muday/issues) page
- Join our [Telegram Community](https://t.me/chapidevtalks)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- Thanks to all contributors and users
- Special thanks to the Ethiopian developer community
- Icons and graphics from [Material Design Icons](https://material.io/icons)

---

<div align="center">
Made with ❤️ in Ethiopia
</div>