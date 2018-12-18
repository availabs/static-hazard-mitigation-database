#!/bin/bash

set -e

pushd "$( dirname "${BASH_SOURCE[0]}")" >/dev/null

docker-compose up -d hazmit_db

popd >/dev/null
