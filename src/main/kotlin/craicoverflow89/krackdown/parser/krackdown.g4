grammar krackdown;

@header
{
    import craicoverflow89.krackdown.constructs.*;
    import java.lang.StringBuilder;
}

// Parser Rules

file returns [KrackdownResult out]
    @init {StringBuilder buffer = new StringBuilder();}
    :   (
            (
                expHeader {buffer.append($expHeader.result);}
            |
                expBreak {buffer.append("<br>");}
            |
                expSequence {buffer.append($expSequence.result);}
            )
            //(NEWLINE+ | EOF)
            // NOTE: need to fix having optional EOF here and ensure it is after this block
            //       this (NEWLINE+ this)*? EOF
        )*?
        {$out = new KrackdownResult(buffer.toString());}
    ;

expBreak
    :   NEWLINE NEWLINE
    ;

expHeader returns [String result]
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

expH1 returns [String result]
    :   HASH SPACE charSequence
        {$result = "<h1>" + $charSequence.text + "</h1>";}
    ;

expH2 returns [String result]
    :   (h += HASH)+ {$h.size() == 2}?
        SPACE charSequence
        {$result = "<h2>" + $charSequence.text + "</h2>";}
    ;

expH3 returns [String result]
    :   (h += HASH)+ {$h.size() == 3}?
        SPACE charSequence
        {$result = "<h3>" + $charSequence.text + "</h3>";}
    ;

expH4 returns [String result]
    :   (h += HASH)+ {$h.size() == 4}?
        SPACE charSequence
        {$result = "<h4>" + $charSequence.text + "</h4>";}
    ;

expH5 returns [String result]
    :   (h += HASH)+ {$h.size() == 5}?
        SPACE charSequence
        {$result = "<h5>" + $charSequence.text + "</h5>";}
    ;

expH6 returns [String result]
    :   (h += HASH)+ {$h.size() == 6}?
        SPACE charSequence
        {$result = "<h6>" + $charSequence.text + "</h6>";}
    ;

expSequence returns [String result]
    @init {StringBuilder buffer = new StringBuilder();}
    :   fs1 = formatSequence {buffer.append($fs1.result);}
        (
            fs2 = formatSequence {buffer.append($fs2.result);}
        )*
        {$result = buffer.toString();}
    ;

formatSequence returns [String result]
    :   (
            formatBold {$result = $formatBold.result;}
        |
            formatItalic {$result = $formatItalic.result;}
        |
            formatStrikethrough {$result = $formatStrikethrough.result;}
        |
            formatLink {$result = $formatLink.result;}
        |
            charSequence {$result = $charSequence.text;}
        )
    ;

formatBold returns [String result]
    :   ASTERISK ASTERISK
        formatSequence
        ASTERISK ASTERISK
        {$result = "<b>" + $formatSequence.result + "</b>";}
    ;

formatItalic returns [String result]
    :   ASTERISK
        formatSequence
        ASTERISK
        {$result = "<i>" + $formatSequence.result + "</i>";}
    ;

formatStrikethrough returns [String result]
    :   TILDE TILDE
        formatSequence
        TILDE TILDE
        {$result = "<s>" + $formatSequence.result + "</s>";}
    ;

formatLink returns [String result]
    @init
    {
        StringBuilder buffer = new StringBuilder();
        String title = null;
    }
    :   SB1 linkText = charSequence SB2
        PAREN1 formatLinkUrl
        (
            SPACE QUOTE linkTitle = charSequence QUOTE
            {title = $linkTitle.text;}
        )?
        PAREN2
        {$result = new KrackdownLink($formatLinkUrl.text, $linkText.text, title).toHTML();}
    ;

formatLinkUrl
    :   (ALPHA | COLON | DASH | DIGIT | PERIOD | SLASH1 | UNDERSCORE)+
    ;

charSequence
    :   //(ALPHA | ASTERISK | CHAR | COLON | DASH | DIGIT | HASH | PAREN1 | PAREN2 | PERIOD | QUOTE | SB1 | SB2 | SLASH1 | SLASH2 | SPACE | TILDE | UNDERSCORE)+
        (CHAR | SPACE)+
        // NOTE: we must allow HASH but it could interfere with header recognition
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