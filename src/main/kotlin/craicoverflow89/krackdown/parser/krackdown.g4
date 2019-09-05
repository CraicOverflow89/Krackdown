grammar krackdown;

@header
{
    import craicoverflow89.krackdown.constructs.*;
}

// Parser Rules

file returns [KrackdownResult out]
    :   content = fileContent EOF
        {
            $out = new KrackdownResult($content.result);
        }
    ;

fileContent returns [String result]
    :   (
            expH1
            {
                $result = $expH1.result;
            }
        )
        //CHAR*?
    ;

expH1 returns [String result]
    :   HASH SPACE
        content = CHAR+
        {
            $result = "<h1>" + $content.text + "</h1>";
        }
        (NEWLINE | EOF)
    ;

// Lexer Rules

HASH: '#';
NEWLINE: [\n\r];
SPACE: ' ';
CHAR: .;