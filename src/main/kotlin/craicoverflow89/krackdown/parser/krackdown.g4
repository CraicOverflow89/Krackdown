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
                expHeader {result.add($expHeader.result);}
            |
                expBreak {result.add($expBreak.result);}
            |
                expSequence {result.add($expSequence.result);}
            )
            //(NEWLINE+ | EOF)
            // NOTE: need to fix having optional EOF here and ensure it is after this block
            //       this (NEWLINE+ this)*? EOF
        )*?
        {$out = new KrackdownResult(result);}
    ;

expBreak returns [KrackdownExpressionBreak result]
    :   NEWLINE NEWLINE
        {$result = new KrackdownExpressionBreak();}
        // NOTE: seems trivial to create this here instead of file rule
        //       but could be useful later for debugging precision / context awareness
    ;

expHeader returns [KrackdownExpressionHeader result]
    :   (
            expH1 {$result = $expH1.result;}
        |
            expH2 {$result = $expH2.result;}
        |
            expH3 {$result = $expH3.result;}
        |
            expH4 {$result = $expH4.result;}
        |
            expH5 {$result = $expH5.result;}
        |
            expH6 {$result = $expH6.result;}
        )
    ;

// NOTE: since the KrackdownExpressionHeader takes a size integer, we could actually just have one rule
//       that says between one and six hashses followed by space then expString
//       and pass the int value to the constructor (see below for idea which would replace the content of the rule above)

/*expHeaderContent returns [String result]
    :   (hash += HASH)+ {$h.size() >= 1 && $h.size() <= 6}?
        SPACE expString
        {$result = new KrackdownExpressionHeader($hash.size(), $expString.result);}
    ;*/

expH1 returns [KrackdownExpressionHeader result]
    :   HASH SPACE expString
        {$result = new KrackdownExpressionHeader(1, $expString.result);}
    ;

expH2 returns [KrackdownExpressionHeader result]
    :   (h += HASH)+ {$h.size() == 2}?
        SPACE expString
        {$result = new KrackdownExpressionHeader(2, $expString.result);}
    ;

expH3 returns [KrackdownExpressionHeader result]
    :   (h += HASH)+ {$h.size() == 3}?
        SPACE expString
        {$result = new KrackdownExpressionHeader(3, $expString.result);}
    ;

expH4 returns [KrackdownExpressionHeader result]
    :   (h += HASH)+ {$h.size() == 4}?
        SPACE expString
        {$result = new KrackdownExpressionHeader(4, $expString.result);}
    ;

expH5 returns [KrackdownExpressionHeader result]
    :   (h += HASH)+ {$h.size() == 5}?
        SPACE expString
        {$result = new KrackdownExpressionHeader(5, $expString.result);}
    ;

expH6 returns [KrackdownExpressionHeader result]
    :   (h += HASH)+ {$h.size() == 6}?
        SPACE expString
        {$result = new KrackdownExpressionHeader(6, $expString.result);}
    ;

expString returns [KrackdownExpressionString result]
    :   string = (ALPHA | ASTERISK | CHAR | COLON | DASH | DIGIT | HASH | PAREN1 | PAREN2 | PERIOD | QUOTE | SB1 | SB2 | SLASH1 | SLASH2 | SPACE | TILDE | UNDERSCORE)+
        //(CHAR | SPACE)+
        // NOTE: we must allow HASH but it could interfere with header recognition
        {$result = new KrackdownExpressionString($string.text);}
    ;

expSequence returns [KrackdownExpressionSequence result]
    @init {ArrayList<KrackdownFormat> list = new ArrayList();}
    :   fs1 = formatSequence {list.add($fs1.result);}
        (
            fs2 = formatSequence {list.add($fs2.result);}
        )*
        {$result = new KrackdownExpressionSequence(list);}
    ;

formatSequence returns [KrackdownFormat result]
    :   (
            formatBold {$result = $formatBold.result;}
        |
            formatItalic {$result = $formatItalic.result;}
        |
            formatLink {$result = $formatLink.result;}
        |
            formatStrikethrough {$result = $formatStrikethrough.result;}
        |
            formatString {$result = $formatString.result;}
        )
    ;

formatBold returns [KrackdownFormatBold result]
    :   ASTERISK ASTERISK
        formatSequence
        ASTERISK ASTERISK
        // NOTE: need to also handle the UNDERSCORE alternative
        {$result = new KrackdownFormatBold($formatSequence.result);}
    ;

formatItalic returns [KrackdownFormatItalic result]
    :   ASTERISK
        formatSequence
        ASTERISK
        // NOTE: need to also handle the UNDERSCORE alternative
        {$result = new KrackdownFormatItalic($formatSequence.result);}
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
    :   url = (ALPHA | COLON | DASH | DIGIT | PERIOD | SLASH1 | UNDERSCORE)+
        {$result = new KrackdownExpressionString($url.text);}
    ;

formatStrikethrough returns [KrackdownFormatStrikethrough result]
    :   TILDE TILDE
        formatSequence
        TILDE TILDE
        {$result = new KrackdownFormatStrikethrough($formatSequence.result);}
    ;

formatString returns [KrackdownFormatString result]
    :   expString
        {$result = new KrackdownFormatString($expString.text);}
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