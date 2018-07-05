#!/bin/bash
set -ex

ERRORS_FILENAME=$WORKSPACE/erros.log

# This script is kicked with $1=0 
# only if "bash build_and_test.sh" has exited successfully.
if [[ $1 -eq 0 ]]; then
  BODY="Test (commit ${GIT_COMMIT}) passed in *$(uname -n)*."
else
  N_ERRORFILE_LINES=$(cat ${ERRORS_FILENAME} | wc -l)
  N_CROP=50
  BODY="Test (commit ${GIT_COMMIT}) failed in *$(uname -n)*.
\`\`\`$(head -n ${N_CROP} ${ERRORS_FILENAME})\`\`\`"

  # If the error file is too long,
  # mention that there are more lines.
  if [[ $N_ERRORFILE_LINES -gt $N_CROP ]]; then
    BODY="$BODY

... and more $(($N_ERRORFILE_LINES - $N_CROP)) lines"
  fi

fi


# BODY may contain [",\]. Escape it with jq's raw input option (-R).
# jq puts the escaped string from stdin onto the place of ".".
echo "${BODY}" |
  jq -sR "{ 
    \"commit_id\": \"${ghprbActualCommit}\",
    \"body\": . ,
    \"event\": \"COMMENT\"
  }" |
  curl -XPOST "https://api.github.com/repos/fixstars/clpy/pulls/${ghprbPullId}/reviews?access_token=${access_token}" -d @- 
