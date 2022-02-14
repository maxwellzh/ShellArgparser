# example of shell parser
# there we setup two arguments, positional argument 'input'
# and an option '--output'. You can place the parser statement at 
# any line in this script.
# parser statement start
<<"PARSER"
("input", type=str, help="Input file.")
("-o", "--output", type=str, default="${input}_out",
    help="Output file. Default: <input>_out")
PARSER
# parser statement end, but arguments are not parsed yet.
opts=$(python parseopt.py $0 $*) && eval $opts || exit 1
# arguments parse done.

echo "'input' argument is $input"
echo "'--output' option is $output"

# bash test.sh ./image
# 'input' argument is ./image
# '--output' option is ./image_out

# bash test.sh ./image --output ./processed_image
# 'input' argument is ./image
# '--output' option is ./processed_image