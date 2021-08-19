#! /bin/bash

set -o nounset
set -o errexit
set -o pipefail

echo "{$GH_KEY}" > /root/.ssh/id_github

chmod 600 /root/.ssh/id_github

cat <<EOF >/root/.ssh/config
Hostname github.com
IdentityFile /root/.ssh/id_github
EOF

ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

git config --global user.email "agmsb@google.com"
git config --global user.name "Cloud Build"
git clone git@git@github.com:agmsb/env
cd env
git checkout -b candidate-${SHORT_SHA}
cp /workspace/resources.yaml /workspace/env/resources.yaml
git add .
git commit -m "Update app to image with tag ${SHORT_SHA}"
git push --set-upstream origin candidate-${SHORT_SHA}