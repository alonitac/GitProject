git checkout main
git checkout -b feature/myfeature
git merge origin/feature/version1
git merge origin/feature/version2
git add app.py
git commit -m "Resolve merge conflict"

# Path: test/conflict.sh
git checkout main
cd test
bash conflict.sh
