> [!IMPORTANT]
> This project is part of the [DevOpsTheHardWay][DevOpsTheHardWay] course. Please [onboard the course][onboarding_tutorial] before starting. 
> 
> Before finishing this project, it's advisable to complete [any previous projects](https://github.com/alonitac/DevOpsTheHardWay?#studying-guide) if you haven't already done so.


# Git Project [![][autotest_badge]][autotest_workflow]

## Preliminaries

1. Fork this repo (read [here][fork_github] how). **Make sure you fork ALL branches, not only `main`**.
2. Clone your forked repository into a new PyCharm project (read [here][clone_pycharm] how).   

Let's get started...

## Part I: Branches 

Create the following git commit tree.
You can add any file you want in each commit, but the message for each commit must be exactly the same as denoted in the below graph (`c1`, `c2`,..., `c12`). 
Note the (lightweight) tags in commit `c4` and `c8`. 

The parent commit of `c1` must be the last commit in branch `main` after a fresh clone of this repo (commit with message `start here`). 

```mermaid
gitGraph
       commit id: "c1"
       branch arik/bugfix1
       commit id: "c10"
       commit id: "c11"
       checkout main
       commit id: "c2"
       branch john/feature1
       checkout john/feature1
       commit id: "c3"
       checkout main
       merge arik/bugfix1 tag: "v1.0.2"
       checkout john/feature1
       branch john/feature1-test
       checkout john/feature1-test
       commit id: "c5"
       checkout main
       commit id: "c6"
       checkout john/feature1
       commit id: "c7"
       checkout main
       merge john/feature1 tag: "v1.0.3"
       checkout john/feature1-test
       commit id: "c8" tag: "john-only"
       checkout main
       commit id: "c9"
```

**Notes**:

- If you've messed up the repo, you can always checkout branch main and run `git reset --hard <commit-id>` where `<commit-id>` is the commit hash from which you need to start.
- By default, your tags aren't being pushed to remote. Make sure to push your tags using the `--tags` flag in the `git push` command.

### Test it locally

```bash
git checkout main
cd test
bash branches.sh
```

## Part II: Merge conflict

**It's highly recommended to use a conflict merge tool (like the built-in one in PyCharm or VSCode).**

Your team colleagues, John Doe and Narayan Nadella, are working together on the same task. 
Each one of them is working on his own git branch. 

- John Doe developed under `origin/feature/version1` branch.
- Narayan Nadella developed under `origin/feature/version2` branch.

Both checked out from the same `main` branch. 

You decide to create a new branch called `feature/myfeature` and merge the work of John and Narayan into your branch. When done this you encountered a conflict.

1. From `mian` branch, create and checkout `feature/myfeature` branch.
2. Merge `origin/feature/version1` into your branch, take a look on the merge changes.
3. Merge `origin/feature/version2` into your branch, and resolve the conflicts according to the below guidelines:
   - The flask webserver code under `app.py` should have a total of 8 endpoints **in the following order**: `/`, `/status`, `/blog`, `/pricing`, `/contact`, `/chat`, `/services`, `/internal`.
   - Narayan mistakenly has coded a bad port number for the service, John's branch port is correct.
   - Narayan knows better than John about the price of the service.

### Test it locally

```bash
git checkout main
cd test
bash conflict.sh
```

## Part III: Pre-commit and sensitive data 

In this repo, there is a commit which contains credentials of strong identity in AWS.
The file contains the credentials might look like:

```text
AWS_ACCESS_KEY_ID=AKIA6BJMA3TKBADSHFXZ
AWS_SECRET_ACCESS_KEY=op7N48fxIFxh06ToUwZd33emso/QKZWb/2M5fgTX
```

Your goal is to find this commit, and completely remove it from the history. 

Here is an illustration of the vulnerable commit (the true branch name is not `some_branch`):

```mermaid
gitGraph
       branch some_branch
       checkout some_branch
       commit id: "commit1"
       commit id: "VULNERABLE_COMMIT"
       commit id: "commit 2"
       commit id: "commit 3"
```

And after your fix: 

```mermaid
gitGraph
       branch some_branch
       checkout some_branch
       commit id: "commit1"
       commit id: "some other commit 2"
       commit id: "some other commit 3"
```

Note that the commits coming before the vulnerable commit should remain untouched (like `commit1`),
while commit coming after the vulnerable commit might change (like `some other commit 2` and `some other commit 3`, instead of `commit 2` and `commit 3`).

Commit-wise, you are free to do whatever you wish for the commits that are coming after the vulnerable commit, as far as **the content of the branch remain the same**. 
The branch content should be identical to what it was before your fix, except the vulnerable file that was committed in the `VULNERABLE_COMMIT` commit.  

There are many approaches to solve it, some are using `git reset --hard`, `git rebase` or `git cherry-pick`. Find your preferred way.
You should find the branch contains the vulnerable data, learn its structure and data, and remove the vulnerable commit carefully, without loosing data committed in other commits. 

Since you've changed the commit history, you may be needing to `--force`fully push your fixed branch to remote. 

