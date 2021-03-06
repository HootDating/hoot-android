#!/usr/bin/env bash

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
echo "Pull request. Skipping APK upload."
exit 0
fi

COMMIT_MSG="$(git log -1)"

if [[ $COMMIT_MSG != *"[apk skip]"* ]]; then
git config --global user.email "${OWL_EMAIL}"
git config --global user.name "${OWL_NAME}"

git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:@github.com" > .git/credentials

cp -R app/build/outputs/apk/debug/app-debug.apk latest.apk

git add latest.apk
git commit -F- <<EOF
Build #${TRAVIS_BUILD_NUMBER}: Update APK from CI
$COMMIT_MSG

- Hoot Hoot
[ci skip]
EOF

git branch apk-update
git checkout master
git merge apk-update
git push origin master
else
echo "[apk skip] found. Skipping APK update."
fi
