import Foundation

var numberOfWords = 0
var arrayOfOperands = [String]()
enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inline: String)
        case inconsistentSpacingForOperator(operator: String, inLine: String)
        case literalIntTooLarge(inLine: String)
    }
    
    case variableDeclaration
    case operatorAssignment
    case identifier(name: String)
    case literalInt(value: Int)
    
    //static  means no instance of enum, belongs to enum. you can do lexeme.nextlexeme
    static func nextLexeme(from line: Substring) throws -> (lexeme:Lexeme, text: Substring, charactersConsumed: Int) {
        // the '*' is 0 or more, '+' is one or more
        // if let match = try //.prefixMatch(in: line) {
        //     return (lexeme: .operatorAssignment, text: match.0, charcatersConsumed: match.0.count)
        // }
        if let match = try  /\s*(¬)/.prefixMatch(in: line) {
            arrayOfOperands.append(String(match.1))
            return (lexeme: .operatorAssignment, text: match.0, charactersConsumed: match.0.count) 
        }
        
        if let match = try /(\s*)([∧,∨,⊕,→,=,≠])(\s*)/.prefixMatch(in: line) { //capture ()
            guard (match.1.count >= 0 && match.3.count >= 0) else {
                throw LexemeError.inconsistentSpacingForOperator(operator: match.2.base, inLine: String(line))
            }
            arrayOfOperands.append(String(match.2))
            return (lexeme: .operatorAssignment, text: match.0, charactersConsumed: match.0.count)
            
        } else if let match = try /\s*([a-z]*)\s*/.prefixMatch(in: line) {
            numberOfWords += 1
            return (lexeme: .identifier(name: String(match.1)), text: match.0, charactersConsumed: match.0.count) //match.1 does
            
        } else if let match = try /\s*(\d+)\s*/.prefixMatch(in: line) {
            guard let  value = Int(match.1) else {
                throw LexemeError.literalIntTooLarge(inLine: String(line))
            }
            return (lexeme: .literalInt(value: value), text: match.0, charactersConsumed: match.0.count)
            
        } else {
            throw LexemeError.failedToFindLexeme(inline: String(line))
        }
    }
}
//some useful extensions
extension String {
    func extendBinaryValue(with padding: Character, toLength length: Int) -> String {
        let paddingWidth = length - self.count
        guard 0 < paddingWidth else { return self }
        return String(repeating: padding, count: paddingWidth) + self
    }
}

extension Int {
    func powerOfTwo(_ n: Int) -> Int {
        return 1 << n
    }
}


func stringToBinary(amount: Int) {
    var column = 0
    let amountOfBinaryNumbers = 2.powerOfTwo(amount)
    print("this is he amount" + String(amountOfBinaryNumbers))
    for number in 0 ..< amountOfBinaryNumbers{
        column += 1
        //execute this function that will take it an calculate it.
        let binaryDigits = String(number, radix: 2).extendBinaryValue(with: "0", toLength: amount)
        print("column \(column): " + binaryDigits)
        print(combine(binaryColumn: binaryDigits, arrayOfOperands: arrayOfOperands))
    }
    
}


func combine(binaryColumn: String, arrayOfOperands: [String]) -> [Any] {
 var truthValueArray: [Any] = []
    let binaryArray = Array(binaryColumn)
    for (index, char) in binaryArray.enumerated() {
        truthValueArray.append(String(char))
        if index < arrayOfOperands.count {
            truthValueArray.append(arrayOfOperands[index] as Any)
        }
    }
    if binaryArray.count < arrayOfOperands.count {
        truthValueArray.append(contentsOf: arrayOfOperands.suffix(from: binaryArray.count).map { $0 as Any })
    }
    return truthValueArray
}

struct Operation {
    func negate(digit: String) {
        
    }
}

func calculate(array: String) -> String {
    //∧,∨,⊕,→,=,≠, ¬
    for string in array {
        switch string {
         case string == "¬" {
                 
             }
        }
    }
}


struct LexemeSource {
    let lexeme: Lexeme
    let text: String

    static func lex(line: String) throws {
        var workingLine = Substring(line)
        print("workingline og : \(workingLine)")
        while workingLine.count > 0 {
            let (lexeme, text, charactersConsumed) = try Lexeme.nextLexeme(from: workingLine)
            workingLine = workingLine.dropFirst(charactersConsumed)            
            print("working line: \(workingLine)")
            print("#character: \(charactersConsumed), text: \(text), lexeme: \(lexeme)")           
            //when the code is printed the spaces are also includes as characters
            
        }        
        print(arrayOfOperands)
        stringToBinary(amount: numberOfWords)
    }
}


func main() {
    do {
        //lexeme is parts that are important, white space isnt
        let test_line = " ¬matt ∨ john ∨ john"
        try LexemeSource.lex(line: test_line)
    } catch {
        print("Failed because \(error)")
    }
}

main()
