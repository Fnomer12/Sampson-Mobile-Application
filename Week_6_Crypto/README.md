# Week 6 – Public API Consumer App

## INFT 425 – Mobile Application Development

This Flutter application fetches live cryptocurrency data from the CoinGecko public API and displays it in real-time using the MVVM architecture pattern.

---

## Features

- Live API data fetching (HTTP GET)
- Proper URI construction using Uri.https()
- Status code validation
- Error handling (Network, HTTP, Parsing)
- Pull-to-refresh functionality
- Animated price updates (live ticker effect)
- MVVM architecture using Provider

---

## API Used

CoinGecko Public API  
https://api.coingecko.com/api/v3/coins/markets

---

## Architecture

- Model: Coin model with fromJson()
- Service: ApiService for HTTP requests
- ViewModel: CoinViewModel with state management
- View: HomePage UI

---

## Author

Sampson Adjei  
INFT 425 – Week 6 Mini Project
