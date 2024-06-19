#!/bin/bash

set -e

CRATE_NAME=$(grep '^name =' Cargo.toml | sed -E 's/name = "(.*)"/\1/')
CRATE_VERSION=$(grep '^version =' Cargo.toml | sed -E 's/version = "(.*)"/\1/')

# Check if the crate version already exists on crates.io
RESPONSE=$(curl -s https://crates.io/api/v1/crates/$CRATE_NAME)

if echo "$RESPONSE" | jq -e ".versions | map(select(.num == \"$CRATE_VERSION\")) | length > 0" > /dev/null; then
  echo "Crate $CRATE_NAME version $CRATE_VERSION already exists on crates.io. Skipping publish."
  exit 1
else
  echo "Crate $CRATE_NAME version $CRATE_VERSION does not exist on crates.io. Proceeding to publish."
fi

## if: steps.check_version.outcome == 'success'