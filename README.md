# FindingFalcone

*https://github.com/staticVoidMan/FindingFalcone*  
*https://www.geektrust.in/coding-problem/frontend/space*

##### Running Tests:

To run Swift Package & iOS tests from terminal, run the following command:
- `./run.sh`

Optionally, you can run only the iOS Tests via `Fastlane`:
- `cd FindingFalcone-iOS && fastlane test`

##### Viewing Project Code:
- Swift Package located at `FindingFalcone\Package.swift` 
- iOS Project  located at `FindingFalcone-iOS\FindingFalcone-iOS.xcodeproj`

---

Considerations:
- Device Support for both iPhone & iPad
- UI setup programmatically via AutoLayout
- **MVVM** to separate the business logic
- Flow **Coordinators** to separate navigation logic
- **Swift Packages** for reusability & dependency management:
  - `FindingFalconeCore` target - Contains the core functionality & protocols
  - `FindingFalconeAPI` target - Extends `FindingFalconeCore` to add the API layer.
- **Unit test** cases for both the Swift Package & the iOS codebase
- Reusable components in iOS codebase: `StatusLight` & `ItemPickerVC`
- **Localisation** done to support 2 languages
- Adequate documentation

---
##### Final:

<img src="https://raw.githubusercontent.com/staticVoidMan/FindingFalcone/master/.github/images/recording.gif" width="320">

---

*See `problem.pdf` for complete details.*  
*See `api.postman.json` to load the API collection in Postman.*
