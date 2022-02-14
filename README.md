# ShellArgparser
A shell argparse tool based on python argparse module.

# Install

1. python >= 3 is required;
2. Download the script `parseopt.py` to any of your directory.

# Usage

In the shell script, add parser information as in python. e.g.

**python-styled parser**

```python3
...
parser.add_argument("input", type=str, help="Input file.")
parser.add_argument("-o", "--output", type=str, default="${input}_out", 
    help="Output file. Default: <input>_out")
```
**shell parser** `test.sh`
```bash
<<"PARSER"
("input", type=str, help="Input file.")
("-o", "--output", type=str, default="${input}_out",
    help="Output file. Default: <input>_out")
PARSER
opts=$(python parseopt.py $0 $*) && eval $opts || exit 1
```

Now have a try

```bash
$ bash test.sh
usage: test.sh [-h] [-o OUTPUT] input
test.sh: error: the following arguments are required: input

$ bash test.sh -h
usage: test.sh [-h] [-o OUTPUT] input

positional arguments:
  input                 Input file.

optional arguments:
  -h, --help            show this help message and exit
  -o OUTPUT, --output OUTPUT
                        Output file. Default: <input>_out
```

# Interpretation of shell parser

Just in case if you're interested in the implementation. Here is the process

1. `$(python parseopt.py $0 $*)` command run the python script in the shell script, `$0` is the name of the script (`test.sh` here); `$*` indicate all arguments passed to `test.sh` (such as `-h`)
2. In `parseopt.py`, the program searches for control flags `<<"PARSER"` and `PARSER`, which represent the start and the end of argument parser respectively, and return the wrapped content to the next step.
3. The program searches bracket pairs `()` to get the argument parser string. Python interpreter function `eval` is used to resolve the strings and build the parser.
4. Then all arguments (passed by `$*`) are resolved by the parser, which tells if there is any missing positional argument, unknown option or `-h, --help`.
5. If no error is raised at step 4, the python script writes arguments and their values to the `sys.stdout` as
    ```
    export input=<input>; export output=<output>; ...
    ```
    which is then assigned to shell variable `$opts`
6. `eval $opts` in shell scripts sets up all the arguments, so them can be used in following lines.