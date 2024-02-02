set -e

VUL_COMMIT=$(git log --all --diff-filter=A --pretty=format:"%h" -- testa)

if [ "$(echo $VUL_COMMIT | md5sum | cut -d' ' -f1)" = "$(cat test/vul_hash)" ]
then
<<<<<<< HEAD
<<<<<<< HEAD
  B=$(git branch --all --contains 5c6a2de)
  echo "The vulnerable commit found in your repo: $B"
=======
  echo "Vulnerable commit found in your repo: $VUL_COMMIT"
>>>>>>> 9a7581b (init commit)
=======
  B=$(git branch --all --contains 5c6a2de)
  echo "The vulnerable commit found in your repo: $B"
>>>>>>> 95c7e64 (start here)
  exit 1
fi

C=$(cat test/vul_hash-1)
if [ "$( git cat-file -t $C)" != "commit" ]
then
  echo "The commit before the vulnerable commit ($C) was not found"
  exit 1
fi

<<<<<<< HEAD
<<<<<<< HEAD
git checkout feature/upgrade_angular_version
=======
git checkout $(git branch --contains $C)
>>>>>>> 9a7581b (init commit)
=======
git checkout feature/upgrade_angular_version
>>>>>>> 95c7e64 (start here)
files=("some_file" "some_other_file" "some_file2" "some_other_file2")

for file in "${files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "File $file expected to be found in the branch"
<<<<<<< HEAD
<<<<<<< HEAD
    exit 1
=======
>>>>>>> 9a7581b (init commit)
=======
    exit 1
>>>>>>> 95c7e64 (start here)
  fi

  if [[ "$(echo $file | md5sum | cut -d' ' -f1)" != "$(cat $file)" ]]; then
    echo "The content of $file has changed comparing to the original file"
<<<<<<< HEAD
<<<<<<< HEAD
    exit 1
=======
>>>>>>> 9a7581b (init commit)
=======
    exit 1
>>>>>>> 95c7e64 (start here)
  fi
done

git checkout main

<<<<<<< HEAD
<<<<<<< HEAD
echo -e "\n\nWell done! the repo is clean from vulnerabilities"
=======
echo "Well done! the repo is clean from vulnerabilities"
>>>>>>> 9a7581b (init commit)
=======
echo -e "\n\nWell done! the repo is clean from vulnerabilities"
>>>>>>> 95c7e64 (start here)
