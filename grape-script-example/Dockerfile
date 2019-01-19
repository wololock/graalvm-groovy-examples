FROM oracle/graalvm-ce:1.0.0-rc11

ADD . /app/

ENV GROOVY_HOME=/root/.sdkman/candidates/groovy/2.5.2

RUN yum install -y zip unzip
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    echo \"sdkman_auto_answer=true\" > $SDKMAN_DIR/etc/config && \
    sdk install groovy 2.5.2 && \
    groovy -version && \
    cd /app/ && \
    groovyc --configscript=config/compiler.groovy CountLinks.groovy && \
    sh ./compile-native-image.sh"

ENTRYPOINT bash -c "cd /app && ./countlinks.sh $0"
