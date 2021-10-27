////
//// Created by odin on 26.10.21.
////
//
//import Foundation
//
//class AstPrinter: ExpressionVisitor {
//    func visitAssign(expr: AssignExpression) throws -> String {
//        fatalError("Not implemented")
//    }
//    
//    func visitVariable(expr: VariableExpression) throws -> String {
//        fatalError("Not implemented")
//    }
//    
//    typealias ExpressionVisitorReturnType = String
//
//    public func print(expr: Expression) -> String {
//        return try! expr.accept(visitor: self)
//    }
//
//    public func visitBinary(expr: BinaryExpression) throws -> ExpressionVisitorReturnType {
//        return parenthesize(name: expr.operation.lexeme, exprs: [expr.left, expr.right])
//    }
//
//    public func visitGrouping(expr: GroupingExpression) throws -> ExpressionVisitorReturnType {
//        return parenthesize(name: "group", exprs: [expr.expression])
//    }
//
//    public func visitLiteral(expr: LiteralExpression) throws -> ExpressionVisitorReturnType {
//        guard let value = expr.value.conent else {
//            return "nil"
//        }
//        return String(describing: value)
//    }
//
//    public func visitUnary(expr: UnaryExpression) throws -> ExpressionVisitorReturnType{
//        return parenthesize(name: expr.operation.lexeme, exprs: [expr.right])
//    }
//
//    private func parenthesize(name: String, exprs: [Expression]) -> String {
//        var builder = ""
//        builder.append("(" + name)
//        for expr in exprs {
//            builder.append(" ")
//            builder.append(try! expr.accept(visitor: self))
//        }
//        builder.append(")")
//        return builder
//    }
//}
