set -ex

apk add curl

curl -sL https://github.com/mikefarah/yq/releases/download/3.1.0/yq_linux_amd64 -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq