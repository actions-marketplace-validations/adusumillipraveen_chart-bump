#!/bin/sh -l
apk add curl

curl -sL https://github.com/mikefarah/yq/releases/download/3.1.0/yq_linux_amd64 -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq

git diff origin/master charts/ | grep --quiet values.yaml

if [ $? -eq 0 ]; then
  echo "Diff in values.yaml detected"
  DIFF_IN_VALUES=true
else
  DIFF_IN_VALUES=false
fi

git diff origin/master charts/ | grep --quiet Chart.yaml

if [ $? -eq 0 ]; then
  echo "Diff in Chart.yaml detected"
  DIFF_IN_CHART=true
else
  DIFF_IN_CHART=false
fi

git diff origin/master charts/ | grep --quiet requirements.yaml

if [ $? -eq 0 ]; then
  echo "Diff in Chart.yaml detected"
  DIFF_IN_REQUIREMENTS=true
else
  DIFF_IN_REQUIREMENTS=false
fi

if [[ ${DIFF_IN_VALUES} = 'false' ]] && [[ ${DIFF_IN_REQUIREMENTS} = 'false' ]] && [[ ${DIFF_IN_CHART} = 'false' ]] ; then
  echo 'No differences requiring chart version bump detected'
  exit 0
fi

git diff origin/master charts/ | grep --quiet '+version'

if [ $? -eq 0 ]; then
  echo "Chart.yaml version has been bumped :)"
else
  CHART_PATH=$(find charts -type f -iname "Chart.yaml")
  CHART_VERSION=$(yq r $CHART_PATH 'version')
  NEW_VERSION=$(echo $CHART_VERSION | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g' )
  yq w -i $CHART_PATH version $NEW_VERSION
  git commit -am "Bumping chart version"
  git push
fi