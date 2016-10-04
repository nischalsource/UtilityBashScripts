#!/bin/bash

## Prints out help on how to use this script
function  echoHelp () {
cat <<-END
Usage:
------
   -h | --help
     Display this help
   -b | --branch)
     Name of the branch to forward integrate master/release into
   -m | --master )
     Master branch as merge source
   -r | --release )
     Release branch as merge source

END
}


## Checks for Parameters
printf "STEP 1: Check for Parameters\n"
if [ $# -eq 0 ]; then
    printf "No arguments specified. Try -h for help\n\n"
    echoHelp
    exit;
fi


## Processes Parameters
while [ ! $# -eq 0 ]
do
    case $1 in
         -b | --branch)
            branch=$2
            printf "The branch name value is: \t\t\t\t %s \n" $branch
            shift 2 ;;
         -m | --master)
            master=true
            printf "The selected branch will be merged into the master branch is.\n"
            shift 2 ;;
         -r | --release)
            release=true
            printf "The selected branch will be merged into the release branch is.\n"
            shift 2 ;;
         \? | --help)
           echoHelp
           exit 0;
    esac
done

## Checks for Required Parameters
if [[ -z $branch  || ( -z $master  ||  -z $release ) ]]; then
    printf "Not enough arguments specified. Try -h for help\n\n"
    echoHelp
    exit 1;
fi

## Load either release or master branch name
if [ -n $master ] && [ -n $release ]; then
printf "Too many arguments specified. Specify either -m or -r , not both.  Try -h for help\n\n"
    echoHelp
    exit 1;
fi


## Load either release or master branch name
if [ -n $master ]; then
    sourceBranch=master
elif [ -n $$release ]; then
    sourceBranch=release
else
    printf "Error with -m & -r arguments specified. Try -h for help\n\n"
    echoHelp
    exit 1;
fi


previousBranch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')



## Stash Changes
modifiedFiles=`git status | grep "modified"`
doUnstash=0
if [ -n "$modifiedFiles" ]
then
    echo "Stashing local changes on '${branch}'..."
    doUnstash=1
    git stash save -q 'Stashing for FI'
fi



## Ensure origin/Branch is uptodate
git checkout . -q
git checkout master -q
git pull -q
git branch | grep $branch >/dev/null 2>&1
if [ $? != 0 ]
then
    echo "Setting up branch '${branch}'..."
    git checkout -b $branch -t "origin/${branch}" -q
    git push origin $branch -q
else
    echo "Switching to branch '${branch}'..."
    git checkout $branch -q
fi
git pull -q origin $branch



## Forward Integrate sourcebranch into featureBranch
printf "Forward integrating %s into %s\n\n" $sourceBranch $branch
git merge $sourceBranch -m "$branch - Forward integrated master"



## Detect Merge Conflicts
conflict=$(git status | grep "unmerged")

if [ -n $conflict ]; then
    echo "######################################################"
    echo
    echo "Forward Integration of ${branch} has conflicts"
    echo "Please review in you favorite IDE"
    if [ $doUnstash -eq 1 ]
    then
        echo "######################################################"
        echo "Please note that you had local changes that have been stashed."
        echo "After resolving conflicts of FI, you can restore changes with this command:"
        echo "git stash pop"
    fi
    echo
    echo "######################################################"
    exit 1
fi


## Push Merged Branch back to Origin
git push origin $branch
git checkout $previousBranch


## Reapply Git Stash
if [ $doUnstash -eq 1 ]; then
    conflict=`git stash pop | grep "conflict"`

    echo "Restoring your previous local changes to '${branch}'..."

    if [ -n "$conflict" ]
    then
        echo "######################################################"
        echo
        echo "Restoring your previous changes to '${previousBranch}' has conflicts"
        echo "Please review in you favorite IDE"
        echo
        echo "######################################################"
        exit 1
    fi
fi

printf "***** END *****\n\n"
