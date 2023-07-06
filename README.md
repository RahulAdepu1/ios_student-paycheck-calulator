# IOS_StudPaycheckCal

## Introduction
IOS_StudPaycheckCal is a student paycheck calculator app designed for ISU (Illinois State University) students. The app allows users to estimate their potential annual salary, perform image recognition on a paycheck to calculate the percentage of taxes deducted and view salary breakdowns in a chart format. The app also provides options for data persistence using Core Data and cloud storage by logging into a user account.

## Features
- Estimate potential annual salary: Users can input their hourly/monthly wage, weekly working hours, and more details to calculate an estimated annual salary.
- Image recognition for tax calculation: The app utilizes image recognition technology to analyze a paycheck and calculate the percentage of taxes deducted.
- Salary breakdown chart: Users can view a visual representation of their salary breakdown, including after-tax salary, state tax, and federal tax.
- Data persistence: The app supports data persistence using Core Data, allowing users to save and retrieve their paycheck data on their device.
- Cloud storage: Users can log into their account to save their paycheck data in the cloud for convenient access across multiple devices.

## Frameworks and Technologies
The IOS_StudPaycheckCal project utilizes the following frameworks and technologies:
- SwiftUI: The UIKit framework provides essential tools and classes for constructing the user interface and handling user interactions.
- Core Data: Core Data is a framework for object-relational mapping and provides data persistence for iOS and macOS applications.
- Image Recognition: The app utilizes image recognition technology to extract information from paycheck images for tax calculation.
- Charts: The Charts framework is used to generate visual charts for displaying salary breakdowns in a graphical format.
- Firebase: Firebase is used to save the data associated with the user in the Firestore database which is in the cloud.

## Installation
To run the IOS_StudPaycheckCal app locally, follow these steps:

1. Clone the repository:
   ``` shell
   git clone https://github.com/RahulAdepu1/IOS_StudPaycheckCal.git
   ```
2. Open the project in Xcode.
3. Build and run the app on a simulator or a connected iOS device.

## Usage
Once the app is installed and running, you can use the following features:

- **Estimating Annual Salary**: Enter your hourly/monthly wage, weekly working hours, and a few more details in the designated fields, and tap the "Estimate Salary" button to calculate your potential annual salary.

- **Image Recognition**: Tap the "Capture Image" button to take a photo of your paycheck and enter a few more details in the designated fields. The app will process the image and display the calculated tax percentage.

- **View Salary Breakdown**: The app provides a chart view to visualize the salary breakdown, including after-tax salary, state tax, and federal tax. Use the chart to gain a better understanding of your salary distribution.

- **Data Persistence**: The app allows you to save your paycheck data on your device using Core Data. The saved data can be retrieved and viewed within the app.

- **Cloud Storage**: By logging into your account, you can save your paycheck data in the cloud for easy access across multiple devices.

## Contributing
Contributions to IOS_StudPaycheckCal are welcome! If you encounter any bugs or issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/RahulAdepu1/IOS_StudPaycheckCal/issues) or submit a pull request.
