# nand2tetris-test-generator
Generates a test script (.tst) for the nand2tetris Hardware Simulator from a truth table.

It does not yet handle any other chips than the ALU, although I'd like it to learn to read the inputs and outputs and generate the correct `output-list` values from CLI flags. This also doesn't have any tests beyond me manually diffing the output against the provided `ALU` test scripts.

```
Usage: cmp-to-test-script.rb [options]
    -f--file FILE                    Compare file to turn into a test script
    -v, --[no-]verbose               Run verbosely
    -h, --help                       Prints this help
```

Example:

```bash
./$PATH_TO_SCRIPT/cmp-to-test-script.rb -v -f ALU-nostat.cmp > ALU-my-notstat.tst
```

## [License: MIT](/blob/main/LICENSE)
