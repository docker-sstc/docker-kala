FROM golang as builder

ARG VERSION=0.8.4

WORKDIR /tmp
RUN set -ex; \
	# wget -O src.tar.gz https://github.com/ajvb/kala/archive/v${VERSION}.tar.gz; \
	# tar -xzf src.tar.gz; \
	# mv kala-${VERSION} kala; \
	# Because of https://github.com/ajvb/kala/pull/250, temporary use my personal repo
	git clone https://github.com/up9cloud/kala.git; \
	cd kala; \
	CGO_ENABLED=0 go build -o /tmp/main

FROM debian:stable-slim
RUN set -ex; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	tini \
	curl \
	rsync \
	openssh-client \
	dnsutils \
	jq \
# Install chromium, https://github.com/web-platform-tests/results-collection/pull/268/files
	chromium \
	xvfb \
	xauth \
	; \
	ln -s /usr/bin/chromium /usr/bin/google-chrome; \
	ln -s /usr/bin/chromium /usr/bin/chromium-browser; \
# In the mean time, install all famous script languages
	curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	nodejs npm \
	python3 \
	php \
	ruby \
	lua5.3 \
	; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*

# Essentials for scripts
ENV NODE_PATH=/usr/local/lib/node_modules
RUN set -e; \
	if [ "/usr/local/lib/node_modules" != "$(npm root -g)" ]; then \
		echo >&2 "NODE_PATH invalid" && exit 2; \
	fi
# Default playwright browsers path: https://github.com/microsoft/playwright/blob/master/src/utils/registry.ts#L185
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
	PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser \
	PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 \
	PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN set -e; \
	npm -g install \
		playwright-chromium \
		puppeteer \
		puppeteer-extra \
		puppeteer-extra-plugin-stealth \
		puppeteer-extra-plugin-user-preferences \
		puppeteer-extra-plugin-user-data-dir

ENTRYPOINT ["tini", "--"]
COPY --from=builder /tmp/main /usr/local/bin/kala
COPY --from=builder /tmp/kala/webui /app/webui
WORKDIR /app
# change default db root path to /tmp, let user mount the volume easier
CMD ["kala", "serve", "--bolt-path=/tmp"]
EXPOSE 8000
