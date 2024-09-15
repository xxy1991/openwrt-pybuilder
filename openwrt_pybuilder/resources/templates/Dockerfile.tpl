FROM $image

COPY files/ files/
COPY packages/ packages/
COPY custom/ custom/
COPY custom-*.sh custom/
COPY docker-entrypoint.sh .
USER root
RUN chown -R buildbot:buildbot files/ packages/ custom/ docker-entrypoint.sh
USER buildbot
ENTRYPOINT [ "./docker-entrypoint.sh" ]
