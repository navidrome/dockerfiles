#!/bin/zsh

# Latest GoLang version

# URL of the GoLang releases JSON page
url="https://go.dev/dl/?mode=json"

# Use curl to fetch the JSON data and jq to parse it
latest_version=$(curl -s $url | jq -r '.[0].version')
latest_version_sha256=$(curl -s $url | jq -r '.[0].files[] | select(.os=="linux" and .arch=="amd64" and .kind=="archive") | .sha256')

# Print the results
echo "#### Go ####"
echo "Latest Version: $latest_version"
echo "SHA256 Checksum: $latest_version_sha256"


# Latest GoReleaser version

# GitHub API URL for the latest GoReleaser release
url="https://api.github.com/repos/goreleaser/goreleaser/releases/latest"

# Use curl to fetch the JSON data and jq to parse it
latest_version=$(curl -s $url | jq -r '.tag_name')
checksums_url=$(curl -s $url | jq -r '.assets[] | select(.name == "checksums.txt") | .browser_download_url')

# Print the version
echo
echo "#### GoReleaser ####"
echo "Latest Version: $latest_version"

# Download and extract the first SHA256 checksum for the Linux x86_64 version
if [ -n "$checksums_url" ]; then
    sha=$(curl -sL "$checksums_url" | grep 'goreleaser_Linux_x86_64.tar.gz' | head -1 | awk '{print $1}')
    echo "SHA256 Checksum: $sha"
else
    echo "Checksums file URL not found."
fi
