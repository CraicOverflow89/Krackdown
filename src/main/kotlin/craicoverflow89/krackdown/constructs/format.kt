package craicoverflow89.krackdown.constructs

import java.lang.StringBuilder

interface KrackdownFormat: KrackdownExpression

class KrackdownFormatBold(private val content: KrackdownFormat): KrackdownFormat
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownFormatBold", indent, listOf(content.debug(indent + 1)))

    override fun toHTML() = "<b>${content.toHTML()}</b>"

}

class KrackdownFormatItalic(private val content: KrackdownFormat): KrackdownFormat
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownFormatItalic", indent, listOf(content.debug(indent + 1)))

    override fun toHTML() = "<i>${content.toHTML()}</i>"

}

class KrackdownFormatLink(private val url: KrackdownExpressionString, private val text: KrackdownExpressionString, private val title: KrackdownExpressionString?): KrackdownFormat
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownLink {url: ${url.debug(indent + 1)}, text: ${text.debug(indent + 1)}, title: ${title?.debug(indent + 1)}}", indent + 1)

    override fun toHTML() = StringBuilder().apply {
        append("<a href = \"")
        append(url.toHTML())
        append("\"")
        if(title != null)
        {
            append(" title = \"")
            append(title.toHTML())
            append("\"")
        }
        append(">")
        append(text.toHTML())
        append("</a>")
    }.toString()

}

class KrackdownFormatStrikethrough(private val content: KrackdownFormat): KrackdownFormat
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownFormatStrikethrough", indent, listOf(content.debug(indent + 1)))

    override fun toHTML() = "<s>${content.toHTML()}</s>"

}

class KrackdownFormatString(private val content: String): KrackdownFormat
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownFormatString {content: $content}", indent)

    override fun toHTML() = content

}