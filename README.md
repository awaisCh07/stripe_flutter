![STRIPE-PAYMENT2](https://raw.githubusercontent.com/awaisCh07/stripe_flutter/refs/heads/main/assets/image.webp).
# Stripe Payment Integration

This repository demonstrates how to integrate Stripe payments into a Flutter app. The project shows how to handle payments seamlessly using the Stripe API.

## ✅ Important -
the `.env` file is not included , please use your own secret keys by creating a free [**stripe account**](https://dashboard.stripe.com/register)

`.env` file will be like this - 
```.env
STRIPE_PUBLISH_KEY="pk_test_..."  // Replace this with your own key
STRIPE_SECRET_KEY="sk_test_..."   // Replace this with your own key
```

## 🌐 Important Links
- https://dashboard.stripe.com/register
- https://docs.stripe.com/api/payment_intents
- https://docs.page/flutter-stripe/flutter_stripe

## Features

- Stripe Payment Integration
- Secure handling of payments
- Simple and intuitive user interface
- Easy to implement and customize

## Tech Stack

- **Flutter**: Cross-platform mobile app development framework
- **Stripe API**: Secure payment processing system

## Getting Started

### Prerequisites

Before running the project, ensure you have the following installed:

- Flutter SDK
- Stripe API Keys (Test and Live keys)
- A Stripe account

### Setup Instructions

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/yourusername/stripe-payment-integration.git
    ```
   
2. **Install Dependencies:**
    Navigate to the project folder and install required dependencies.
    ```bash
    flutter pub get
    ```

3. **Set Up Stripe API Keys:**
    - Create an account on [Stripe](https://stripe.com/).
    - Get your API keys from the Stripe Dashboard.
    - Update the API keys in your project (`lib/constants/stripe_keys.dart` or wherever you handle your Stripe configuration).

4. **Run the App:**
    ```bash
    flutter run
    ```

## Usage

1. **Payment Flow:**
   - Users can input their card details and proceed with payments.
   - The app securely sends payment details to the Stripe server and processes the transaction.
   
2. **Testing:**
   - Use Stripe’s [test card numbers](https://stripe.com/docs/testing) for testing payments in development mode.


## Contributing

Contributions are welcome! Feel free to open a pull request or submit issues for bug fixes or feature requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Special thanks to the Stripe documentation and community for providing great resources for this integration.


## 👩‍💻 Authors -
- [Snehasis4321](https://github.com/Snehasis4321)
