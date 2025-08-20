# Remo Remote Control – Developer Context & Documentation

## Project Overview
Remo Remote Control is a modular Flutter application designed to control a variety of smart TVs and devices from a single, unified interface. The project is architected for extensibility, maintainability, and ease of integration with new device types.

This documentation is intended for developers, contributors, and potential employers to understand the structure, conventions, and future direction of the project.

---

## Architecture & Key Modules

- **Modular Structure:**
	- All core features are organized under `lib/application/` and `lib/ui/`.
	- Each device or feature is encapsulated in its own module for separation of concerns and scalability.

- **Connect Module (`lib/application/modules/connect/`):**
	- Handles device discovery, connection logic, and state management for connecting to TVs/devices.
	- Uses mixins for capabilities, status, and device-specific logic.
	- Easily extendable to support new connection protocols.

- **Adapter Implementations (`lib/application/data/adapters/`):**
	- Each TV/device brand (e.g., Samsung) has its own adapter folder.
	- Adapters encapsulate communication protocols, constants, and device-specific models.
	- New adapters can be added with minimal changes to the rest of the app.

- **UI Layer (`lib/ui/`):**
	- Organized by feature (e.g., connect, device, home) and shared components/layouts.
	- Follows Flutter best practices for responsive and accessible design.

- **Navigation & DI:**
	- Navigation is managed in `lib/application/navigation/`.
	- Dependency injection setup is in `lib/application/di/`.

---

## Extending the App

- To add support for a new device/brand:
	1. Create a new adapter in `lib/application/data/adapters/`.
	2. Implement required models, constants, and communication logic.
	3. Update the connect module to recognize and use the new adapter.
	4. Add or update UI screens as needed.

---

## Roadmap

- [x] Modularize connect and adapter logic
- [x] Implement Samsung TV adapter
- [x] Responsive UI for device control
- [ ] **Device Store:**
	- Centralized store for managing connected devices, their states, and preferences
	- Persistence for device configurations
	- UI for adding/removing devices
- [ ] Add more adapters (LG, Sony, etc.)
- [ ] Improve test coverage and add integration tests
- [ ] Enhance documentation and developer onboarding

---

## For Contributors & Employers

- The project is designed for clarity, extensibility, and real-world maintainability.
- Follows modern Flutter/Dart best practices.
- Open to contributions and feedback.

See `.ai-context/` for rules, templates, and technical notes to help you get started quickly.
