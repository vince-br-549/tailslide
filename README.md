# Intro

![Build Status](https://github.com/SaladDais/tailslide/workflows/build/badge.svg) [![codecov](https://codecov.io/gh/SaladDais/tailslide/branch/master/graph/badge.svg?token=5BQCSA63F1)](https://codecov.io/gh/SaladDais/tailslide)


Tailslide provides an embeddable parser, AST representation, and tree walker library for
Second Life's Linden Scripting Language. These can be used as the foundation for an
LSL compiler or developing a superset of LSL.

A reference [byte-perfect LSO compiler](libtailslide/passes/lso)
and semantically equivalent [CIL compiler](libtailslide/passes/mono) are provided. Semantic
conformity with the output of LL's compilers is proven through
[extensive testcases](https://github.com/SaladDais/tailslide/tree/master/tests/scripts) and a
[fuzzer](https://github.com/SaladDais/lscript-tailslide#lscript_fuzzer).

Also provided is a CLI utility to quickly lint or optimize LSL scripts,
as well as visualize the AST of the supplied script.

If you're mainly interested in a command-line linting or optimization utility,
please see [lslint](https://github.com/Makopo/lslint) or
[LSL-PyOptimizer](https://github.com/Sei-Lisa/LSL-PyOptimizer), respectively.

# Credits
Tailslide is heavily based on the [lslint](https://github.com/pclewis/lslint)
LSL linter written by pclewis, see the [NOTICE.txt](NOTICE.txt) file for the
original README and credits.

# Build

## Linux & OSX

`cmake`, `flex` and `bison` must be installed through your system's package manager.
On OS X you _must_ install the Homebrew versions of `flex` and `bison` because the
versions provided with XCode are extremely old.

```bash
git clone https://github.com/vince-br-549/tailslide.git
cd tailslide
There appears to be a bug where the libtailslide/builtins_txt.cc does not get re-build
if you change the source file builtins.txt.  I discovered after changing builtins.txt
then run "python generate_builtins_c.py"
If you make changes to the builtins.txt file you don't have to delete the build directory, just
cd build and re issue the make.
mkdir build
cd build
cmake ..
make
```

# Windows

Not well-supported, but possible:

* Install [CMake](https://cmake.org/download/)
* Install [Flex and Bison](https://github.com/lexxmark/winflexbison/releases) somewhere in your `PATH`
* Install [MSVC for C++ 2022](https://visualstudio.microsoft.com/downloads/)

inside the cloned repo:

```batch
mkdir build
cd build
cmake -G"Visual Studio 17 2022" ..
cmake --build .
```

# Tech Overview

## Parsing

The parser behaves more or less like the one on SL's servers, quirks and all.

For example:
```
default { $$$$
    '' state_entry() {
        llOwnerSay(L"Hello
world!");
    }"
}/*{
```

is completely handled:

```
$ tailslide --show-tree tests/scripts/parser_abuse.lsl
default
{
    state_entry()
    {
        llOwnerSay("\"Hello\nworld!");
    }
}

TOTAL:: Errors: 0  Warnings: 0
script [none] (cv=) (1,1)
  ast node list [none] (cv=) (1,1)
  ast node list [none] (cv=) (1,1)
    state [none] (cv=) (1,1)
      identifier "default" [none] (cv=) (1,1)
      event handler [none] (cv=) (2,8)
        identifier "state_entry" [none] (cv=) (2,8)
        null [none] (cv=) (2,8)
        compound statement [none] (cv=) (2,22)
          statement [none] (cv=) (3,9)
            function call [none] (cv=) (3,9)
              identifier "llOwnerSay" [none] (cv=) (3,9)
              constant expression [string] (cv=string constant: "\"Hello\nworld!") (3,20)
                string constant: "\"Hello\nworld!" [string] (cv=string constant: "\"Hello\nworld!") (3,20)
```

Special attention has been paid to weird, undocumented corner cases.

## Optimizations

### Constant Folding

The constant folding implementation is currently very simple. Tailslide makes multiple
walks down the tree checking if an expression is constant, and replaces it with its value.

```
integer foo = 2;
foo = foo + 2 + 4 + 3 + 5;
```

won't currently be simplified at all due to how expressions are represented and will
require term rewriting to move non-constant parts of expressions as far to the right (left) as possible.

There are still some cases where constants may be folded but currently aren't, and some differences
in how floating point operations are folded.

### Unused Variable / Function Pruning

Any variable or function that is unused after constant folding may be pruned to save bytecode space.

### Symbol Mangling

Names of user defined functions, their parameters and globals contribute to bytecode size.
To reduce bytecode size, Tailslide can mangle user-defined symbols into more compact ones like
`_a`, `_b`, etc. This may also help with disambiguation when converting the AST to another
language with different scoping / variable shadowing rules.

This isn't the most efficient naming scheme if targeting SL in particular,
since it's better to take advantage of strings already in the constant pool.

# License
MIT, scripts used for test data (barring those added by me and those in `bugs/`) are
property of their respective owners

Serialization code based on Kai Mast's [BitStream library](https://github.com/kaimast/BitStream/blob/master/include/BitStream.h)
is included in BitStream.hh, and is licensed under the BSD 3-clause license.
