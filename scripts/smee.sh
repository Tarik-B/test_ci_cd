#!/usr/bin/env bash

function print_usage {
    echo "Usage: $0 [smee id]" >&2
}

if [[ $# -ne 1 ]]; then
    print_usage
    exit 23
fi

smee_id=$1

# npm install --global smee-client

smee --url https://smee.io/$smee_id --path /github-webhook/ --port 8080 &
smee --url https://smee.io/$smee_id --path /multibranch-webhook-trigger/invoke?token=jenkins --port 8080 &

wait

exit 0