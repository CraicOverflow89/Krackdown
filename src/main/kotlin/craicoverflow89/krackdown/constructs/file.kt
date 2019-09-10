package craicoverflow89.krackdown.constructs

import java.lang.StringBuilder

class KrackdownResult(private val content: ArrayList<KrackdownExpression>)
{

    fun debug(indent: Int) = KrackdownResultDebug("KrackdownResult", indent, content.map {it.debug(indent + 1)})

    fun toHTML() = StringBuilder().apply {
        append("<html>")
        append("<body>")
        content.forEach {append(it.toHTML())}
        append("</body>")
        append("</html>")
    }.toString()
    // NOTE: we could actually make the indent (or child/parent relations in general) stuff work here, for HTML indentation

}

data class KrackdownResultDebug(val content: String, val indent: Int, val children: List<KrackdownResultDebug> = listOf())
{

    override fun toString() = StringBuilder().apply {
        append(" ".repeat(indent * 4) + content)
        children.forEach {append("\n$it")}
    }.toString()

}