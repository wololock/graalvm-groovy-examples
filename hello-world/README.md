# Groovy GraalVM native image "Hello, World!" example

Tested using:

* GraalVM CE 19.0.0
* Groovy 2.5.7

Start with:

```
$ ./compile.sh
```

Expected output looks like this:

```
Compiling the script...
Prepring native-image configuration files...
Removing incorrect reflection classes...
Compiling GraalVM native image...
[hello:29765]    classlist:   2,285.58 ms
[hello:29765]        (cap):     820.91 ms
[hello:29765]        setup:   1,870.31 ms
[hello:29765]   (typeflow):  11,731.44 ms
[hello:29765]    (objects):  13,411.87 ms
[hello:29765]   (features):     661.18 ms
[hello:29765]     analysis:  26,316.66 ms
[hello:29765]     (clinit):     381.22 ms
[hello:29765]     universe:   1,075.10 ms
[hello:29765]      (parse):   2,277.81 ms
[hello:29765]     (inline):   3,217.35 ms
[hello:29765]    (compile):  18,732.12 ms
[hello:29765]      compile:  25,596.68 ms
[hello:29765]        image:   2,439.18 ms
[hello:29765]        write:     369.69 ms
[hello:29765]      [total]:  60,116.59 ms

Native image compilation done! You can try the demo now, e.g.

 $ ./hello test
```

Running compiled executable file:

```
$ ./hello test
Hello, test!
```