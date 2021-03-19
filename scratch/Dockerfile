FROM golang as builder

ARG VERSION=0.8.4

WORKDIR /tmp
RUN set -ex; \
	wget -O src.tar.gz https://github.com/ajvb/kala/archive/v${VERSION}.tar.gz; \
	tar -xzf src.tar.gz; \
	cd kala-${VERSION};\
	CGO_ENABLED=0 go build -o /tmp/main

FROM scratch
COPY --from=builder /tmp/main /usr/local/bin/kala
WORKDIR /app
# change default db root path to /tmp, let user mount the volume easier
CMD ["kala", "run", "--jobdb=boltdb", "--boltpath=/tmp"]
EXPOSE 8000