In order to prevent this vulnerability in the future, integrate [pre commit](https://pre-commit.com/) into your repo, and add a plugin that blocks any commits that contains AWS credentials data.
Verify that the tool is working - try to commit the below text and make sure pre-commit is blocking you.
If you were able to commit it, `git reset` your working branch to the commit before the vulnerable commit, and try again.  

### Test it locally

```bash
git checkout main
bash test/sensitive_data.sh
```

## Part IV: Git workflows and remote

[Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) is a branching model for Git that provides a structure for managing feature development and releases in a software project.
It defines specific branches for each stage of the development process and enforces rules about how and when code can be merged between them.

In the Gitflow model, the main branches are:

- `main`: This branch represents the production-ready code and should always contain the latest stable release. This branch should be protected in GitHub, no one is able to push code into it directly.
- `dev`: This branch is used for ongoing development of the application and should contain the latest features that are being worked on.
- Feature branches (starts with `feature/...`): These branches are used for developing new features and should be branched off from the `dev` branch. Once the feature is complete, it is merged back into `dev` via a **Pull Request**. If everything is ok and ready to be deployed in production, the branch owner opens a Pull Request from the branch into `main`.
- Release branches (starts with `release-*`) for preparing releases. Once the code in a release branch is stable. It is merged into both `dev` and `main`. Any necessary bug fixes for the release are done in this branch.

Your goal is to implement the Gitflow workflow in this repo. 

**Tip**: You can always start over again by deleting the `dev`, release and feature branches (also from remote if needed), and use the `git reset --hard <commit>` command to reset the `main` branch to certain commit, while `<commit>` is the commit id last before you start this question. 

1. First, create the following [protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule) in your GitHub repo:
   1. `dev` branch is not allowed to be pushed directly, only via Pull Request.
   2. `main` branch is read-only, only the release manager (you) can push it directly.

2. From `main` branch, checkout a new branch called `dev`.
3. From `dev`, create some feature branch. Commit and push some changes.
4. In your GitHub main project page, create a **Pull Request** from your feature branch into `dev`, review the PR, and finally merge it into `dev` (don't use fast-forward!).
5. In [GitHub Actions][github_actions] page, review the **Dev - build and deployment** workflow that simulates the "deployment" of your application from the `dev` branch into the **Development** environment (Enable GitHub Actions if needed).
6. Let's say you are satisfied with the results you've seen in the Development environment. Checkout branch `dev` and pull it to get an up-to-date version of the branch (mind that there was a merge-commit created by the PR merging). 
   Now, from `dev` branch, create a release branch, you can call it any name starting with `release-`. 
7. Commit additional changes to the release branch. These modifications simulate minor fixes received from QA, corrections of typos addressed by the product manager, and content specific to the release.
8. Push your release branch and observe the **Test build and deployment** workflow. This workflow simulates a "deployment" of the app from your release branch into the **Test** environment (also known as **Stage** env). Fix any issues if the job fails.
9. Once you're satisfied with results, ask your release manager (which is you) to merge your release branch into `main`, push `main` and observe how the **Prod - build and deployment** workflow, which simulates a deployment of the app to **Production**. 


## Part V: Merge two git repositories 

In a company implementing typical DevOps pipelines, different teams may be responsible for developing separate microservices of a larger application, each residing in its own Git repository.
You have been assigned the task of merging two different Git repositories, each containing separate microservice, into a single [monorepo](https://www.atlassian.com/git/tutorials/monorepos). 
The repositories were maintained by separate teams and have separate commit histories. 
Your goal is to **preserve the entire commit history** of both repositories while merging the code into a single Git repository, ensuring that the microservices remain functional and properly integrated with each other.

Merge the [GitProjectAnother](https://github.com/alonitac/GitProjectAnother.git) repo into your main [GitProject][github_repo] repo. 
The `main` branch of the resulted repo should have the following file structure:

```text
GitProject
└── serviceA/
        ├── [service A files...]
    serviceB/
        └── [service B files...]
```

### Notes

- Feel free to make changes to any files in the `GitProjectAnother` repository that are not located under the `serviceB` directory. 
- Once the history of the `GitProjectAnother` repository has been successfully merged into this repository, feel free to make any additional changes, such as moving files into different directories.  
- In case of conflicts during the merge, you should prefer this repo's version.  

### Test it locally

```bash
git checkout main
cd test
bash merge_repos.sh
```


## Submission

Time to submit your solution for testing.

1. Commit and push your changes. Make sure you push involved branches, not only `main`. 
1. In [GitHub Actions][github_actions], watch the **Project auto-testing** workflow (enable Actions if needed). 
   If there are any failures, click on the failed job and **read the test logs carefully**. Fix your solution, commit and push again.

### Share your project 

You are highly encourages to share your project with others by creating a **Pull Request**.

Create a Pull Request from your repo, branch `main` (e.g. `johndoe/GitProject`) into our project repo (i.e. `alonitac/GitProject`), branch `main`.  
Feel free to explore other's pull requests to discover different solution approaches.

As it's only an exercise, we may not approve your pull request (approval would lead your changes to be merged into our original project). 


# Good Luck

[DevOpsTheHardWay]: https://github.com/alonitac/DevOpsTheHardWay
[onboarding_tutorial]: https://github.com/alonitac/DevOpsTheHardWay/blob/main/tutorials/onboarding.md
[autotest_badge]: ../../actions/workflows/project_auto_testing.yaml/badge.svg?event=push
[autotest_workflow]: ../../actions/workflows/project_auto_testing.yaml/
[fork_github]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository
[clone_pycharm]: https://www.jetbrains.com/help/pycharm/set-up-a-git-repository.html#clone-repo
[github_actions]: ../../actions
[github_repo]: ../../

