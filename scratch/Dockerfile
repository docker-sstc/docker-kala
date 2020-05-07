FROM golang as builder

# ARG VERSION=0.3.3

WORKDIR /tmp
RUN set -ex; \
	# wget -O src.tar.gz https://github.com/ajvb/kala/archive/v${VERSION}.tar.gz; \
	# tar -xzf src.tar.gz; \
	# cd kala-${VERSION};\
# temporary build from my repo because of https://github.com/ajvb/kala/pull/211
	git clone https://github.com/up9cloud/kala.git; \
	cd kala; \
	CGO_ENABLED=0 go build -o /tmp/main

FROM scratch
COPY --from=builder /tmp/main /usr/local/bin/kala
WORKDIR /app
# change default db root path, let mount volume easier
CMD ["kala", "run", "--jobDB=boltdb", "--boltpath=/tmp"]
EXPOSE 8000
