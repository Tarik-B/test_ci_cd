#!/usr/bin/env bash

pre_commit_hook_file="pre-commit"
source_directory=$(dirname "$0")
hooks_directory=".git/hooks"

chmod +x "$source_directory/$pre_commit_hook_file"

cp "$source_directory/$pre_commit_hook_file" "$hooks_directory/pre-commit"

exit 0