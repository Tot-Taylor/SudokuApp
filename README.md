# SudokuApp

Initial scaffold for a SwiftUI + MVVM iOS Sudoku application.

## Structure

- `App/`: app entry points and dependency container.
- `Models/`: Codable domain and persistence models.
- `Services/`: Sudoku rules, solver, generation, stats, and settings persistence interfaces.
- `Views/`: SwiftUI screens and view models.
- `Persistence/`: protocol-backed persistence gateway and in-memory bootstrap.
- `Utilities/`: formatting and shared constants.
- `Tests/`: starter XCTest coverage for core rule behavior.

## Notes

This initial push focuses on a functional architecture skeleton and core game-domain logic designed for rapid iteration.

## Run in Xcode (iPhone Simulator)

1. Open `SudokuApp.xcodeproj` in Xcode.
2. Select the shared **SudokuApp** scheme.
3. Choose an iPhone Simulator device (for example, *iPhone 16*).
4. Press **Run**.

This repository now includes a native iOS Xcode project so the app can be launched directly in Simulator after cloning.
