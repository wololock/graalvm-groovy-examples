FROM oracle/graalvm-ce:19.2.1

ADD . /app/

ENV GROOVY_VERSION="2.5.8"
ENV GROOVY_HOME=/root/.sdkman/candidates/groovy/$GROOVY_VERSION

RUN yum install -y zip unzip
RUN gu install native-image
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    echo \"sdkman_auto_answer=true\" > $SDKMAN_DIR/etc/config && \
    sdk install groovy $GROOVY_VERSION && \
    groovy -version && \
    cd /app/ && \
    groovyc --configscript=config/compiler.groovy CountLinks.groovy && \
    sh ./compile-native-image.sh"

ENTRYPOINT bash -c "cd /app && ./countlinks.sh $0"
