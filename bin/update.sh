#!/usr/bin/env bash

set -euo pipefail

TOOLS_DIR="../tools"

pushd "${TOOLS_DIR}"

git pull
git reset --hard origin/master

# REVISION="$(git -C "${TOOLS_DIR}" rev-parse HEAD)"
REVISION="$(git rev-parse HEAD)"

popd

echo "Copying LICENSE"
rm LICENSE
cp -p "${TOOLS_DIR}/LICENSE" .

for pkg in diff event gocommand goroot testenv
do
  echo "Copying package golang.org/x/tools/internal/${pkg} to ./${pkg}"
  rm -rf "./${pkg}"
  cp -rp "${TOOLS_DIR}/internal/${pkg}" .
done

echo "Rewriting imports"
find . -type f -name '*.go' -print0 | xargs -0 sed -i '' 's#golang.org/x/tools/internal/#github.com/ripta/gxti/#g'

echo "Running tests"
go test ./...

echo "OK: upstream revision ${REVISION}"
