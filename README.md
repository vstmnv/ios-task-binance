# Binance Task

A small iOS app, built as an interview task, that displays live crypto market data from the public Binance API.

## Features

- Market list - shows all symbols from the Binance 24h ticker endpoint
- Live search - filter the list by symbol
- Pull to refresh - reload the latest data
- Market details - tap any symbol for full details

## Architecture

The app is built with **Swift**, **UIKit**, **async/await** and **MVVM**.

```
Binance Task/
├── Core/
│   ├── Services/
│   │   ├── APIService
│   │   ├── Endpoint
│   │   ├── Endpoints/
│   │   ├── Models/
│   │   ├── APIError
│   │   └── HTTPMethod
│   └── Utilities/
├── Features/
│   ├── MarketList/
│   └── MarketDetails/
└── Resources/
```

## Author

Created by **Vesela Stamenova** as an iOS interview task.
