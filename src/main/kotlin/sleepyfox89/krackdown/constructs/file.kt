package sleepyfox89.krackdown.constructs

class KrackdownResult(private val content: String)
{

    fun debug() = "\nKrackdownResult\n===============\n$content\n"

    fun toHTML() = StringBuffer().apply {
        append("<html>")
        append("<body>")
        append(content)
        append("</body>")
        append("</html>")
    }.toString()

}