touch file1.txt
echo "file1" > file1.txt
git add file1.txt
git commit -m "c1"
git checkout -b arik/bugfix1
touch file2.txt
echo "file2" > file2.txt
git add file2.txt
git commit -m "c10"
echo "wefweewfw" >> file2.txt
git add file2.txt
git commit -m "c11"
git checkout main
touch file3.txt
echo "file3" > file3.txt
git add file3.txt
git commit -m "c2"
git checkout -b john/feature1
touch file4.txt
echo "file4" > file4.txt
git add file4.txt
git commit -m "c3"
git checkout main
git merge arik/bugfix1
git tag v1.0.2
git push --tags
git checkout john/feature1
git checkout -b john/feature1-test
touch file5.txt
echo "file5" > file5.txt
git add file5.txt
git commit -m "c5"
git checkout main
touch file6.txt
echo "file6" > file6.txt
git add file6.txt
git commit -m "c6"
git checkout john/feature1
touch file7.txt
echo "file7" > file7.txt
git add file7.txt
git commit -m "c7"
git checkout main
git merge john/feature1
git tag v1.0.3
git push --tags
git checkout john/feature1-test
touch file8.txt
echo "file8" > file8.txt
git add file8.txt
git commit -m "c8"
git tag john-only
git push --tags
git checkout main
touch file9.txt
echo "file9" > file9.txt
git add file9.txt
git commit -m "c9"

# Path: git%2Bbranches.sh -> test%2Bbranches.sh -> branches.sh 
git checkout main
cd test
bash branches.sh
