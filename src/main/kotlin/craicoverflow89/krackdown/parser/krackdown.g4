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
                expH1 {buffer.append($expH1.result);}
            |
                expH2 {buffer.append($expH2.result);}
            |
                expH3 {buffer.append($expH3.result);}
            |
                expH4 {buffer.append($expH4.result);}
            |
                expH5 {buffer.append($expH5.result);}
            |
                expH6 {buffer.append($expH6.result);}
                // NOTE: can we not just encapsulate the OR items into a new parser rule
                //       and simply invoke buffer.append($newRule.result)?
            |
                expSequence {buffer.append($expSequence.result);}
            )
            (NEWLINE+ | EOF)
            // NOTE: need to fix having optional EOF here and ensure it is after this block
            //       this (NEWLINE+ this)*? EOF
        )*?
        {$out = new KrackdownResult(buffer.toString());}
    ;

expH1 returns [String result]
    :   HASH SPACE charSequence
        {$result = "<h1>" + $charSequence.text + "</h1>";}
    ;

expH2 returns [String result]
    :   (h += HASH)+ {$h.size() <= 2}?
        SPACE charSequence
        {$result = "<h2>" + $charSequence.text + "</h2>";}
    ;

expH3 returns [String result]
    :   (h += HASH)+ {$h.size() <= 3}?
        SPACE charSequence
        {$result = "<h3>" + $charSequence.text + "</h3>";}
    ;

expH4 returns [String result]
    :   (h += HASH)+ {$h.size() <= 4}?
        SPACE charSequence
        {$result = "<h4>" + $charSequence.text + "</h4>";}
    ;

expH5 returns [String result]
    :   (h += HASH)+ {$h.size() <= 5}?
        SPACE charSequence
        {$result = "<h5>" + $charSequence.text + "</h5>";}
    ;

expH6 returns [String result]
    :   (h += HASH)+ {$h.size() <= 6}?
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
    @init {StringBuilder buffer = new StringBuilder();}
    :   (
            formatBold {$result = $formatBold.result;}
        |
            formatItalic {$result = $formatItalic.result;}
        |
            formatStrikethrough {$result = $formatStrikethrough.result;}
        |
            cs2 = charSequence {$result = $charSequence.text;}
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

charSequence
    :   (CHAR | SPACE)+
    ;

// Lexer Rules

HASH: '#';
ASTERISK: '*';
TILDE: '~';
NEWLINE: [\r\n]+;
SPACE: ' ';
CHAR: .;