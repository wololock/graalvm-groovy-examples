#!/bin/bash

if [[ -z ${GROOVY_HOME+x} ]]; then
    echo "ERROR: environment variable GROOVY_HOME is not set..."
    exit 1
fi

mkdir -p out/

GROOVY_VERSION=`groovy -version | awk '{print $3}'`

CLASSPATH="./out/:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar:$HOME/.groovy/grapes/org.jsoup/jsoup/jars/jsoup-1.11.3.jar"

if [[ ! -f ./out/CountLinks.class ]]; then
    echo "Compiling the script..."
    groovyc -d=out/ --configscript=./config/compiler.groovy CountLinks.groovy
fi

# Here we use native-image-agent=config-output-dir to automatically
# generate refection configuration for the native image compiler
if [[ ! -f ./out/conf/reflect-config.json ]]; then
    echo "Prepring native-image configuration files..."
    java -agentlib:native-image-agent=config-output-dir=out/conf/ \
         -Dgroovy.grape.enable=false \
        -cp ${CLASSPATH} \
        CountLinks https://e.printstacktrace.blog >/dev/null
fi

echo "Compiling native image..."

native-image -Dgroovy.grape.enable=false \
    --no-server \
    -cp "${CLASSPATH}" \
    --allow-incomplete-classpath \
    --no-fallback \
    --report-unsupported-elements-at-runtime \
    --initialize-at-build-time \
    --initialize-at-run-time=org.codehaus.groovy.control.XStreamUtils,groovy.grape.GrapeIvy \
    -H:ConfigurationFileDirectories=out/conf/ \
    --enable-url-protocols=http,https \
    CountLinks
