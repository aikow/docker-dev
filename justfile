set shell := ["bash", "-c"]

export DOCKER_BUILDKIT := "1"

format:
  for file in */packages; do sort -o "${file}" "${file}"; done
  sort -o install.conf install.conf

build os:
  docker build --file {{os}}/Dockerfile --tag "aiko-dev-{{os}}:$(date "+%Y-%m-%d")" .

run os: (build os)
  docker run --rm --interactive --tty \
  "$(docker image ls --format "{{{{.Repository}}:{{{{.Tag}}" | grep "^aiko-dev-{{os}}:" | head -n1)"
