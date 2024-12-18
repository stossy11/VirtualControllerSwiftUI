// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import CoreMotion

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

public enum ThumbstickType: Int {
    case left
    case right
}


private struct Joystick: View {
    @State var iscool: Bool? = nil
    
    @ObservedObject private var joystickMonitor = JoystickMonitor()
    var dragDiameter: CGFloat {
        var selfs = CGFloat(160)
        if UIDevice.current.systemName.contains("iPadOS") {
            return selfs * 1.2
        }
        return selfs
    }
    private let shape: JoystickShape = .circle
    
    var body: some View {
        VStack{
            JoystickBuilder(
                monitor: self.joystickMonitor,
                width: self.dragDiameter,
                shape: .circle,
                background: {
                    Text("")
                        .hidden()
                },
                foreground: {
                    Circle().fill(Color.gray)
                        .opacity(0.7)
                },
                locksInPlace: false)
            .onReceive(self.joystickMonitor.$xyPoint) { newValue in
                if iscool != nil {
                    VirtualController.shared.moveThumbstick(.right, to: newValue)
                } else {
                    VirtualController.shared.moveThumbstick(.left, to: newValue)
                }
            }
        }
    }
}


public struct ControllerView: View {
    public var body: some View {
        GeometryReader { geometry in
            if geometry.size.height > geometry.size.width && UIDevice.current.userInterfaceIdiom != .pad {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            VStack {
                                ShoulderButtonsViewLeft()
                                ZStack {
                                    Joystick()
                                    DPadView()
                                }
                            }
                            .padding()
                            VStack {
                                ShoulderButtonsViewRight()
                                ZStack {
                                    Joystick(iscool: true) // hope this works
                                    ABXYView()
                                }
                            }
                            .padding()
                        }
                        
                        HStack {
                            ButtonView(button: .start) // Adding the + button
                                .padding(.horizontal, 40)
                            ButtonView(button: .back) // Adding the - button
                                .padding(.horizontal, 40)
                        }
                    }
                    .padding(.bottom, geometry.size.height / 3.2)
                }
            } else {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            VStack {
                                ShoulderButtonsViewLeft()
                                ZStack {
                                    Joystick()
                                    DPadView()
                                }
                            }
                            HStack {
                                VStack {

                                    ButtonView(button: .back) // Adding the + button
                                }
                                Spacer()
                                VStack {
                                    ButtonView(button: .start) // Adding the - button
                                }
                            }
                            VStack {
                                ShoulderButtonsViewRight()
                                ZStack {
                                    Joystick(iscool: true) // hope this work s
                                    ABXYView()
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .padding()
    }
}

struct ShoulderButtonsViewLeft: View {
    @State var width: CGFloat = 160
    @State var height: CGFloat = 20
    var body: some View {
        HStack {
            ButtonView(button: .leftTrigger)
                .padding(.horizontal)
            ButtonView(button: .leftShoulder)
                .padding(.horizontal)
        }
        .frame(width: width, height: height)
        .onAppear() {
            if UIDevice.current.systemName.contains("iPadOS") {
                width *= 1.2
                height *= 1.2
            }
        }
    }
}

struct ShoulderButtonsViewRight: View {
    @State var width: CGFloat = 160
    @State var height: CGFloat = 20
    var body: some View {
        HStack {
            ButtonView(button: .rightShoulder)
                .padding(.horizontal)
            ButtonView(button: .rightTrigger)
                .padding(.horizontal)
        }
        .frame(width: width, height: height)
        .onAppear() {
            if UIDevice.current.systemName.contains("iPadOS") {
                width *= 1.2
                height *= 1.2
            }
        }
    }
}

struct DPadView: View {
    @State var size: CGFloat = 145
    var body: some View {
        VStack {
            ButtonView(button: .dPadUp)
            HStack {
                ButtonView(button: .dPadLeft)
                Spacer(minLength: 20)
                ButtonView(button: .dPadRight)
            }
            ButtonView(button: .dPadDown)
                .padding(.horizontal)
        }
        .frame(width: size, height: size)
        .onAppear() {
            if UIDevice.current.systemName.contains("iPadOS") {
                size *= 1.2
            }
        }
    }
}

struct ABXYView: View {
    @State var size: CGFloat = 145
    var body: some View {
        VStack {
            ButtonView(button: .X)
            HStack {
                ButtonView(button: .Y)
                Spacer(minLength: 20)
                ButtonView(button: .A)
            }
            ButtonView(button: .B)
                .padding(.horizontal)
        }
        .frame(width: size, height: size)
        .onAppear() {
            if UIDevice.current.systemName.contains("iPadOS") {
                size *= 1.2
            }
        }
    }
}

struct ButtonView: View {
    var button: VirtualControllerButton
    @State var width: CGFloat = 45
    @State var height: CGFloat = 45
    @State var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    

    
    var body: some View {
        Image(systemName: buttonText)
            .resizable()
            .frame(width: width, height: height)
            .foregroundColor(colorScheme == .dark ? Color.gray : Color.gray)
            .opacity(isPressed ? 0.4 : 0.7)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !self.isPressed {
                            self.isPressed = true
                            VirtualController.shared.pressButton(button)
                            Haptics.shared.play(.heavy)
                        }
                    }
                    .onEnded { _ in
                        self.isPressed = false
                        VirtualController.shared.releaseButton(button)
                    }
                )
            .onAppear() {
                if button == .leftTrigger || button == .rightTrigger || button == .leftShoulder || button == .rightShoulder {
                    width = 65
                }
            
                
                if button == .back || button == .start || button == .guide {
                    width = 35
                    height = 35
                }
                
                if UIDevice.current.systemName.contains("iPadOS") {
                    width *= 1.2
                    height *= 1.2
                }
            }
    }
    

    
    private var buttonText: String {
        switch button {
        case .A:
            return "a.circle.fill"
        case .B:
            return "b.circle.fill"
        case .X:
            return "x.circle.fill"
        case .Y:
            return "y.circle.fill"
        case .dPadUp:
            return "arrowtriangle.up.circle.fill"
        case .dPadDown:
            return "arrowtriangle.down.circle.fill"
        case .dPadLeft:
            return "arrowtriangle.left.circle.fill"
        case .dPadRight:
            return "arrowtriangle.right.circle.fill"
        case .leftTrigger:
            return"zl.rectangle.roundedtop.fill"
        case .rightTrigger:
            return "zr.rectangle.roundedtop.fill"
        case .leftShoulder:
            return "l.rectangle.roundedbottom.fill"
        case .rightShoulder:
            return "r.rectangle.roundedbottom.fill"
        case .start:
            return "plus.circle.fill" // System symbol for +
        case .back:
            return "minus.circle.fill" // System symbol for -
        case .guide:
            return "house.circle.fill"
        // This should be all the cases
        default:
            return ""
        }
    }
}




public class VirtualController: ObservableObject, @unchecked Sendable {
    
    private init() {}
    
    static let shared = VirtualController()
    
    @Published var activeButtons: Set<VirtualControllerButton> = []
    @Published var thumbstickPositions: [ThumbstickType: CGPoint] = [:]
    
    var buttonPressed: ((VirtualControllerButton) -> Void)?
    var buttonReleased: ((VirtualControllerButton) -> Void)?
    var thumbstickMoved: ((ThumbstickType, CGPoint) -> Void)?
    
    fileprivate func pressButton(_ button: VirtualControllerButton) {
        self.activeButtons.insert(button)
        self.buttonPressed?(button)
    }
    
    fileprivate func releaseButton(_ button: VirtualControllerButton) {
        self.activeButtons.remove(button)
        self.buttonReleased?(button)
    }
    
    fileprivate func moveThumbstick(_ thumbstick: ThumbstickType, to position: CGPoint) {
        self.thumbstickPositions[thumbstick] = position
        self.thumbstickMoved?(thumbstick, position)
    }
}

