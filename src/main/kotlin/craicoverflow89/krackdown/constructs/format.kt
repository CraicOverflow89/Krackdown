package craicoverflow89.krackdown.constructs

import java.lang.StringBuilder

interface KrackdownFormat: KrackdownExpression

class KrackdownFormatBold(private val content: KrackdownFormat): KrackdownFormat
{

    override fun debug() = "KrackdownFormatBold {content: ${content.debug()}"

    override fun toHTML() = "<b>${content.toHTML()}</b>"

}

class KrackdownFormatItalic(private val content: KrackdownFormat): KrackdownFormat
{

    override fun debug() = "KrackdownFormatItalic {content: ${content.debug()}"

    override fun toHTML() = "<i>${content.toHTML()}</i>"

}

class KrackdownFormatLink(private val url: KrackdownExpressionString, private val text: KrackdownExpressionString, private val title: KrackdownExpressionString?): KrackdownFormat
{

    override fun debug() = "KrackdownLink {url: ${url.debug()}, text: ${text.debug()}, title: ${title?.debug()}}"

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

    override fun debug() = "KrackdownFormatStrikethrough {content: ${content.debug()}"

    override fun toHTML() = "<s>${content.toHTML()}</s>"

}

class KrackdownFormatString(private val content: String): KrackdownFormat
{

    override fun debug() = "KrackdownFormatString {content: $content}"

    override fun toHTML() = content

}