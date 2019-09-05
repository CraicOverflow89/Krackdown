package craicoverflow89.krackdown

import craicoverflow89.krackdown.parser.krackdownLexer
import craicoverflow89.krackdown.parser.krackdownParser
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream

fun main(args: Array<String>)
{
    // Test File
    val input = InputReader.readFile("test1")

    // Test Parser
    val lexer = krackdownLexer(ANTLRInputStream(input))
    val parser = krackdownParser(CommonTokenStream(lexer))
    val result = parser.file()
    //println(result.out.debug())
    println(result.out.toHTML())
}

class InputReader
{

    companion object
    {
        fun readFile(file: String) = InputReader::class.java.getResource("/input/$file.md").readText()
    }

}