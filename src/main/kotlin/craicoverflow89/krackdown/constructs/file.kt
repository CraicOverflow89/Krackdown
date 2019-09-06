package craicoverflow89.krackdown.constructs

import java.lang.StringBuilder

interface KrackdownConstruct
{

    fun debug(): String
    fun toHTML(): String

}

class KrackdownResult(private val content: ArrayList<KrackdownExpression>): KrackdownConstruct
{

    /*override fun debug() = "\nKrackdownResult\n===============\n${content.joinToString(", ") {
        it?.debug()
    }}\n"*/
    // NOTE: shouldn't have to be worried about NPEs here but there is too much Java going on in ANTLR to be sure
    override fun debug() = "\nKrackdownResult\n===============\n${content.filterNotNull().joinToString(", ") {
        it.debug()
    }}\n"

    // NOTE: for better visuals, we should implement an indentation system (so start at the left but indent for children
    //       passing the level of indentation along, which is passed to a single method that converts it to console text

    override fun toHTML() = StringBuilder().apply {
        append("<html>")
        append("<body>")
        content.forEach {append(it.toHTML())}
        append("</body>")
        append("</html>")
    }.toString()

}