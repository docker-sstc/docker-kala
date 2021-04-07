#!/bin/bash -e

docker build -t kala -f ./all/Dockerfile .

cmd=$(cat <<-EOF
curl https://raw.githubusercontent.com/Zenika/alpine-chrome/master/with-playwright/src/useragent.js > test.js
sed -i -e "s|src/example-chromium.png|/tmp/test.png|g" test.js
node test.js
ls -al /tmp/test.png
EOF
)

docker run --rm kala bash -c "$cmd"
