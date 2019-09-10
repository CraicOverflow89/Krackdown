package craicoverflow89.krackdown.constructs

interface KrackdownExpression: KrackdownConstruct

class KrackdownExpressionBreak: KrackdownExpression
{

    override fun debug() = "KrackdownExpressionBreak"

    override fun toHTML() = "<br>"

}

class KrackdownExpressionHeader(private val size: Int, private val content: KrackdownExpressionString): KrackdownExpression
{

    override fun debug() = "KrackdownExpressionHeader {size: $size, content: ${content.debug()}"

    override fun toHTML() = "<h$size>${content.toHTML()}</h$size>"

}

class KrackdownExpressionSequence(private val content: ArrayList<KrackdownFormat>): KrackdownExpression
{

    override fun debug() = "KrackdownExpressionSequence {${content.joinToString {
        it.debug()
    }}}"

    override fun toHTML() = content.joinToString {
        it.toHTML()
    }

}

class KrackdownExpressionString(private val content: String): KrackdownExpression
{

    override fun debug() = "KrackdownExpressionString {content: $content}"

    fun getContent() = content

    override fun toHTML() = content

}