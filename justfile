set shell := ["bash", "-c"]

export DOCKER_BUILDKIT := "1"

format:
  for file in */packages; do sort -o "${file}" "${file}"; done
  sort -o install.conf install.conf

build os:
  docker build \
  --file {{os}}/Dockerfile \
  --tag aiko-dev-{{os}}:latest \
  .
  docker tag aiko-dev-{{os}}:latest "aiko-dev-{{os}}:$(date "+%Y-%m-%d")"

run os: (build os)
  docker run --rm --interactive --tty  aiko-dev-{{os}}:latest
