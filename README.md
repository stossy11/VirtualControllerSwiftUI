# Virtual Controller SwiftUI

This is basically just a Virtual Controller view for SwiftUI

## How to install 

### Swift Package Manager SPM

Add this repository's URL https://github.com/stossy11/VirtualControllerSwiftUI

## How to use

Basic Use Case:
```
import VirtualControllerSwiftUI

struct ContentView: View {
    @ObservedObject var virtualController: VirtualController = VirtualController.shared
    
    var body: some View {
        ZStack {
            
            Text("Insert Your View Here:")
            
            ControllerView()
        }
        .onAppear {
            virtualController.buttonPressed = { button in
                if button == .A {
                    print("Button A Pressed")
                }
            }
            virtualController.buttonReleased = { button in
                if button == .A {
                    print("Button A Released")
                }
            }
            virtualController.thumbstickMoved = { thumbstick, position in
                if thumbstick == .left {
                    print("Left Thumbstick Moved to x: \(position.x), y: \(position.y)")
                }
                
                if thumbstick == .right {
                    print("Right Thumbstick Moved to x: \(position.x), y: \(position.y)")
                }
            }
        }
    }
}
```


for `VirtualController.shared.buttonPressed = { button` button would be this enum below:
```
public enum VirtualControllerButton: Int {
    case B
    case A
    case Y
    case X
    case back
    case guide
    case start
    case leftStick
    case rightStick
    case leftShoulder
    case rightShoulder
    case dPadUp
    case dPadDown
    case dPadLeft
    case dPadRight
    case leftTrigger
    case rightTrigger
}

// Joystick enum
public enum ThumbstickType: Int {
    case left
    case right
}

```

VirtualController.shared includes 
```
class VirtualController {
    // activeButtons is which buttons are being pressed at one time
    @Published var activeButtons: Set<VirtualControllerButton> = []
    // thumbstickPositions is the position where each Thumbstick is
    @Published var thumbstickPositions: [ThumbstickType: CGPoint] = [:]
    
    // buttonPressed is when a player presses down a button
    var buttonPressed: ((VirtualControllerButton) -> Void)?
    // buttonReleased is when a player releases a button
    var buttonReleased: ((VirtualControllerButton) -> Void)?
    // thumbstickMoved is when a player moves a Thumbstick.
    var thumbstickMoved: ((ThumbstickType, CGPoint) -> Void)?
}
```


# Credits

- michael94ellis - [SwiftUIJoystick](https://github.com/michael94ellis/SwiftUIJoystick) - Code for JoyStick
- Me - Rest of the Code
