# iBATIS JPetStore (Struts 1 + iBATIS 2) from the NeoLoad training kit, on Tomcat 9 + Java 8.
# The HSQLDB 1.8 database runs in-process (file mode) instead of as a separate server.
FROM tomcat:9.0-jdk8-temurin

# Remove Tomcat's default apps; the site root redirects to the shop
RUN rm -rf /usr/local/tomcat/webapps/* \
 && mkdir -p /usr/local/tomcat/webapps/ROOT \
 && printf '<!doctype html><meta http-equiv="refresh" content="0;url=/jpetstore/"><a href="/jpetstore/">JPetStore</a>\n' \
      > /usr/local/tomcat/webapps/ROOT/index.html

# Behind a TLS-terminating proxy (Render etc.): trust X-Forwarded-Proto so redirects stay on https
RUN sed -i 's#</Host>#  <Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="x-forwarded-proto" />\n      </Host>#' \
      /usr/local/tomcat/conf/server.xml

COPY jpetstore /usr/local/tomcat/webapps/jpetstore
COPY db /usr/local/tomcat/jpetstore-db

# Fit in a 512 MB free instance
ENV CATALINA_OPTS="-Xms96m -Xmx300m -XX:+UseSerialGC -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
