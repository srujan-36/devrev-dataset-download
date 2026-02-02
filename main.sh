#!/bin/bash

set -eo

export DEVREV_TOKEN=$(devrev profiles get-token access)

if [ -z "$1" ]; then
  echo "Usage: $0 <dataset_id>"
  exit 1
fi

DATASET_OUT="$(curl --location 'https://api.devrev.ai/internal/oasis.data.fetch' \
--header 'accept: application/json, text/plain, */*' \
--header 'accept-language: en-US' \
--header "authorization: $DEVREV_TOKEN" \
--header 'Content-Type: application/json' \
--silent \
--data "{\"dataset_id\": \"$1\"}")"

echo "$DATASET_OUT" | jq -r '.data[] | .display_id + "\n" + .sources[].uri'
URL=$(echo "$DATASET_OUT" | jq -r '.data[] .sources[].uri')

curl --location "$URL" \
--header 'accept-language: en-US' \
--silent \
--header "authorization: $DEVREV_TOKEN" \
--output dataset.parquet

