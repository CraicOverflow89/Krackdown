grammar krackdown;

@header
{
    import sleepyfox89.krackdown.constructs.*;
}

// Parser Rules

file returns [KrackdownResult out]
    :   content = fileContent EOF
        {
            $out = new KrackdownResult($content.text);
        }
    ;

fileContent
    :   CHAR*?
    ;

// Lexer Rules

CHAR: .;