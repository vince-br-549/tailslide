script [none] (cv=) (1,1)
  ast node list [none] (cv=) (1,1)
    global storage [none] (cv=) (1,1)
      global var [none] (cv=) (1,1)
        identifier "number" [integer] (cv=) (1,9)
        function call [integer] (cv=) (1,18)
          identifier "llGetUnixTime" [integer] (cv=) (1,18)
      null [none] (cv=) (1,1)
    global storage [none] (cv=) (2,1)
      global var [none] (cv=) (2,1)
        identifier "number" [integer] (cv=integer constant: 3) (2,9)
        constant expression [integer] (cv=integer constant: 3) (2,18)
          integer constant: 3 [integer] (cv=integer constant: 3) (2,18)
      null [none] (cv=) (2,1)
    global storage [none] (cv=) (4,1)
      global var [none] (cv=) (4,1)
        identifier "j" [vector] (cv=) (4,8)
        vector expression [vector] (cv=) (4,12)
          constant expression [integer] (cv=integer constant: 1) (4,13)
            integer constant: 1 [integer] (cv=integer constant: 1) (4,13)
          constant expression [integer] (cv=integer constant: 2) (4,15)
            integer constant: 2 [integer] (cv=integer constant: 2) (4,15)
          constant expression [string] (cv=string constant: "3") (4,17)
            string constant: "3" [string] (cv=string constant: "3") (4,17)
      null [none] (cv=) (4,1)
    global storage [none] (cv=) (5,1)
      global var [none] (cv=) (5,1)
        identifier "b" [quaternion] (cv=) (5,10)
        quaternion expression [quaternion] (cv=) (5,14)
          constant expression [integer] (cv=integer constant: 1) (5,15)
            integer constant: 1 [integer] (cv=integer constant: 1) (5,15)
          constant expression [integer] (cv=integer constant: 2) (5,17)
            integer constant: 2 [integer] (cv=integer constant: 2) (5,17)
          constant expression [integer] (cv=integer constant: 3) (5,19)
            integer constant: 3 [integer] (cv=integer constant: 3) (5,19)
          constant expression [string] (cv=string constant: "4") (5,21)
            string constant: "4" [string] (cv=string constant: "4") (5,21)
      null [none] (cv=) (5,1)
    global storage [none] (cv=) (6,1)
      global var [none] (cv=) (6,1)
        identifier "c" [quaternion] (cv=) (6,10)
        quaternion expression [quaternion] (cv=) (6,14)
          constant expression [integer] (cv=integer constant: 1) (6,15)
            integer constant: 1 [integer] (cv=integer constant: 1) (6,15)
          constant expression [integer] (cv=integer constant: 2) (6,17)
            integer constant: 2 [integer] (cv=integer constant: 2) (6,17)
          constant expression [integer] (cv=integer constant: 3) (6,19)
            integer constant: 3 [integer] (cv=integer constant: 3) (6,19)
          vector expression [vector] (cv=vector constant: <1, 2, 3>) (6,21)
            constant expression [integer] (cv=integer constant: 1) (6,22)
              integer constant: 1 [integer] (cv=integer constant: 1) (6,22)
            constant expression [integer] (cv=integer constant: 2) (6,24)
              integer constant: 2 [integer] (cv=integer constant: 2) (6,24)
            constant expression [integer] (cv=integer constant: 3) (6,26)
              integer constant: 3 [integer] (cv=integer constant: 3) (6,26)
      null [none] (cv=) (6,1)
    global storage [none] (cv=) (7,1)
      global var [none] (cv=) (7,1)
        identifier "foz" [list] (cv=) (7,6)
        list expression [list] (cv=) (7,12)
          quaternion expression [quaternion] (cv=) (7,13)
            constant expression [integer] (cv=integer constant: 1) (7,14)
              integer constant: 1 [integer] (cv=integer constant: 1) (7,14)
            constant expression [integer] (cv=integer constant: 2) (7,16)
              integer constant: 2 [integer] (cv=integer constant: 2) (7,16)
            constant expression [integer] (cv=integer constant: 3) (7,18)
              integer constant: 3 [integer] (cv=integer constant: 3) (7,18)
            constant expression [string] (cv=string constant: "4") (7,20)
              string constant: "4" [string] (cv=string constant: "4") (7,20)
      null [none] (cv=) (7,1)
    global storage [none] (cv=) (9,1)
      null [none] (cv=) (9,1)
      global func [none] (cv=) (9,1)
        identifier "unused" [string] (cv=) (9,8)
        null [none] (cv=) (9,1)
        compound statement [none] (cv=) (9,18)
          setstate [none] (cv=) (10,5)
            identifier "default" [none] (cv=) (10,11)
          if [none] (cv=) (11,5)
            binary expression: '==' [integer] (cv=integer constant: 1) (11,9)
              constant expression [integer] (cv=integer constant: 1) (11,9)
                integer constant: 1 [integer] (cv=integer constant: 1) (11,9)
              constant expression [integer] (cv=integer constant: 1) (11,14)
                integer constant: 1 [integer] (cv=integer constant: 1) (11,14)
            compound statement [none] (cv=) (11,17)
              setstate [none] (cv=) (12,9)
                identifier "default" [none] (cv=) (12,15)
              return [none] (cv=) (13,9)
                null [none] (cv=) (13,9)
            null [none] (cv=) (11,5)
    global storage [none] (cv=) (17,1)
      null [none] (cv=) (17,1)
      global func [none] (cv=) (17,1)
        identifier "test" [string] (cv=) (17,8)
        function decl [none] (cv=) (17,13)
          identifier "a" [integer] (cv=) (17,21)
          identifier "v" [vector] (cv=) (17,31)
        compound statement [none] (cv=) (17,34)
          declaration [none] (cv=) (18,5)
            identifier "q" [string] (cv=string constant: "") (18,12)
            null [none] (cv=) (18,5)
          return [none] (cv=) (19,5)
            lvalue expression {foldable} [vector] (cv=) (19,12)
              identifier "v" [vector] (cv=) (19,12)
  ast node list [none] (cv=) (1,1)
    state [none] (cv=) (22,1)
      identifier "default" [none] (cv=) (22,1)
      event handler [none] (cv=) (24,5)
        identifier "state_entry" [none] (cv=) (24,5)
        event decl [none] (cv=) (24,17)
          identifier "param" [integer] (cv=) (24,25)
        compound statement [none] (cv=) (24,32)
          declaration [none] (cv=) (25,9)
            identifier "number" [integer] (cv=) (25,17)
            constant expression [string] (cv=string constant: "hello") (25,26)
              string constant: "hello" [string] (cv=string constant: "hello") (25,26)
          statement [none] (cv=) (26,9)
            null [none] (cv=) (26,9)
          statement [none] (cv=) (27,9)
            binary expression: '==' [integer] (cv=integer constant: 1) (27,9)
              list expression [list] (cv=list constant: 1 entries) (27,9)
                constant expression [integer] (cv=integer constant: 1) (27,10)
                  integer constant: 1 [integer] (cv=integer constant: 1) (27,10)
              list expression [list] (cv=list constant: 1 entries) (27,16)
                constant expression [integer] (cv=integer constant: 2) (27,17)
                  integer constant: 2 [integer] (cv=integer constant: 2) (27,17)
          statement [none] (cv=) (28,9)
            binary expression: '=' [integer] (cv=) (28,9)
              lvalue expression {foldable} [integer] (cv=) (28,9)
                identifier "number" [integer] (cv=) (28,9)
              lvalue expression {foldable} [integer] (cv=) (28,18)
                identifier "number" [integer] (cv=) (28,18)
          statement [none] (cv=) (29,9)
            binary expression: '=' [error] (cv=) (29,9)
              lvalue expression {not foldable} [error] (cv=) (29,9)
                identifier "str" [error] (cv=) (29,9)
              constant expression [string] (cv=string constant: "hi!") (29,15)
                string constant: "hi!" [string] (cv=string constant: "hi!") (29,15)
          statement [none] (cv=) (30,9)
            function call [none] (cv=) (30,9)
              identifier "llSay" [none] (cv=) (30,9)
              constant expression [integer] (cv=integer constant: 0) (30,15)
                integer constant: 0 [integer] (cv=integer constant: 0) (30,15)
              lvalue expression {foldable} [error] (cv=) (30,18)
                identifier "number" [integer] (cv=) (30,18)
                identifier "x" [none] (cv=) (30,18)
          statement [none] (cv=) (31,9)
            function call [error] (cv=) (31,9)
              identifier "LLsay" [error] (cv=) (31,9)
              constant expression [integer] (cv=integer constant: 0) (31,15)
                integer constant: 0 [integer] (cv=integer constant: 0) (31,15)
              function call [error] (cv=) (31,18)
                identifier "llListToString" [error] (cv=) (31,18)
                list expression [list] (cv=) (31,33)
                  null [none] (cv=) (31,33)
          statement [none] (cv=) (32,9)
            function call [string] (cv=) (32,9)
              identifier "test" [string] (cv=) (32,9)
              constant expression [integer] (cv=integer constant: 1) (32,14)
                integer constant: 1 [integer] (cv=integer constant: 1) (32,14)
              constant expression [string] (cv=string constant: "hi") (32,17)
                string constant: "hi" [string] (cv=string constant: "hi") (32,17)
          jump [none] (cv=) (33,9)
            identifier "number" [error] (cv=) (33,14)
          jump [none] (cv=) (34,9)
            identifier "label" [none] (cv=) (34,14)
          jump [none] (cv=) (35,9)
            identifier "label" [none] (cv=) (35,14)
          label [none] (cv=) (36,9)
            identifier "label" [none] (cv=) (36,10)
          return [none] (cv=) (37,9)
            lvalue expression {not foldable} [integer] (cv=) (37,16)
              identifier "number" [integer] (cv=) (37,16)
          setstate [none] (cv=) (38,9)
            identifier "default" [none] (cv=) (38,15)
          statement [none] (cv=) (40,9)
            function call [string] (cv=) (40,9)
              identifier "test" [string] (cv=) (40,9)
          statement [none] (cv=) (41,9)
            function call [string] (cv=) (41,9)
              identifier "test" [string] (cv=) (41,9)
              constant expression [integer] (cv=integer constant: 1) (41,14)
                integer constant: 1 [integer] (cv=integer constant: 1) (41,14)
              vector expression [vector] (cv=vector constant: <1, 2, 3>) (41,16)
                constant expression [integer] (cv=integer constant: 1) (41,17)
                  integer constant: 1 [integer] (cv=integer constant: 1) (41,17)
                constant expression [integer] (cv=integer constant: 2) (41,19)
                  integer constant: 2 [integer] (cv=integer constant: 2) (41,19)
                constant expression [integer] (cv=integer constant: 3) (41,21)
                  integer constant: 3 [integer] (cv=integer constant: 3) (41,21)
              constant expression [integer] (cv=integer constant: 3) (41,24)
                integer constant: 3 [integer] (cv=integer constant: 3) (41,24)
          declaration [none] (cv=) (42,9)
            identifier "z" [vector] (cv=) (42,16)
            vector expression [vector] (cv=) (42,20)
              constant expression [integer] (cv=integer constant: 1) (42,21)
                integer constant: 1 [integer] (cv=integer constant: 1) (42,21)
              constant expression [integer] (cv=integer constant: 2) (42,23)
                integer constant: 2 [integer] (cv=integer constant: 2) (42,23)
              constant expression [string] (cv=string constant: "3") (42,25)
                string constant: "3" [string] (cv=string constant: "3") (42,25)
          declaration [none] (cv=) (43,9)
            identifier "q" [quaternion] (cv=) (43,18)
            quaternion expression [quaternion] (cv=) (43,22)
              constant expression [integer] (cv=integer constant: 0) (43,23)
                integer constant: 0 [integer] (cv=integer constant: 0) (43,23)
              constant expression [integer] (cv=integer constant: 0) (43,25)
                integer constant: 0 [integer] (cv=integer constant: 0) (43,25)
              constant expression [integer] (cv=integer constant: 0) (43,27)
                integer constant: 0 [integer] (cv=integer constant: 0) (43,27)
              constant expression [string] (cv=string constant: "3") (43,29)
                string constant: "3" [string] (cv=string constant: "3") (43,29)
          declaration [none] (cv=) (44,9)
            identifier "boz" [list] (cv=) (44,14)
            list expression [list] (cv=) (44,20)
              quaternion expression [quaternion] (cv=) (44,21)
                constant expression [integer] (cv=integer constant: 1) (44,22)
                  integer constant: 1 [integer] (cv=integer constant: 1) (44,22)
                constant expression [integer] (cv=integer constant: 2) (44,24)
                  integer constant: 2 [integer] (cv=integer constant: 2) (44,24)
                constant expression [integer] (cv=integer constant: 3) (44,26)
                  integer constant: 3 [integer] (cv=integer constant: 3) (44,26)
                constant expression [string] (cv=string constant: "4") (44,28)
                  string constant: "4" [string] (cv=string constant: "4") (44,28)
          declaration [none] (cv=) (45,9)
            identifier "k" [key] (cv=string constant: "foo") (45,13)
            constant expression [string] (cv=string constant: "foo") (45,17)
              string constant: "foo" [string] (cv=string constant: "foo") (45,17)
          statement [none] (cv=) (46,9)
            function call [none] (cv=) (46,9)
              identifier "llOwnerSay" [none] (cv=) (46,9)
              binary expression: '+' [error] (cv=) (46,20)
                lvalue expression {foldable} [key] (cv=) (46,20)
                  identifier "k" [key] (cv=string constant: "foo") (46,20)
                constant expression [string] (cv=string constant: "foo") (46,24)
                  string constant: "foo" [string] (cv=string constant: "foo") (46,24)
      event handler [none] (cv=) (50,5)
        identifier "touch_start" [none] (cv=) (50,5)
        null [none] (cv=) (50,5)
        compound statement [none] (cv=) (50,19)
          null [none] (cv=) (50,19)
      event handler [none] (cv=) (53,5)
        identifier "at_target" [none] (cv=) (53,5)
        event decl [none] (cv=) (53,15)
          identifier "i" [integer] (cv=) (53,23)
          identifier "v" [vector] (cv=) (53,33)
          identifier "s" [string] (cv=) (53,43)
        compound statement [none] (cv=) (53,46)
          null [none] (cv=) (53,46)
