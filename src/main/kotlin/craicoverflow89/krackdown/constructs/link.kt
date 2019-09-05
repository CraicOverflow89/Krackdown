package craicoverflow89.krackdown.constructs

import java.lang.StringBuilder

class KrackdownLink(private val url: String, private val text: String, private val title: String?)
{

    fun toHTML() = StringBuilder().apply {
        append("<a href = \"")
        append(url)
        append("\"")
        if(title != null)
        {
            append(" title = \"")
            append(title)
            append("\"")
        }
        append(">")
        append(text)
        append("</a>")
    }.toString()

}