# SMS Manager

A simple command-line tool for managing contacts and sending SMS messages through Termux.

## Created by Pejman Morovat

## Overview

SMS Manager is a Bash script that allows you to search through your contacts and send SMS messages directly from the Termux terminal on Android. The application provides a clean interface with colored output for better user experience.

## Prerequisites

- [Termux](https://termux.com/) installed on your Android device
- The following packages installed in Termux:
  - `jq` (for JSON processing)
  `termux-api` (for SMS functionality)

## Installation
- `git clone https://github.com/pejmanmorovat/SMS.git`

1. Save the script to a file named `sms-manager.sh`
2. Make it executable:
   ```bash
   chmod +x sms-manager.sh
   ```
3. Create an empty `contacts.txt` file or one with your contacts in JSON format:
   ```json
   [
     {"name": "John Doe", "number": "+1234567890"},
     {"name": "Jane Smith", "number": "9876543210"}
   ]
   ```

## Usage

Run the script from Termux:

```bash
./sms-manager.sh
```

### Features

- **Contact Search**: Search your contacts by name (case-insensitive)
- **SMS Sending**: Send SMS messages to selected contacts
- **Clean Interface**: Color-coded terminal UI for better readability

### Contact Management

The contacts are stored in a file named `contacts.txt` in JSON format. Each entry should have the following structure:

```json
{"name": "Contact Name", "number": "Phone Number"}
```

## How to Use

1. When prompted, enter a name or part of a name to search for in your contacts
2. Select a contact from the search results by entering their number
3. Type your message when prompted
4. The program will send the SMS and notify you of success or failure

Enter `exit` at the search prompt to quit the application.

## Troubleshooting

- If you see "Error: jq is not installed", run:
  ```bash
  pkg install jq
  ```

- If you see "Error: termux-api is not installed", run:
  ```bash
  pkg install termux-api
  ```

- Make sure you've granted SMS permissions to Termux on your Android device

## Notes

- Phone numbers are automatically cleaned of non-numeric characters (except the + symbol)
- The script requires a valid JSON file for contacts
