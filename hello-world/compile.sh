#!/usr/bin/env bash

if [[ -z ${GROOVY_HOME+x} ]]; then
    echo "ERROR: environment variable GROOVY_HOME is not set..."
    exit 1
fi

mkdir -p out/

GROOVY_VERSION=`groovy -version | awk '{print $3}'`

CLASSPATH=".:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar:./out/"

if [[ ! -f ./out/hello.class ]]; then
    echo "Compiling the script..."
    groovyc -d=out/ --configscript=./conf/compiler.groovy hello.groovy
fi

if [[ ! -f ./out/conf/reflect-config.json ]]; then
    echo "Prepring native-image configuration files..."
    java -agentlib:native-image-agent=config-output-dir=out/conf/ \
        -cp ${CLASSPATH} \
        hello test >/dev/null

    echo "Removing incorrect reflection classes..."
    groovy ./conf/removeFromJson.groovy out/conf/reflect-config.json java.lang.reflect.Executable
fi

echo "Compiling GraalVM native image..."

native-image --allow-incomplete-classpath \
    -H:+AllowVMInspection \
    -H:+ReportUnsupportedElementsAtRuntime \
    -H:ConfigurationFileDirectories=out/conf/ \
    --initialize-at-build-time \
    --initialize-at-run-time=org.codehaus.groovy.control.XStreamUtils,groovy.grape.GrapeIvy \
    --no-fallback \
    --no-server \
    -cp ${CLASSPATH} \
    hello &&

echo -e "\nNative image compilation done! You can try the demo now, e.g.\n\n \$ ./hello test"