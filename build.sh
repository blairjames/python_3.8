#!/usr/bin/env bash

# Generate timestamp
function timestamp () {
    date +"%Y%m%d_%H%M%S"
}

# Env Vars
source /root/.ssh/agent/root || . /root/.ssh/agent/root
declare -r NAME=python_3.8
declare -r DIR=/home/docker/$NAME
declare -r LOG=$DIR/log.build
declare -r TIMESTP=$(timestamp)

# Log and Print
function logger () {
    printf "$1\n"
    printf "$(timestamp) - $1\n" >> $LOG
}

# Exception handler
function except () {
    logger $1
    return 1
}

# Build the image using timestamp as tag.
function build() {
    logger "Starting Build.\n"
  if /usr/bin/docker build $DIR -t docker.io/blairy/$NAME:$TIMESTP --no-cache --rm --pull >> $LOG; then
    logger "Build completed successfully.\n\n"
  else
    except "Build FAILED!! Aborting.\n\n"
  fi
}

# Push to github - Triggers builds in github and Dockerhub.
function git () {
    git="/usr/bin/git -C $DIR"
    $git gc --prune
    $git pull git@github.com:blairjames/$NAME.git >> $LOG || except "git pull failed!"
    $git add --all >> $LOG || except "git add failed!"
    $git commit -a -m 'Automatic build '$TIMESTP >> $LOG || except "git commit failed!"
    $git push >> $LOG || except "git push failed!"
}

# Push the new tag to Dockerhub.
function docker_push() {
  echo "docker push command:"
  echo "docker push blairy/$NAME:$TIMESTP"
  if /usr/bin/docker push blairy/$NAME:$TIMESTP >> $LOG; then 
    logger "Docker push completed successfully.\n\n"
  else
    except "Docker push FAILED!!\n\n"
  fi
}

function main() {
  if build; then
    if git; then
      if docker_push; then
        logger "All completed successfully"
        exit 0
      fi
    fi
  fi
}

main

except "ERROR! Out of context!"
