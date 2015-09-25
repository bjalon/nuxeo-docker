FROM java:8

MAINTAINER Benjamin JALON<bjalon@qastia.com>

RUN apt-get update
RUN apt-get install -y wget unzip

ENV NUXEO_ROOT_DIR ${NUXEO_ROOT_DIR:-/opt/local/nuxeo}
ENV NUXEO_USER ${NUXEO_USER:-nuxeo}

RUN ["/bin/bash", "-c", "adduser --no-create-home --disabled-password --disabled-login --system $NUXEO_USER"]

RUN ["/bin/bash", "-c", "mkdir -p $NUXEO_ROOT_DIR"]
RUN ["/bin/bash", "-c", "chown $NUXEO_USER $NUXEO_ROOT_DIR"]

USER $NUXEO_USER

ENV NUXEO_VERSION ${NUXEO_VERSION:-7.3}
RUN ["/bin/bash", "-c", "echo Nuxeo version: $NUXEO_VERSION"]





RUN echo "************** PREPARATION **************"
ENV NUXEO_SRC_DIR $NUXEO_ROOT_DIR/src
ENV NUXEO_HOME_DIR $NUXEO_ROOT_DIR/server
ENV NUXEO_CONF_DIR $NUXEO_ROOT_DIR/conf
ENV NUXEO_DATA_DIR $NUXEO_ROOT_DIR/data
ENV NUXEO_MP_THIRD_DIR $NUXEO_ROOT_DIR/mp-third
ENV NUXEO_CONF $NUXEO_CONF_DIR/nuxeo.conf

RUN ["/bin/bash", "-c", "mkdir $NUXEO_SRC_DIR"]
RUN ["/bin/bash", "-c", "mkdir $NUXEO_CONF_DIR"] 
RUN ["/bin/bash", "-c", "mkdir $NUXEO_DATA_DIR"] 
RUN ["/bin/bash", "-c", "mkdir $NUXEO_MP_THIRD_DIR"] 





RUN echo "************** DOWNLOAD **************"

WORKDIR $NUXEO_SRC_DIR

ENV NUXEO_BUNDLE_NAME nuxeo-cap-$NUXEO_VERSION-tomcat
ENV NUXEO_URL http://community.nuxeo.com/static/releases/nuxeo-$NUXEO_VERSION/$NUXEO_BUNDLE_NAME.zip

RUN ["/bin/bash", "-c", "echo Nuxeo Bundle name: $NUXEO_BUNDLE_NAME"]
RUN ["/bin/bash", "-c", "echo Nuxeo Bundle download URL: $NUXEO_URL"]

RUN ["/bin/bash", "-c", "wget $NUXEO_URL"]





RUN echo "************** INSTALLATION **************"

WORKDIR $NUXEO_ROOT_DIR

RUN ["/bin/bash", "-c", "unzip $NUXEO_SRC_DIR/$NUXEO_BUNDLE_NAME.zip"]
RUN ["/bin/bash", "-c", "ln -s $NUXEO_ROOT_DIR/$NUXEO_BUNDLE_NAME $NUXEO_HOME_DIR"]

RUN ["/bin/bash", "-c", "cp $NUXEO_HOME_DIR/bin/nuxeo.conf $NUXEO_CONF_DIR"]

#ENV nuxeo.db.name=${nuxeo.db.name:-nuxeo}
#ENV nuxeo.db.port=${nuxeo.db.port:-5233}
#ENV nuxeo.db.host=${nuxeo.db.host:-??}
#ENV nuxeo.db.user=${nuxeo.db.user:-nuxeo}
#ENV nuxeo.db.password=${nuxeo.db.password:-nuxeo}

#RUN ["/bin/bash", "-c", "printenv | grep nuxeo >> $NUXEO_CONF"

RUN ["/bin/bash", "-c", "$NUXEO_HOME_DIR/bin/nuxeoctl mp-init"]

RUN ["/bin/bash", "-c", "echo org.nuxeo.automation.trace=true >> $NUXEO_CONF"]
RUN ["/bin/bash", "-c", "echo nuxeo.wizard.done=true >> $NUXEO_CONF"]
RUN ["/bin/bash", "-c", "echo org.nuxeo.dev=true >> $NUXEO_CONF"]

ONBUILD $NUXEO_HOME_DIR/bin/nuxeoctl start

EXPOSE 8080

