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
    :   HASH HASH SPACE charSequence
        {$result = "<h2>" + $charSequence.text + "</h2>";}
    ;

charSequence
    :   (CHAR | SPACE)+
    ;

// Lexer Rules

HASH: '#';
NEWLINE: [\r\n]+;
SPACE: ' ';
CHAR: .;