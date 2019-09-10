package craicoverflow89.krackdown.constructs

interface KrackdownExpression
{

    fun debug(indent: Int): KrackdownResultDebug
    fun toHTML(): String

}

class KrackdownExpressionBreak: KrackdownExpression
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownExpressionBreak", indent)

    override fun toHTML() = "<br>"

}

class KrackdownExpressionHeader(private val size: Int, private val content: KrackdownExpressionString): KrackdownExpression
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownExpressionHeader {size: $size}", indent, listOf(content.debug(indent + 1)))

    override fun toHTML() = "<h$size>${content.toHTML()}</h$size>"

}

class KrackdownExpressionSequence(private val content: ArrayList<KrackdownFormat>): KrackdownExpression
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownExpressionSequence", indent, content.map {
        it.debug(indent + 1)
    })

    override fun toHTML() = content.joinToString {
        it.toHTML()
    }

}

class KrackdownExpressionString(private val content: String): KrackdownExpression
{

    override fun debug(indent: Int) = KrackdownResultDebug("KrackdownExpressionString {content: $content}", indent)

    fun getContent() = content

    override fun toHTML() = content

}