Git Related Stuff
-----------------

 - Selectively add changes (patch based add)

    ```
     git add -p file.c
    ```

 - Show "remote" repos

    ```
     git remote -v
    ```

 - Create a secondary ("alternate") remote repo

    ```
     git remote add tjnalt <URL_FOR_REMOTE>
    ```

   Example:
    ```
     $ git add tjnalt https://github.com/naughtont3/ompi.git
     $ git remote -v
     origin  https://github.com/open-mpi/ompi.git (fetch)
     origin  https://github.com/open-mpi/ompi.git (push)
     tjnalt  https://github.com/naughtont3/ompi.git (fetch)
     tjnalt  https://github.com/naughtont3/ompi.git (push)

    ```

 - Push changes to an "alternate" remote repo

    ```
     git push -u tjnalt my-branch-name
    ```

 - Clone central repo and then track bracn in an "alt" repo

    ```
     git remote add tjnalt <REPO-PATH>
     git remote -v
     git branch -a
     git fetch tjnalt
     git branch -a
       # See new branches of other remote
     git checkout -t -b tjn-new-feature-1 tjnalt/tjn-new-feature-1
       # now our 'tjn-new-feature-1' branch is local and tracking upstream ('tjnalt') repo
    ```

 - Integration of branch changes to master branch (steps)

    ```
     git checkout master
     git pull --rebase
     git checkout -b tjn-master-feature1-int
     git branch -a
       # see that we are now in integration branch 'tjn-master-featureFoo1-int'

       # merged our featureFoo1 branch into integration branch 
     git merge tjn-featureFoo1
    ```

 - Tagging: Show tags

    ```
     git tag -l 
    ```

 - Tagging: Create a tag

    ```
     git tag -a v1.4 -m "my version 1.4"
    ```

 - Pull-Request: Fetch a pending pull-request (PR) for local testing

    ```
     git fetch origin pull/<PR#>/head:pr-<PR#>-mybranch
     git checkout pr-<PR#>-mybranch
    ```

 - Setup Name and Email for Git usage (see also: `$HOME/.gitconfig`)

    ```
     git config --global user.name "John Public"
     git config --global user.email "jpublic@example.org"
    ```

 - Commit Signoff (requires Name/Email setup)

    ```
     git commit --signoff
    ```

 - Commit Signoff for previously commited change (requires Name/Email setup)

    ```
     git commit --amend --signoff
    ```

    - **NOTE** Results in a new commit hash (SHA#) so exercise care with
               public contributions.  If already pushed to remote
               repository, then will require a `--force` push.  Generally
               should avoid **force** pushes on ANY publicly shared changes.

 - Cherry picking

    ```
     git cherry-pick -b newbranch <SHA#>
    ```

    - **NOTE** Cherry-picking changes the commit hash (SHA#), resulting
               in a new/different commit hash (SHA#).  Therefore these are
               only manually identifable by commit message or close 
               inspection of changeset.  (Changes are different git commits!)

