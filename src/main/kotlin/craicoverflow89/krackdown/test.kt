package craicoverflow89.krackdown

import craicoverflow89.krackdown.parser.krackdownLexer
import craicoverflow89.krackdown.parser.krackdownParser
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream

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