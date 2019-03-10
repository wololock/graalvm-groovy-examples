#!/usr/bin/env bash

if [[ -z ${GROOVY_HOME+x} ]]; then
    echo "ERROR: environment variable GROOVY_HOME is not set..."
    exit 1
fi

GROOVY_VERSION=`groovy -version | awk '{print $3}'`

CLASSPATH=".:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar"

if [[ ! -f ./hello.class ]]; then
    echo "Compiling the script..."
    groovyc --configscript=./compiler.groovy hello.groovy
fi

echo "Compiling GraalVM native image..."

native-image --allow-incomplete-classpath \
    -H:+AllowVMInspection \
    -H:+ReportUnsupportedElementsAtRuntime \
    -H:ReflectionConfigurationFiles=reflections.json \
    --delay-class-initialization-to-runtime=org.codehaus.groovy.control.XStreamUtils,groovy.grape.GrapeIvy \
    --no-server \
    -cp ${CLASSPATH} \
    hello