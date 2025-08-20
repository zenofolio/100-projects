# Task: Propose Refactors and Optimizations for lib/

## Description
Analyze all code under the `lib/` directory and propose refactorings or optimizations, but only if they are truly necessary. The agent should:

- Review code structure, naming, and modularity.
- Identify duplicated logic, dead code, or anti-patterns.
- Suggest improvements for performance, readability, or maintainability.
- Only propose changes that add real value—avoid unnecessary refactors.
- Summarize findings and recommendations in a clear, actionable format.

## Steps
1. Recursively scan all Dart files in `lib/`.
2. For each file/module:
   - Check for code smells, large functions, or unclear responsibilities.
   - Look for opportunities to extract widgets, helpers, or services.
   - Identify any outdated patterns or inefficient code.
3. Collect and group suggestions by file/module.
4. Output a summary report with:
   - The reason for each suggestion.
   - The expected benefit (e.g., performance, clarity, testability).
   - Example code or pseudocode if helpful.

## Acceptance Criteria
- The report only includes necessary and valuable suggestions.
- No unnecessary or cosmetic refactors are proposed.
- The output is actionable and easy to follow for developers.
