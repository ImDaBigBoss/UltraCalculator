//
//  ContentView.swift
//  SuperCalculator
//
//  Created by alex on 19/04/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonTextSize: CGFloat = 30
    @State private var padding: CGFloat = 16
    
    @State private var buttons = ["AC", "%", "+/-", "÷", "7", "8", "9", "x", "4", "5", "6", "-", "1", "2", "3", "+", "√", "0", ".", "="]
    
    @State private var result: String = "0"
    @State private var currentNum: String = "0"
    @State private var hasSetCurrent: Bool = false
    @State private var previousNum: Double = 0
    @State private var previousOperator: String = ""
    @State private var hasCounted: Bool = true
    @State private var okToOverwrite: Bool = true
    @State private var lastPressed: String = "";
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundColor)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Text(result)
                        .font(.system(size: buttonTextSize))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: (80 * 4) + 24, maxHeight: 80)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.darkButtonColor))
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                
                HStack {
                    ForEach(0...3, id: \.self) { index in
                        Button(action: {
                            buttonPressed(char: buttons[index])
                        }, label: {
                            Text(buttons[index])
                                .font(.system(size: buttonTextSize))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .background(RoundedRectangle(cornerRadius: 8).fill(getButtonColour(char: buttons[index])))
                        })
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                HStack {
                    ForEach(4...7, id: \.self) { index in
                        Button(action: {
                            buttonPressed(char: buttons[index])
                        }, label: {
                            Text(buttons[index])
                                .font(.system(size: buttonTextSize))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .background(RoundedRectangle(cornerRadius: 8).fill(getButtonColour(char: buttons[index])))
                        })
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                HStack {
                    ForEach(8...11, id: \.self) { index in
                        Button(action: {
                            buttonPressed(char: buttons[index])
                        }, label: {
                            Text(buttons[index])
                                .font(.system(size: buttonTextSize))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .background(RoundedRectangle(cornerRadius: 8).fill(getButtonColour(char: buttons[index])))
                        })
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                HStack {
                    ForEach(12...15, id: \.self) { index in
                        Button(action: {
                            buttonPressed(char: buttons[index])
                        }, label: {
                            Text(buttons[index])
                                .font(.system(size: buttonTextSize))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .background(RoundedRectangle(cornerRadius: 8).fill(getButtonColour(char: buttons[index])))
                        })
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                HStack {
                    ForEach(16...19, id: \.self) { index in
                        Button(action: {
                            buttonPressed(char: buttons[index])
                        }, label: {
                            Text(buttons[index])
                                .font(.system(size: buttonTextSize))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .background(RoundedRectangle(cornerRadius: 8).fill(getButtonColour(char: buttons[index])))
                        })
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 1)
                
                Spacer()
            }
        }
    }
    
    func getButtonColour(char: String) -> Color {
        if (Int(char) == nil) {
            return Color.lightButtonColor
        } else {
            return Color.darkButtonColor
        }
    }
    
    func buttonPressed(char: String) {
        if (Int(char) == nil) {
            if (char == ".") {
                if (!result.contains(".")) {
                    result = result + char
                    okToOverwrite = false
                    hasCounted = false
                    hasSetCurrent = false
                }
                if (Int(lastPressed) == nil) {
                    okToOverwrite = true
                    numPressed(char: "0.")
                }
            } else if (char == "AC") {
                resetAllCalc()
            } else if (char == "C") {
                buttons[0] = "AC"
                result = "0"
                okToOverwrite = true
            } else if (char == "√") {
                if (result.contains("-")) {
                    resetAllCalc()
                    result = "Error"
                } else {
                    result = doubleToString(num: Double(result)!.squareRoot())
                }
            } else if (char == "+/-") {
                if (okToOverwrite) {
                    if (result == "-0") {
                        result = "0"
                    } else {
                        result = "-0"
                    }
                } else {
                    if (result.contains("-")) {
                        result = result.replacingOccurrences(of: "-", with: "")
                    } else {
                        result = "-" + result
                    }
                }
            } else if (char == "%") {
                if (Double(result) != 0) {
                    result = doubleToString(num: Double(result)!/100)
                }
            } else if (char == "=") {
                if (hasSetCurrent == false) {
                    currentNum = result
                    hasSetCurrent = true
                }
                previousNum = calculate(num1: previousNum, oper: previousOperator, num2: Double(currentNum) ?? 0)
                result = doubleToString(num: previousNum)
                okToOverwrite = true
                
                hasCounted = true
                buttons[0] = "AC"
            } else {
                buttons[0] = "C"
                if (hasCounted == false) {
                    if (hasSetCurrent == false) {
                        currentNum = result
                        hasSetCurrent = true
                    }
                    previousNum = calculate(num1: previousNum, oper: previousOperator, num2: Double(currentNum) ?? 0)
                    result = doubleToString(num: previousNum)
                    okToOverwrite = true
                    
                    hasCounted = true
                }
                previousOperator = char
            }
        } else {
            numPressed(char: char)
        }
        lastPressed = char
    }
    
    func numPressed(char: String) {
        if (result.count - (result.components(separatedBy:".").count-1) - (result.components(separatedBy:"-").count-1) < 9 || okToOverwrite) {
            if (okToOverwrite) {
                if (result == "-0") {
                    result = "-" + char
                } else {
                    result = char
                }
                okToOverwrite = false
            } else {
                if (Double(result) == 0 && !result.contains(".")) {
                    okToOverwrite = true
                } else {
                    result = result + char
                }
            }
            buttons[0] = "C"
            hasCounted = false
            hasSetCurrent = false
        }
    }
    
    func resetAllCalc() {
        result = "0"
        currentNum = "0"
        hasSetCurrent = true
        previousNum = 0
        previousOperator = ""
        hasCounted = true
        okToOverwrite = true
        buttons[0] = "AC"
    }
    
    func calculate(num1: Double, oper: String, num2: Double) -> Double {
        if (oper == "+") {
            return num1 + num2
        } else if (oper == "-") {
            return num1 - num2
        } else if (oper == "÷") {
            if (num1 == 0 || num2 == 0) {
                return .infinity
            }
            return num1 / num2
        } else if (oper == "x") {
            return num1 * num2
        } else {
            return num2
        }
    }
    
    func doubleToString(num: Double) -> String {
        if (num.isInfinite) {
            resetAllCalc()
            return "Error"
        } else if (num.isNaN) {
            resetAllCalc()
            return "Error"
        }
        
        var out = String(round(num*1000000000)/1000000000)
        if (out.hasSuffix(".0")) {
            out = out.replacingOccurrences(of: ".0", with: "")
        }
        
        return out
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone SE (1st generation)")
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone Xs")
        ContentView()
            .previewDevice("iPhone 11 Pro Max")
        ContentView()
            .previewDevice("iPad Pro (9.7-inch)")
    }
}
