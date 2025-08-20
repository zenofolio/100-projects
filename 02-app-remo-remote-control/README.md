

# Remo Remote Control – Flutter Smart TV & Device Remote App

**Remo Remote Control** is a modern, modular Flutter application for controlling smart TVs and IoT devices (Samsung, LG, and more) from your phone or tablet. Built for extensibility, maintainability, and real-world use, it’s ideal for portfolios, job applications, and as a reference for scalable Flutter architecture.

**Keywords:** Flutter, Smart TV, Remote Control, IoT, Samsung, LG, Adapter Pattern, Dependency Injection, Modular Architecture, Open Source, Portfolio

---

## Features
- Modular architecture for easy extension and maintenance
- Adapter pattern for supporting multiple TV brands (Samsung, Mock, LG, etc.)
- Device discovery (DLNA) and connection management
- Responsive, accessible, and mobile-friendly UI
- Custom dependency injection (AppScope) for scalable state and service management
- Testable and well-documented codebase

---

## Tech Stack
- **Flutter** (UI framework)
- **Dart** (language)
- **Custom Dependency Injector (AppScope)**
- **WebSocket** (for device communication)
- **DLNA** (for device discovery and communication)
- **Custom Adapter Pattern** (for device extensibility)


---

## Demo & Screenshots
See the app in action:

| ![Smart TV Remote Home](captures/1.png) | ![Device Discovery](captures/2.png) | ![Device Control](captures/5.png) |
|-----------------------------------------|------------------------------------|------------------------------------|

[See all screenshots](captures/README.md)
---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)

### Quick Start
```sh
git clone <this-repo-url>
cd <project-folder>
flutter pub get
flutter run
```

### Run Tests
```sh
flutter test
```

---

## Project Structure

```
lib/
	main.dart                  # App entry point
	application/
		di/                      # Dependency injection (AppScope)
		data/
			adapters/              # Device adapters (Samsung, Mock, etc.)
		modules/
			connect/               # Device discovery, connection, and adapter logic
		navigation/              # Route management
		ui/                      # UI components, screens, themes
```

### Dependency Injection: AppScope
- Located in `lib/application/di/app_scope.dart`.
- Centralizes and manages app-wide dependencies (services, stores, etc.) for testability and loose coupling.

### Connect Module
- Located in `lib/application/modules/connect/`.
- Handles device discovery, connection logic, and state management.
- Uses the adapter pattern: each device/brand implements its own adapter (e.g., SamsungDeviceAdapter, MockDeviceAdapter).
- Adapters encapsulate communication protocols and expose a unified interface for the UI.

### Adapter Implementations
- Each TV/device brand has its own folder in `lib/application/data/adapters/`.
- Adapters extend `DeviceAdapter` and implement required capabilities (remote control, volume, etc.).
- New adapters can be added with minimal changes to the rest of the app.

### UI Layer
- Organized by feature (connect, device, home) and shared components/layouts.
- Follows Flutter best practices for responsive and accessible design.

---

## How to Add a New Device Adapter
1. Create a new folder in `lib/application/data/adapters/<brand>/`.
2. Implement a class extending `DeviceAdapter` and required methods.
3. Add capabilities using provided mixins and capability classes.
4. Update the connect module to recognize and use the new adapter.
5. Add or update UI screens as needed.
6. Document the adapter in `.ai-context/` for future contributors and AI agents.

---

## Development & Testing
- All business logic is testable and adapters can be tested in isolation (see `test/`).
- Use the MockAdapter for integration and UI tests without real devices.
- See `.ai-context/` for project rules, goals, and technical documentation.

---

## Roadmap
- [x] Modularize connect and adapter logic
- [x] Implement Samsung TV adapter
- [x] Responsive UI for device control
- [ ] Device Store for managing connected devices
- [ ] Add more adapters (LG, Sony, etc.)
- [ ] Improve test coverage and add integration tests
- [ ] Enhance documentation and developer onboarding

---

## About .ai-context (zenozaga/contextops)

This project uses the `.ai-context` folder structure inspired by [zenozaga/contextops](https://github.com/zenozaga/zeno-contextops). Learn more about the standard and its benefits in the [official documentation](https://github.com/zenozaga/zeno-contextops).

---

## Contributing
- The project is designed for clarity, extensibility, and real-world maintainability.
- Follows modern Flutter/Dart best practices.
- Open to contributions and feedback.


