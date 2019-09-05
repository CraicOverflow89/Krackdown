package sleepyfox89.krackdown

import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import sleepyfox89.krackdown.parser.krackdownLexer
import sleepyfox89.krackdown.parser.krackdownParser

fun main(args: Array<String>)
{
    // Test File
    val input = "hello world"

    // Test Parser
    val lexer = krackdownLexer(ANTLRInputStream(input))
    val parser = krackdownParser(CommonTokenStream(lexer))
    val result = parser.file()
    //println(result.out.debug())
    println(result.out.toHTML())

}