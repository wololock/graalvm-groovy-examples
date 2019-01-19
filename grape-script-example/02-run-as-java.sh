#!/bin/bash

if [ -z ${GROOVY_HOME+x} ]; then
    echo "ERROR: environment variable GROOVY_HOME is not set..."
    exit 1
fi

GROOVY_VERSION=`groovy -version | awk '{print $3}'`

CLASSPATH=".:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar:$HOME/.groovy/grapes/org.jsoup/jsoup/jars/jsoup-1.11.3.jar"

if [ ! -f ./CountLinks.class ]; then
    echo "Compiling the script..."
    groovyc --configscript=config/compiler.groovy CountLinks.groovy
fi

time java -Dgroovy.grape.enable=false \
    -cp $CLASSPATH \
    CountLinks https://e.printstacktrace.blog
