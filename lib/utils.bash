#!/usr/bin/env bash

set -euo pipefail

# This is the GitHub homepage where releases can be downloaded for duckdb.
GH_REPO="https://github.com/duckdb/duckdb"
TOOL_NAME="duckdb"
TOOL_TEST="duckdb --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if duckdb is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# By default we simply list the tag names from GitHub releases.
	# Change this function if duckdb has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename urls url
	version="$1"
	filename="$2"

	urls="$(get_urls "$version")" || fail "unsupported platform: $(uname -s) $(uname -m)"

	echo "* Downloading $TOOL_NAME release $version..."
	for url in $urls; do
		if curl "${curl_opts[@]}" -o "$filename" -C - "$url"; then
			return 0
		fi
		rm -f "$filename"
	done
	fail "Could not download $TOOL_NAME $version. Tried: $(echo "$urls" | xargs echo)"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -R "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

# Print one candidate download URL per line for the current platform, most
# likely first. Returns non-zero on an unsupported platform.
#
# duckdb CLI release assets:
#  os: linux | osx | windows
#  arch:
#    linux: amd64 | arm64 (named aarch64 before v1.3.0)
#    osx: universal
# asdf-duckdb does not support windows.
get_urls() {
	local version os archs arch
	version="$1"

	case "$(uname -s)" in
	Linux)
		os="linux"
		case "$(uname -m)" in
		x86_64 | amd64) archs="amd64" ;;
		aarch64 | arm64) archs="arm64 aarch64" ;;
		*) return 1 ;;
		esac
		;;
	Darwin)
		os="osx"
		archs="universal"
		;;
	*) return 1 ;;
	esac

	for arch in $archs; do
		echo "$GH_REPO/releases/download/v${version}/duckdb_cli-${os}-${arch}.zip"
	done
}
