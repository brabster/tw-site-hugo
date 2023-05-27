#!/bin/bash

IMAGE=klakegg/hugo:ext-alpine
HUGO_RUN="docker run --rm -it -p 1313:1313 -v $(pwd):/src ${IMAGE}"

docker pull $IMAGE

CMD="${HUGO_RUN} version"
HUGO_VERSION=$(${CMD} | sed 's/[v-]/~/g' | cut -d"~" -f2)
echo "Writing latest hugo version ${HUGO_VERSION} to netlify config"
sed "s/%HUGO_VERSION%/${HUGO_VERSION}/" < netlify_template.toml > netlify.toml

${HUGO_RUN} gen chromastyles --style=native > static/css/syntax.css

${HUGO_RUN} server -D
