# Groovy script with Grape dependency example

This example was documented in the following blog post: [GraalVM with Groovy and Grape - creating native image of a standalone script](https://e.printstacktrace.blog/2019/01/graalvm-groovy-grape-creating-native-image-of-standalone-script/)

## Requirements

* GraalVM 1.0-RC11
* Groovy 2.5.2
* `GROOVY_HOME` environment variable has to be set
* `JAVA_HOME` environment variable has to be set

## Running examples

### Using `groovy` command line processor

Start with running the first example:

```bash
./01-run-as-groovy.sh 
Website https://e.printstacktrace.blog contains 96 links.

real	0m1,891s
user	0m4,360s
sys	0m0,144s
```

This script uses `groovy` command line processor to execute `CountLinks.groovy` script. 

### Using `java` command

In the second example we compile the script (using static compilation) and we execute it as a Java program.

```bash
./02-run-as-java.sh 
Website https://e.printstacktrace.blog contains 96 links.

real	0m1,229s
user	0m1,372s
sys	0m0,059s
```

As you can see the execution time in this case was reduced from `1.891s` to `1.229s`.

### Using GraalVM native image binary

In the last example we will use GraalVM binary generated with `native-image` command. Compile the native image first:

```bash
./compile-native-image.sh 
[countlinks:528]    classlist:   2,022.68 ms
[countlinks:528]        (cap):     911.93 ms
[countlinks:528]        setup:   2,369.79 ms
[countlinks:528]   (typeflow):  41,021.63 ms
[countlinks:528]    (objects): 103,134.84 ms
[countlinks:528]   (features):   1,316.05 ms
[countlinks:528]     analysis: 147,270.00 ms
[countlinks:528]     universe:   1,507.50 ms
[countlinks:528]      (parse):   4,592.82 ms
[countlinks:528]     (inline):   3,986.46 ms
[countlinks:528]    (compile):  34,415.75 ms
[countlinks:528]      compile:  45,534.55 ms
[countlinks:528]        image:   9,027.79 ms
[countlinks:528]        write:     591.78 ms
[countlinks:528]      [total]: 208,493.04 ms
``` 

Now you can run the last example:

```bash
./03-run-as-native-image.sh 
Website https://e.printstacktrace.blog contains 96 links.

real	0m0,200s
user	0m0,022s
sys	0m0,014s
```

The last example shows that we have reduced execution time from `1.229s` to `0.200s`.

[![asciicast](https://asciinema.org/a/222429.svg)](https://asciinema.org/a/222429)


## Creating a Docker image

You can also create a Docker image using the Groovy script.
The image handles compilation and native image creation, so you don't even have to have GraalVM installed on your computer.

### Building an image

```bash
docker build -t countlinks .
```

### Running `countlinks` in a new container

```bash
docker run --rm --read-only countlinks https://e.printstacktrace.blog
```

### Running `countlinks` in a running container (detached)

In this case we firstly run a container that opens `/var/log/yum.log` file and follows changes in this file with `tail -f`.
This way the container does not terminate and we can attach to it and execute commands.

```bash
docker run -d --name countlinks --rm --read-only --entrypoint "tail" countlinks -f /var/log/yum.log
```

When the container is running we can use `docker exec` to execute command.

```bash
docker exec countlinks cd /app && ./countlinks.sh https://e.printstacktrace.blog
```