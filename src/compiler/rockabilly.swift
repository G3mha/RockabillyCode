import Foundation


class PrePro {
  static public func filter(code: String) -> String {
    let splittedCode = code.replacingOccurrences(of: "\t", with: "").split(separator: "\n")
    var processedCode = ""
    for i in 0..<splittedCode.count {
      let line = splittedCode[i]
      if line.contains("--") {
        if line.prefix(2) != "--" {
          processedCode += String(line.split(separator: "--")[0]) + "\n"
        }
      } else {
        processedCode += String(line) + "\n"
      }
    }
    return processedCode
  }
}

class SymbolTable {
  private var table: [String: Any?] = [:]

  func initVar(_ variableName: String) {
    table[variableName] = nil
  }

  func setValue(_ variableName: String, _ variableValue: Any) {
    table[variableName] = variableValue
  }

  func getValue(_ variableName: String) -> Any {
    if !table.keys.contains(variableName) {
      writeStderrAndExit("Variable not initialized: \(variableName)")
      return 0
    } else if let variableValue = table[variableName] {
      return variableValue as Any
    }
    writeStderrAndExit("Variable \(variableName) is initialized, but has no value assigned")
    return 0
  }
}

class FuncTable {
  private var table: [String: ([VarDec], Block)] = [:]

  func setFunction(_ functionName: String, _ functionArgs: [VarDec], _ functionBody: Block) {
    table[functionName] = (functionArgs, functionBody)
  }

  func getFunction(_ functionName: String) -> (functionArgs: [VarDec], functionBody: Block) {
    if table.keys.contains(functionName) {
      if let functionData = table[functionName] {
        return functionData
      } else {
        writeStderrAndExit("Function \(functionName) is initialized, but has no value assigned")
        return ([], Block(value: "", children: []))
      }
    }
    writeStderrAndExit("Function not defined: \(functionName)")
    return ([], Block(value: "", children: []))
  }
}

protocol Node {
  var value: String { get set }
  var children: [Node] { get set }
  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any
}

class Block: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    for node in self.children {
      let nodeValue = node.evaluate(symbolTable: symbolTable, funcTable: funcTable)
      if node is ReturnOp {
        return nodeValue
      }
    }
    return 0
  }
}

class ReturnOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    return self.children[0].evaluate(symbolTable: symbolTable, funcTable: funcTable)
  }
}

class BinOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let firstValue = self.children[0].evaluate(symbolTable: symbolTable, funcTable: funcTable)
    let secondValue = self.children[1].evaluate(symbolTable: symbolTable, funcTable: funcTable)

    if let firstInt = firstValue as? Int, let secondInt = secondValue as? Int {
      if self.value == "PLUS" { return firstInt + secondInt }
      if self.value == "MINUS" { return firstInt - secondInt }
      if self.value == "MUL" { return firstInt * secondInt }
      if self.value == "DIV" { return firstInt / secondInt }
      if self.value == "GT" { return firstInt > secondInt ? 1 : 0 }
      if self.value == "LT" { return firstInt < secondInt ? 1 : 0 }
      if self.value == "EQ" { return firstInt == secondInt ? 1 : 0 }
      if self.value == "AND" { return firstInt == 1 && secondInt == 1 ? 1 : 0 }
      if self.value == "OR" { return firstInt == 1 || secondInt == 1 ? 1 : 0 }
      if self.value == "CONCAT" { return String(firstInt) + String(secondInt) }
    } else if let firstString = firstValue as? String, let secondString = secondValue as? String {
      if self.value == "GT" { return firstString > secondString ? 1 : 0 }
      if self.value == "LT" { return firstString < secondString ? 1 : 0 }
      if self.value == "EQ" { return firstString == secondString ? 1 : 0 }
      if self.value == "CONCAT" { return firstString + secondString }
    } else if let firstInt = firstValue as? Int, let secondString = secondValue as? String {
      if self.value == "CONCAT" { return String(firstInt) + secondString }
    } else if let firstString = firstValue as? String, let secondInt = secondValue as? Int {
      if self.value == "CONCAT" { return firstString + String(secondInt) }
    }
    writeStderrAndExit("Unsupported types for comparison: \(type(of: firstValue)) and \(type(of: secondValue))")
    return 0
  }
}

class UnOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let result = self.children[0].evaluate(symbolTable: symbolTable, funcTable: funcTable) as! Int
    if self.value == "NOT" {
      return (result == 0) ? 1 : 0
    } else if self.value == "MINUS" {
      return -result
    } else if self.value == "PLUS" {
      return result
    }
    writeStderrAndExit("Unsupported unary operation on integers")
    return 0
  }
}

class IntVal: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    if let intValue = Int(self.value) {
      return intValue
    }
    writeStderrAndExit("Invalid integer value")
    return 0
  }
}

class StringVal: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    return String(self.value)
  }
}

class NoOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    return 0
  }
}

class VarDec: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    symbolTable.initVar(self.value)
    return 0
  }
}

class VarAssign: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let variableValue = self.children[0].evaluate(symbolTable: symbolTable, funcTable: funcTable)
    symbolTable.setValue(self.value, variableValue)
    return 0
  }
}

class VarAccess: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    return symbolTable.getValue(self.value)
  }
}

class FuncDec: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let funcBody = self.children.last as! Block
    var funcArgs: [VarDec] = []
    for i in 0..<self.children.count-1 {
      funcArgs.append(self.children[i] as! VarDec)
    }
    funcTable.setFunction(self.value, funcArgs, funcBody)
    return 0
  }
}

class FuncCall: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let funcData = funcTable.getFunction(self.value)
    let funcArgsFromTable = funcData.0
    let funcBodyFromTable = funcData.1

    if self.children.count != funcArgsFromTable.count {
      writeStderrAndExit("Invalid number of arguments for function \(self.value)")
    }

    let localSymbolTable = SymbolTable()

    for i in 0..<funcArgsFromTable.count {
      localSymbolTable.initVar(funcArgsFromTable[i].value)
    }

    for i in 0..<self.children.count {
      let evaluatedValue = self.children[i].evaluate(symbolTable: symbolTable, funcTable: funcTable)
      localSymbolTable.setValue(funcArgsFromTable[i].value, evaluatedValue)
    }
    
    return funcBodyFromTable.evaluate(symbolTable: localSymbolTable, funcTable: funcTable)
  }
}

class Statements: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    for node in self.children {
      let _ = node.evaluate(symbolTable: symbolTable, funcTable: funcTable)
    }
    return 0
  }
}

class WhileOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let condition = self.children[0]
    let statements = self.children[1]
    while condition.evaluate(symbolTable: symbolTable, funcTable: funcTable) as! Int == 1 {
      let _ = statements.evaluate(symbolTable: symbolTable, funcTable: funcTable)
    }
    return 0
  }
}

class IfOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let condition = self.children[0]
    let ifStatements = self.children[1]
    let elseStatements = self.children[2]

    if condition.evaluate(symbolTable: symbolTable, funcTable: funcTable) as! Int == 1 {
      let _ = ifStatements.evaluate(symbolTable: symbolTable, funcTable: funcTable)
    } else {
      let _ = elseStatements.evaluate(symbolTable: symbolTable, funcTable: funcTable)
    }
    return 0
  }
}

class ReadOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let readValue = readLine()
    if let intValue = Int(readValue!) {
      return intValue as Any
    }
    writeStderrAndExit("Invalid integer value read from input")
    return 0
  }
}

class PrintOp: Node {
  var value: String
  var children: [Node]

  init(value: String, children: [Node]) {
    self.value = value
    self.children = children
  }

  func evaluate(symbolTable: SymbolTable, funcTable: FuncTable) -> Any {
    let printValue = self.children[0].evaluate(symbolTable: symbolTable, funcTable: funcTable)
    if let printInt = printValue as? Int {
      print(printInt)
    } else if let printString = printValue as? String {
      print(printString)
    } else {
      writeStderrAndExit("Unsupported type for print operation")
    }
    return 0
  }
}

class Token {
  var type: String
  var value: String

  init(type: String, value: String) {
    self.type = type
    self.value = value
  }
}

class Tokenizer {
  var source: String
  var position: Int
  var next: Token

  init(source: String) {
    self.source = source
    self.position = 0
    self.next = Token(type: "", value: "0")
  }

