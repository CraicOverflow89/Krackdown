grammar krackdown;

@header
{
    import craicoverflow89.krackdown.constructs.*;
    import java.lang.StringBuilder;
    // NOTE: should remove StringBuilder when it's no longer being used
    import java.util.ArrayList;
}

// Parser Rules

file returns [KrackdownResult out]
    @init {ArrayList<KrackdownExpression> result = new ArrayList();}
    :   (
            (
                expHeader
                {result.add($expHeader.result);}
            |
                expBreak
                {result.add($expBreak.result);}
            |
                expSequence
                {result.add($expSequence.result);}
            )
        )*? EOF
        {$out = new KrackdownResult(result);}
    ;

expBreak returns [KrackdownExpressionBreak result]
    :   NEWLINE NEWLINE
        {$result = new KrackdownExpressionBreak();}
        // NOTE: seems trivial to create this here instead of file rule
        //       but could be useful later for debugging precision / context awareness
    ;

expHeader returns [KrackdownExpressionHeader result]
    :   (hash += HASH)+
        {$hash.size() >= 1 && $hash.size() <= 6}?
        SPACE expString
        {$result = new KrackdownExpressionHeader($hash.size(), $expString.result);}
    ;

expSequence returns [KrackdownExpressionSequence result]
    @init {ArrayList<KrackdownFormat> list = new ArrayList();}
    :   fs1 = formatSequence
        {list.add($fs1.result);}
        (
            fs2 = formatSequence
            {list.add($fs2.result);}
        )*
        {$result = new KrackdownExpressionSequence(list);}
    ;

expString returns [KrackdownExpressionString result]
    :   expStringContent
        // NOTE: we must allow HASH but it could interfere with header recognition
        {$result = new KrackdownExpressionString($expStringContent.text);}
    ;

expStringContent
    :   (ALPHA | ASTERISK | CHAR | COLON | DASH | DIGIT | HASH | PAREN1 | PAREN2 | PERIOD | QUOTE | SB1 | SB2 | SLASH1 | SLASH2 | SPACE | TILDE | UNDERSCORE)+
    ;

formatSequence returns [KrackdownFormat result]
    :   (
            formatBold
            {$result = $formatBold.result;}
        |
            formatItalic
            {$result = $formatItalic.result;}
        |
            formatLink
            {$result = $formatLink.result;}
        |
            formatStrikethrough
            {$result = $formatStrikethrough.result;}
        |
            formatString
            {$result = $formatString.result;}
            // NOTE: the problem here is that above formats are just appearing as formatString instead
        )
    ;

formatBold returns [KrackdownFormatBold result]
    :   (
            ASTERISK ASTERISK
            fs1 = formatSequence
            ASTERISK ASTERISK
            {$result = new KrackdownFormatBold($fs1.result);}
        |
            UNDERSCORE UNDERSCORE
            fs2 = formatSequence
            UNDERSCORE UNDERSCORE
            {$result = new KrackdownFormatBold($fs2.result);}
        )
    ;

formatItalic returns [KrackdownFormatItalic result]
    :   (
            ASTERISK
            fs1 = formatSequence
            ASTERISK
            {$result = new KrackdownFormatItalic($fs1.result);}
        |
            UNDERSCORE
            fs2 = formatSequence
            UNDERSCORE
            {$result = new KrackdownFormatItalic($fs2.result);}
        )
    ;

formatLink returns [KrackdownFormatLink result]
    @init {KrackdownExpressionString title = null;}
    :   SB1 linkText = expString SB2
        PAREN1 formatLinkUrl
        (
            SPACE QUOTE linkTitle = expString QUOTE
            {title = $linkTitle.result;}
        )?
        PAREN2
        {$result = new KrackdownFormatLink($formatLinkUrl.result, $linkText.result, title);}
    ;

formatLinkUrl returns [KrackdownExpressionString result]
    :   formatLinkUrlContent
        {$result = new KrackdownExpressionString($formatLinkUrlContent.text);}
    ;

formatLinkUrlContent
    :   (ALPHA | COLON | DASH | DIGIT | PERIOD | SLASH1 | UNDERSCORE)+
    ;

formatStrikethrough returns [KrackdownFormatStrikethrough result]
    :   TILDE TILDE
        formatSequence
        TILDE TILDE
        {$result = new KrackdownFormatStrikethrough($formatSequence.result);}
    ;

formatString returns [KrackdownFormatString result]
    :   expString
        {$result = new KrackdownFormatString($expString.result.getContent());}
    ;

// Lexer Rules

SPACE: ' ';
PERIOD: '.';
DASH: '-';
TILDE: '~';
QUOTE: '"';
HASH: '#';
ASTERISK: '*';
COLON: ':';
UNDERSCORE: '_';
PAREN1: '(';
PAREN2: ')';
SB1: '[';
SB2: ']';
SLASH1: '/';
SLASH2: '\\';
NEWLINE: [\r\n];
CHAR: .;
ALPHA: [a-z];
DIGIT: [0-9];