#!/bin/bash

git filter-branch -f --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "Eduardo Otubo" ];
        then
                GIT_COMMITTER_NAME="Eduardo Otubo";
                GIT_AUTHOR_NAME="Eduardo Otubo";
                GIT_COMMITTER_EMAIL="eduardo.otubo@gmail.com";
                GIT_AUTHOR_EMAIL="eduardo.otubo@gmail.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
