#!/usr/bin/env bash

set -euo pipefail

shellcheck --shell=bash --external-sources \
	bin/* --source-path=SCRIPTDIR \
	lib/* \
	scripts/*

shfmt --language-dialect bash --diff \
	./**/*
