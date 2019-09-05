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
                charSequence {buffer.append($charSequence.text);}
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

charSequence
    :   (CHAR | SPACE)+
    ;

// Lexer Rules

HASH: '#';
NEWLINE: [\r\n]+;
SPACE: ' ';
CHAR: .;