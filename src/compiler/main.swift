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
  var wordToDigit: [String: String] = [
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
    "zero": "0"
  ]

  init(source: String) {
    self.source = source
    self.position = 0
    self.next = Token(type: "", value: "0")
  }

  func selectNext() {
    while position < source.count && source[source.index(source.startIndex, offsetBy: position)].isWhitespace {
      position += 1
    }
    guard position < source.count else {
      self.next = Token(type: "EOF", value: "0")
      return
    }

    let currentChar = source[source.index(source.startIndex, offsetBy: position)]

    if currentChar.isLetter {
      var word = ""
      while position < source.count && source[source.index(source.startIndex, offsetBy: position)].isLetter {
        word.append(source[source.index(source.startIndex, offsetBy: position)])
        position += 1
      }
      switch word {
      case "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero":
        // Read the number
        var number = ""
        var currentWord = word
        while wordToDigit.keys.contains(currentWord) {
          number.append(wordToDigit[currentWord]!)
          currentWord = ""
          // Skip whitespace
          while position < source.count && source[source.index(source.startIndex, offsetBy: position)].isWhitespace {
            position += 1
          }
          // Read the next word
          while position < source.count && source[source.index(source.startIndex, offsetBy: position)].isLetter {
            currentWord.append(source[source.index(source.startIndex, offsetBy: position)])
            position += 1
          }
        }
        self.next = Token(type: "NUMBER", value: number)
      case "equal":
        self.next = Token(type: "REL_OP", value: "equal")
      case "more":
        self.next = Token(type: "REL_OP", value: "more")
      case "less":
        self.next = Token(type: "REL_OP", value: "less")
      case "is":
        self.next = Token(type: "IS", value: "is")
      case "To":
        // consume the rest of the expression: "To say the words he truly feels: "
        while position < source.count && source[source.index(source.startIndex, offsetBy: position)] != ":" {
          position += 1
        }
        self.next = Token(type: "PRINT", value: "0")
      case "While":
        self.next = Token(type: "WHILE", value: "While")
      case "If":
        self.next = Token(type: "IF", value: "If")
      case "But":
        self.next = Token(type: "ELSE", value: "But")
        return
      default:
        self.next = Token(type: "IDENTIFIER", value: word)
      }
    position += 1
    } else {
      let remainingChars = source.suffix(from: source.index(source.startIndex, offsetBy: position))

      if remainingChars.hasPrefix("It's Now or Never") {
        self.next = Token(type: "OR", value: "0")
        position += "It's Now or Never".count
        return
      } else if remainingChars.hasPrefix("Oh, there's black Jack and poker") {
        self.next = Token(type: "AND", value: "0")
        position += "Oh, there's black Jack and poker".count
        return
      } else if remainingChars.hasPrefix("Love me tender") {
        self.next = Token(type: "MUL", value: "0")
        position += "Love me tender".count
        return
      } else if remainingChars.hasPrefix("So don't you mess around with me") {
        self.next = Token(type: "DIV", value: "0")
        position += "So don't you mess around with me".count
        return
      } else if remainingChars.hasPrefix("You were always on my mind") {
        self.next = Token(type: "PLUS", value: "0")
        position += "You were always on my mind".count
        return
      } else if remainingChars.hasPrefix("They're so lonely") {
        self.next = Token(type: "MINUS", value: "0")
        position += "They're so lonely".count
        return
      } else if remainingChars.hasPrefix("Can't Help Falling in Love") {
        self.next = Token(type: "PLUS", value: "0")
        position += "Can't Help Falling in Love".count
        return
      } else if remainingChars.hasPrefix("I'm evil") {
        self.next = Token(type: "MINUS", value: "0")
        position += "I'm evil".count
        return
      } else if remainingChars.hasPrefix("You're the devil in disguise") {
        self.next = Token(type: "NOT", value: "0")
        position += "You're the devil in disguise".count
        return
      } else if remainingChars.hasPrefix("When you don't believe a word I say:") {
        self.next = Token(type: "READ", value: "0")
        position += "When you don't believe a word I say:".count
        return
      } else {
        switch currentChar {
        case "(":
          self.next = Token(type: "LPAREN", value: String(currentChar))
        case ")":
          self.next = Token(type: "RPAREN", value: String(currentChar))
        case "{":
          self.next = Token(type: "LBRACE", value: String(currentChar))
        case "}":
          self.next = Token(type: "RBRACE", value: String(currentChar))
        case ",":
          self.next = Token(type: "COMMA", value: String(currentChar))
        case "\n":
          self.next = Token(type: "EOL", value: String(currentChar))
        case "\"":
          position += 1
          var string = ""
          while source[source.index(source.startIndex, offsetBy: position)] != "\"" {
            string.append(source[source.index(source.startIndex, offsetBy: position)])
            position += 1
          }
          self.next = Token(type: "STRING", value: string)
        default:
          writeStderrAndExit("Unexpected character: \(currentChar)")
        }
        position += 1
      }
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
      if tokenizer.next.type != "LPAREN" {
        writeStderrAndExit("Missing opening parenthesis for read statement")
      }
      tokenizer.selectNext()
      if tokenizer.next.type != "RPAREN" {
        writeStderrAndExit("Missing closing parenthesis for read statement")
      }
      tokenizer.selectNext()
      return ReadOp(value: "READ", children: [])
    } else {
      writeStderrAndExit("Invalid factor: (\(tokenizer.next.type), \(tokenizer.next.value))")
    }
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
        writeStderrAndExit("Invalid statement")
      }
    } else if tokenizer.next.type == "PRINT" {
      tokenizer.selectNext()
      let expression = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
      return PrintOp(value: "PRINT", children: [expression])
    } else if tokenizer.next.type == "WHILE" {
      tokenizer.selectNext()
      let condition = parseBoolExpression(symbolTable: symbolTable, funcTable: funcTable)
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