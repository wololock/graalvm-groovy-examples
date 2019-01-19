#!/bin/bash

if [ ! -f ./countlinks ]; then
    echo "Compiling the native image first..."
    ./compile-native-image.sh
fi

time ./countlinks -Djava.library.path=$JAVA_HOME/jre/lib/amd64 https://e.printstacktrace.blog
