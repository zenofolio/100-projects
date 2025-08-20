# Project Rules

- Use Dart and Flutter best practices.
- Follow the existing folder structure under `lib/` and `screens/`.
- Use Provider or Riverpod for state management (if present).
- All UI code must be responsive and accessible.
- Error handling: Use try/catch for async operations and show user-friendly error messages.
- Write unit/widget tests for new features in `test/`.

---

## Adapter Implementation Rules

To create a new adapter (see `.ai-context/goals/adapter_creation.md` for step-by-step goals):

1. Create a new folder in `lib/application/data/adapters/<adapter_name>/`.
2. Implement a class extending `DeviceAdapter` and all required methods.
3. Add all relevant capabilities using the provided mixins and capability classes.
4. Implement communication helpers if needed (e.g., sockets, HTTP clients).
5. Add a static `factory` method for easy instantiation.
6. Write unit and widget tests in `test/`.
7. Document the adapter in `.ai-context/knowledge/`.