  func selectNext() {
    while position < source.count && source[source.index(source.startIndex, offsetBy: position)] == " " {
      position += 1
    }
    if position >= source.count {
      self.next = Token(type: "EOF", value: "0")
      return
    }

    let currentChar = source[source.index(source.startIndex, offsetBy: position)]

    if currentChar == "\n" {
      self.next = Token(type: "EOL", value: "0")
      position += 1
      return
    } else if currentChar == "," {
      self.next = Token(type: "COMMA", value: "0")
      position += 1
      return
    } else if currentChar == "\"" {
      position += 1
      var string = ""
      while source[source.index(source.startIndex, offsetBy: position)] != "\"" {
        string.append(source[source.index(source.startIndex, offsetBy: position)])
        position += 1
      }
      self.next = Token(type: "STRING", value: string)
      position += 1
      return
    } else if currentChar == "(" {
      self.next = Token(type: "LPAREN", value: "0")
      position += 1
      return
    } else if currentChar == ")" {
      self.next = Token(type: "RPAREN", value: "0")
      position += 1
      return
    } else if currentChar.isLetter {
      var remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
      var wordNumber = ""
      while true {
        if remainingChars.hasPrefix("one") {
          wordNumber += "1"
          position += "one".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("two") {
          wordNumber += "2"
          position += "two".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("three") {
          wordNumber += "3"
          position += "three".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("four") {
          wordNumber += "4"
          position += "four".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("five") {
          wordNumber += "5"
          position += "five".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("six") {
          wordNumber += "6"
          position += "six".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("seven") {
          wordNumber += "7"
          position += "seven".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("eight") {
          wordNumber += "8"
          position += "eight".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("nine") {
          wordNumber += "9"
          position += "nine".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix("zero") {
          wordNumber += "0"
          position += "zero".count
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else if remainingChars.hasPrefix(" ") {
          position += 1
          remainingChars = source[source.index(source.startIndex, offsetBy: position)...]
        } else {
          break
        }
      }
      if wordNumber != "" {
        self.next = Token(type: "NUMBER", value: wordNumber)
        return
      } else {
        if remainingChars.hasPrefix("Memphis") {
          self.next = Token(type: "LOCAL", value: "0")
          position += "Memphis".count
        } else if remainingChars.hasPrefix("Blue Hawaii") {
          self.next = Token(type: "FUNCTION", value: "0")
          position += "Blue Hawaii".count
        } else if remainingChars.hasPrefix("We can't go on together") {
          self.next = Token(type: "END", value: "0")
          position += "We can't go on together".count
        } else if remainingChars.hasPrefix("Return to sender") {
          self.next = Token(type: "RETURN", value: "0")
          position += "Return to sender".count
        } else if remainingChars.hasPrefix("While I can think") {
          self.next = Token(type: "WHILE", value: "0")
          position += "While I can think".count
        } else if remainingChars.hasPrefix("While I can talk") {
          self.next = Token(type: "DO", value: "0")
          position += "While I can talk".count
        } else if remainingChars.hasPrefix("While I can stand") {
          self.next = Token(type: "END", value: "0")
          position += "While I can stand".count
        } else if remainingChars.hasPrefix("If I can dream") {
          self.next = Token(type: "IF", value: "0")
          position += "If I can dream".count
        } else if remainingChars.hasPrefix("So please let my dream") {
          self.next = Token(type: "THEN", value: "0")
          position += "So please let my dream".count
        } else if remainingChars.hasPrefix("But I can't help") {
          self.next = Token(type: "ELSE", value: "0")
          position += "But I can't help".count
        } else if remainingChars.hasPrefix("Come true") {
          self.next = Token(type: "END", value: "0")
          position += "Come true".count
        } else if remainingChars.hasPrefix("To say the words he truly feels:") {
          self.next = Token(type: "PRINT", value: "0")
          position += "To say the words he truly feels:".count
        } else if remainingChars.hasPrefix("It's Now or Never") {
          self.next = Token(type: "OR", value: "0")
          position += "It's Now or Never".count
        } else if remainingChars.hasPrefix("Oh, there's black Jack and poker") {
          self.next = Token(type: "AND", value: "0")
          position += "Oh, there's black Jack and poker".count
        } else if remainingChars.hasPrefix("equal to") {
          self.next = Token(type: "EQ", value: "0")
          position += "equal to".count
        } else if remainingChars.hasPrefix("more than") {
          self.next = Token(type: "GT", value: "0")
          position += "more than".count
        } else if remainingChars.hasPrefix("less than") {
          self.next = Token(type: "LT", value: "0")
          position += "less than".count
        } else if remainingChars.hasPrefix("Love me tender") {
          self.next = Token(type: "PLUS", value: "0")
          position += "Love me tender".count
        } else if remainingChars.hasPrefix("So don't you mess around with me") {
          self.next = Token(type: "MINUS", value: "0")
          position += "So don't you mess around with me".count
        } else if remainingChars.hasPrefix("Follow That Dream") {
          self.next = Token(type: "CONCAT", value: "0")
          position += "Follow That Dream".count
        } else if remainingChars.hasPrefix("You were always on my mind") {
          self.next = Token(type: "MUL", value: "0")
          position += "You were always on my mind".count
        } else if remainingChars.hasPrefix("They're so lonely") {
          self.next = Token(type: "DIV", value: "0")
          position += "They're so lonely".count
        } else if remainingChars.hasPrefix("Can't Help Falling in Love") {
          self.next = Token(type: "PLUS", value: "0")
          position += "Can't Help Falling in Love".count
        } else if remainingChars.hasPrefix("I'm evil") {
          self.next = Token(type: "MINUS", value: "0")
          position += "I'm evil".count
        } else if remainingChars.hasPrefix("You're the devil in disguise") {
          self.next = Token(type: "NOT", value: "0")
          position += "You're the devil in disguise".count
        } else if remainingChars.hasPrefix("When you don't believe a word I say:") {
          self.next = Token(type: "READ", value: "0")
          position += "When you don't believe a word I say:".count
        } else if remainingChars.hasPrefix("is") {
          self.next = Token(type: "ASSIGN", value: "0")
          position += "is".count
        } else {
          var identifier = ""
          while source[source.index(source.startIndex, offsetBy: position)].isLetter {
            identifier.append(source[source.index(source.startIndex, offsetBy: position)])
            position += 1
          }
          self.next = Token(type: "IDENTIFIER", value: identifier)
        }
      }
    } else {
      writeStderrAndExit("Unexpected character: \(currentChar)")
    }
  }
}

class Parser {
  var tokenizer: Tokenizer

  init() {
    self.tokenizer = Tokenizer(source: "")
  }

  private func parseFactor(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    if tokenizer.next.type == "NUMBER" {
      let factorValue = tokenizer.next.value
      tokenizer.selectNext()
      return IntVal(value: factorValue, children: [])
    } else if tokenizer.next.type == "STRING" {
      let factorValue = tokenizer.next.value
      tokenizer.selectNext()
      return StringVal(value: factorValue, children: [])
    } else if tokenizer.next.type == "IDENTIFIER" {
      let name = tokenizer.next.value
      tokenizer.selectNext()
      if tokenizer.next.type == "LPAREN" {
        tokenizer.selectNext()
        var arguments: [Node] = []
        while tokenizer.next.type != "RPAREN" {
          let argument = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
          arguments.append(argument)
          if tokenizer.next.type == "COMMA" {
            tokenizer.selectNext()
          } else if tokenizer.next.type != "RPAREN" {
            writeStderrAndExit("Missing comma between function arguments")
          }
        }
        tokenizer.selectNext()
        return FuncCall(value: name, children: arguments)
      } else {
        return VarAccess(value: name, children: [])
      }
    } else if tokenizer.next.type == "PLUS" || tokenizer.next.type == "MINUS" || tokenizer.next.type == "NOT" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      return UnOp(value: operatorType, children: [parseFactor(symbolTable: symbolTable, funcTable: funcTable)])
    } else if tokenizer.next.type == "LPAREN" {
      tokenizer.selectNext()
      let result = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      if tokenizer.next.type != "RPAREN" {
        writeStderrAndExit("Missing closing parenthesis")
      }
      tokenizer.selectNext()
      return result
    } else if tokenizer.next.type == "READ" {
      tokenizer.selectNext()
      return ReadOp(value: "READ", children: [])
    }
    writeStderrAndExit("Invalid factor: (\(tokenizer.next.type), \(tokenizer.next.value))")
    return NoOp(value: "", children: [])
  }

  private func parseTerm(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var result = parseFactor(symbolTable: symbolTable, funcTable: funcTable)
    while tokenizer.next.type == "MUL" || tokenizer.next.type == "DIV" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      result = BinOp(value: operatorType, children: [result, parseFactor(symbolTable: symbolTable, funcTable: funcTable)])
    }
    return result
  }

  private func parseExpression(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var result = parseTerm(symbolTable: symbolTable, funcTable: funcTable)
    while tokenizer.next.type == "PLUS" || tokenizer.next.type == "MINUS" || tokenizer.next.type == "CONCAT" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      result = BinOp(value: operatorType, children: [result, parseTerm(symbolTable: symbolTable, funcTable: funcTable)])
    }
    return result
  }

  private func parseRelationalExpression(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var result = parseExpression(symbolTable: symbolTable, funcTable: funcTable)
    while tokenizer.next.type == "GT" || tokenizer.next.type == "LT" || tokenizer.next.type == "EQ" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      result = BinOp(value: operatorType, children: [result, parseExpression(symbolTable: symbolTable, funcTable: funcTable)])
    }
    return result
  }

  private func parseBooleanTerm(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var result = parseRelationalExpression(symbolTable: symbolTable, funcTable: funcTable)
    while tokenizer.next.type == "AND" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      result = BinOp(value: operatorType, children: [result, parseRelationalExpression(symbolTable: symbolTable, funcTable: funcTable)])
    }
    return result
  }

  private func parseBoolExpression(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var result = parseBooleanTerm(symbolTable: symbolTable, funcTable: funcTable)
    while tokenizer.next.type == "OR" {
      let operatorType = tokenizer.next.type
      tokenizer.selectNext()
      result = BinOp(value: operatorType, children: [result, parseBooleanTerm(symbolTable: symbolTable, funcTable: funcTable)])
    }
    return result
  }

  private func parseStatement(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    if tokenizer.next.type == "EOL" {
      tokenizer.selectNext()
      return NoOp(value: "", children: [])
    } else if tokenizer.next.type == "IDENTIFIER" {
      let name = tokenizer.next.value
      tokenizer.selectNext()
      if tokenizer.next.type == "ASSIGN" {
        tokenizer.selectNext()
        let expression = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
        return VarAssign(value: name, children: [expression])
      } else if tokenizer.next.type == "LPAREN" {
        tokenizer.selectNext()
        var arguments: [Node] = []
        while tokenizer.next.type != "RPAREN" {
          let argument = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
          arguments.append(argument)
          if tokenizer.next.type == "COMMA" {
            tokenizer.selectNext()
          } else if tokenizer.next.type != "RPAREN" {
            writeStderrAndExit("Missing comma between function arguments")
          }
        }
        tokenizer.selectNext()
        return FuncCall(value: name, children: arguments)
      } else {
        writeStderrAndExit("Invalid assignment or function call")
      }
    } else if tokenizer.next.type == "PRINT" {
      tokenizer.selectNext()
      let expression = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      return PrintOp(value: "PRINT", children: [expression])
    } else if tokenizer.next.type == "WHILE" {
      tokenizer.selectNext()
      let condition = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after WHILE condition")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "DO" {
        writeStderrAndExit("Missing DO after WHILE condition")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after DO")
      }
      tokenizer.selectNext()
      var statements: [Node] = []
      while tokenizer.next.type != "END" {
        let statement = parseStatement(symbolTable: symbolTable, funcTable: funcTable)
        statements.append(statement)
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after END")
      }
      return WhileOp(value: "WHILE", children: [condition, Statements(value: "", children: statements)])
    } else if tokenizer.next.type == "IF" {
      tokenizer.selectNext()
      let condition = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after IF condition")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "THEN" {
        writeStderrAndExit("Missing THEN after IF condition")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after THEN")
      }
      tokenizer.selectNext()
      var ifStatements: [Node] = []
      while tokenizer.next.type != "END" && tokenizer.next.type != "ELSE" {
        let statement = parseStatement(symbolTable: symbolTable, funcTable: funcTable)
        ifStatements.append(statement)
      }
      var elseStatements: [Node] = []
      if tokenizer.next.type == "ELSE" {
        tokenizer.selectNext()
        while tokenizer.next.type != "END" {
          let statement = parseStatement(symbolTable: symbolTable, funcTable: funcTable)
          elseStatements.append(statement)
        }
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after END")
      }
      return IfOp(value: "IF", children: [condition, Statements(value: "", children: ifStatements), Statements(value: "", children: elseStatements)])
    } else if tokenizer.next.type == "LOCAL" {
      tokenizer.selectNext()
      if tokenizer.next.type != "IDENTIFIER" {
        writeStderrAndExit("Invalid variable name in declaration")
      }
      let variableName = tokenizer.next.value
      tokenizer.selectNext()
      if tokenizer.next.type == "ASSIGN" {
        tokenizer.selectNext()
        let expression = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
        return VarAssign(value: variableName, children: [expression])
      } else {
        return VarDec(value: variableName, children: [])
      }
    } else if tokenizer.next.type == "FUNCTION" {
      tokenizer.selectNext()
      if tokenizer.next.type != "IDENTIFIER" {
        writeStderrAndExit("Invalid function name in function declaration")
      }
      let functionName = tokenizer.next.value
      tokenizer.selectNext()
      if tokenizer.next.type != "LPAREN" {
        writeStderrAndExit("Missing opening parenthesis for function declaration")
      }
      tokenizer.selectNext()
      var functionItems: [Node] = []
      while tokenizer.next.type != "RPAREN" {
        if tokenizer.next.type == "IDENTIFIER" {
          functionItems.append(VarDec(value: tokenizer.next.value, children: []))
          tokenizer.selectNext()
          if tokenizer.next.type == "COMMA" {
            tokenizer.selectNext()
          } else if tokenizer.next.type != "RPAREN" {
            writeStderrAndExit("Missing comma between function arguments")
          }
        } else {
          writeStderrAndExit("Invalid argument name in function declaration")
        }
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after function arguments")
      }
      tokenizer.selectNext()
      var statements: [Node] = []
      while tokenizer.next.type != "END" {
        let statement = parseStatement(symbolTable: symbolTable, funcTable: funcTable)
        statements.append(statement)
      }
      functionItems.append(Block(value: "", children: statements))
      if tokenizer.next.type != "END" {
        writeStderrAndExit("Missing END after function declaration")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "EOL" {
        writeStderrAndExit("Missing EOL after END")
      }
      return FuncDec(value: functionName, children: functionItems)
    } else if tokenizer.next.type == "RETURN" {
      tokenizer.selectNext()
      let expression = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      return ReturnOp(value: "RETURN", children: [expression])
    }
    writeStderrAndExit("Invalid statement")
    return NoOp(value: "", children: [])
  }

  private func parseBlock(symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    var statements: [Node] = []
    while tokenizer.next.type != "EOF" {
      let statement = parseStatement(symbolTable: symbolTable, funcTable: funcTable)
      statements.append(statement)
    }
    return Block(value: "", children: statements)
  }

  public func run(code: String, symbolTable: SymbolTable, funcTable: FuncTable) -> Node {
    let filteredCode = PrePro.filter(code: code)
    self.tokenizer = Tokenizer(source: filteredCode)
    tokenizer.selectNext() // Position the tokenizer to the first token
    return parseBlock(symbolTable: symbolTable, funcTable: funcTable)
  }
}


func writeStderrAndExit(_ message: String) {
  // function that writes to stderr a received string and exits with error
  fputs("ERROR: \(message)\n", stderr) // write to stderr
  exit(1) // exit with error
}

func readFile(_ path: String) -> String {
  do {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    return contents
  } catch {
    writeStderrAndExit("Failed to read file")
    return ""
  }
}

func main() {
  // Ensure there is at least one command line argument for the file path.
  guard CommandLine.arguments.count > 1 else {
    writeStderrAndExit("Please provide a file path.")
    return
  }
  // check if file has .ep extension
  if !CommandLine.arguments[1].hasSuffix(".ep") {
    writeStderrAndExit("File must have .ep extension")
  }

  let fileContent = readFile(CommandLine.arguments[1])
  let symbolTable = SymbolTable()
  let funcTable = FuncTable()
  let myParser = Parser()
  let ast = myParser.run(code: fileContent, symbolTable: symbolTable, funcTable: funcTable)
  let _ = ast.evaluate(symbolTable: symbolTable, funcTable: funcTable)
}

main()