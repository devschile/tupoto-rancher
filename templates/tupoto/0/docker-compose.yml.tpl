---
version: '2'

services:
  haproxy:
    image: rancher/lb-service-haproxy:v0.7.9
    ports:
      - '${HTTP_PORT}:80/tcp'
      - '${HTTPS_PORT}:443/tcp'
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
      {{- if ne .Values.HAPROXY_HOST_LABEL ""}}
      io.rancher.scheduler.affinity:host_label: ${HAPROXY_HOST_LABEL}
      {{- end}}

  shortener:
    image: '${SHORTENER_IMAGE}'
    environment:
      REDIS_URI: redis://redis/0
      {{- if ne .Values.SENTRY_TOKEN ""}}
      SENTRY_TOKEN: ${SENTRY_TOKEN}
      {{- end}}
    stdin_open: true
    tty: true
    links:
      - redis:redis
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.hostname_override: container_name
      {{- if ne .Values.SHORTENER_HOST_LABEL ""}}
      io.rancher.scheduler.affinity:host_label: ${SHORTENER_HOST_LABEL}
      {{- end}}

  redis:
    image: '${REDIS_IMAGE}'
    stdin_open: true
    {{- if ne .Values.VOLUME_NAME ""}}
    volumes:
      - ${VOLUME_NAME}:/data
    {{- end}}
    tty: true
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.hostname_override: container_name
      {{- if ne .Values.REDIS_HOST_LABEL ""}}
      io.rancher.scheduler.affinity:host_label: ${REDIS_HOST_LABEL}
      {{- end}}
