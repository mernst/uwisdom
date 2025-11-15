# Continuous integration services


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


To avoid unnecessary CI slowdowns, work on a branch in your own fork, and
don't create a pull request until you think the code is ready.

CircleCI, GitHub Actions, and Travis-CI allocate resources per GitHub
organization/account.  (Azure Pipelines allocates resources depending on the
Microsoft user ID that created the Azure Pipeline.)  All of these provide only a
certain number of CPUs, and they additionally throttle work based on CPU usage
per day/month/whatever.

Thus, an efficient way to work is to create a branch on your own fork, iterate
until it passes CI, and only then open a pull request.  Working on the master
fork, or creating a pull request too early, causes all the branches and pull
requests to compete with one another for the same CI resources.  This effect
goes double for some CI systesm, which run CI twice for each pull request, but
only once for each branch.


Comparison of CI systems:

* Azure Pipelines gives the largest number of concurrent runners and therefore
  its throughput is highest.  (10 parallel jobs, each of up to 360 minutes, with no CPU limit.)
  However, this is not available for free to private repositories, and for
  public repositories parallelism is disabled by default -- you have to send
  email to ask for it.  The documentation of Azure Pipelines is also probably
  the best.
* CircleCI has the lowest latency -- it starts jobs running very quickly after
  being triggered.  It allows up to 30 parallel jobs, with 30,000 free
  "credits" (5-20 credits = 1 minute, so 25-100 hours) per month.
* GitHub Actions is easiest to set up:  just commit a file to your GitHub
  repository.  It has very low monthly usage limits.  It does not permit
  rerunning only failing jobs:  you have to rerun them all, which is bad if you
  have flaky tests, and all tests are sometimes flaky due to network problems.
* Travis-CI was once the state of the art, but it doesn't seem well maintained
  any more.  The last time I checked, its infrastructure was rather old, and
  other systems now have more features.


## Azure Pipelines


Azure Pipelines terminology:

* A pipeline is one or more stages.
* A stage consists of one or more jobs, which are units of work assignable to a particular machine.
  Examples of stages are "build this app", "run these tests", and "deploy to pre-production".
  By default, stages run sequentially.
  Stages may be arranged into a dependency graph: "run this stage before that one".
* A job is a series of steps that run sequentially as a unit.  A job may depend on earlier jobs.
* Each step runs it its own process and has access to the pipeline workspace on disk.
  Environment variables are not preserved between steps, but filesystem changes are.
* In a single-job build, you can omit the stages and jobs.


In Azure Pipelines, to run CI for a new GitHub project, do:

* New project.
* Pipelines
* >> New pipeline
* GitHub


Azure Pipelines no longer gives generous quota to new users (explanation at <https://devblogs.microsoft.com/devops/change-in-azure-pipelines-grant-for-public-projects/>).  To ask for an increase in *parallelism* (does not increase CPU quota), browse to <https://aka.ms/azpipelines-parallelism-request> .
This requires that you have already created an Azure Pipelines free account.


Travis vs. Azure environment variables:
<https://docs.microsoft.com/en-us/azure/devops/pipelines/migrate/from-travis?view=azure-devops>


Azure's mechanism for sharing files/directories between stages or jobs
within a pipeline is to use "artifacts".  They are somewhat limited:
"Subdirectories of the specified path will not be published. Wildcards
in the path are not supported."
I could zip up a directory and then unzip after downloading.


Azure Pipelines runs a Docker image in a container with a weird user and
permissions -- different than just running the docker image normally.


Azure Pipelines skips the whole CI job if any message in any commit (even
in a merge) contains "[ci skip]".  This can cause many jobs to be skipped
that should not be, and are not skipped by other CI systems.


Azure Pipelines allocates resources depending on the Microsoft user ID that
created the Azure Pipeline.  Therefore, to avoid having many unrelated
projects (Checker Framework, Daikon, Randoop) competing for the same CI
resources, I created an account for each of them, then created their Azure
Pipelines in that account.

For each project, I need to

* create a Gmail address such as "mernstrandoop"
  * forward all mail from the new Gmail address to me
* create a GitHub account
  * In my real account, make the GitHub account an owner for the organization (use the "people" tab).
* create an Azure account
  * Be sure to click "Sign in with GitHub"
  * Create a project named randoop (not mernstrandoop)
  * add my regular email address (eg, <mernst@alum.mit.edu>) to the team
* Create the pipelines
  * delete old project from my personal Azure account, where they were competing for the same small resources.


Azure Container Registry costs money.


To enable the "run next" button in Azure Pipelines:

1. Navigate to Organization Settings => Agent Pools to manage security for Org-Level agent pools.
2. Set specific users as Admins for all agent pools or specific pools depending our needs.

After doing this, it may take a few minutes for users to see the "run next" button.


## CircleCI


CircleCI's `docker` executor:

* The `large` resource class gives 8GB of memory and is the largest available to free users as of 2023-06-03.
   (sources: <https://circleci.com/pricing/> <https://circleci.com/docs/using-docker/#available-docker-resource-classes>)

CircleCI's `machine` executor is for a Linux machine not running a Docker image.

* The `medium` resource class gives 7.5GB of memory.
   (source: <https://circleci.com/docs/using-linuxvm/#available-linuxvm-resource-classes>)
   It may require payment in the future.  You specify a VM image rather than a Docker image.

Travis-CI:  "The default one is ‘medium’, which is ... usually ... 2vCPU and around 4 or 8 GB of RAM".
The Checker Framework tests do not run in 4GB of memory.


Grant CircleCI access to your organization at:
<https://github.com/settings/connections/applications/78a2ba87f071c28e65bb>


CircleCI 2.1:

* New features:  orbs, commands, and executors are new faces in the config.yml party. Also, workflows no longer have a version number. Make sure to take the version key out of your workflows section or bad things will happen. The only version key in 2.1 is the top-level key.
  * also jobs with parameters
* CircleCI 2.1 pipelines disable the CIRCLE_COMPARE_URL environment variable.
   <https://github.com/iynere/compare-url#examples> re-enables it, but crashes sometimes.
* Triggering a build after a build succeeds (<https://discuss.circleci.com/t/if-a-build-completes-in-one-project-is-there-a-way-to-trigger-build-on-another-project/23941/4>) apparently doesn't work any longer in v2.1:
   <https://discuss.circleci.com/t/circleci-2-1-is-it-possible-to-trigger-a-job-through-api/26294/8>


To download CircleCI output logs to a local file:

```sh
circle-step-outputter --repoSlug="mernst/randoop" --buildNum=923 --step=./scripts/test-systemTest.sh
mv test-output.txt system-923.txt
circle-step-outputter --repoSlug="mernst/randoop" --buildNum=925 --step=./scripts/test-nonSystemTest.sh
mv test-output.txt nonsystem-925.txt
circle-step-outputter --repoSlug="mernst/randoop" --buildNum=931 --step=./scripts/test-systemTest.sh
mv test-output.txt system-930.txt
circle-step-outputter --repoSlug="mernst/randoop" --buildNum=930 --step=./scripts/test-nonSystemTest.sh
mv test-output.txt nonsystem-931.txt
```


When setting up a new CircleCI repository, go to its settings:
(Find the project at <https://app.circleci.com/projects/project-dashboard/github/USER/>.)
Advanced Settings >>

* Build forked pull requests: on
* Auto-cancel redundant builds: on
* Enable pipelines: on   [I can't find this setting any more.]


I can't figure out how to get CircleCI's matrix feature to work, and I
cannot find any examples on the Web.


CircleCI: be sure to set "Build forked pull requests"


On CircleCI, to get the number of vCPUs available to me:

```sh
echo $(($(cat /sys/fs/cgroup/cpu/cpu.shares) / 1024))
```

(CircleCI sometimes gives more than the promised number of CPUs.  There is no way to know whether it will, for a given job.)


## Travis CI


Whitelist of Ubuntu packages that can be installed on container-based
Travis-CI infrastructure using the APT addon mechanism:
<https://github.com/travis-ci/apt-package-whitelist/blob/master/ubuntu-precise>
(which is linked from <https://github.com/travis-ci/apt-package-whitelist>)


Travis-CI advantages:

* no local sysadmin
* setup is checked into the version control repository
* builds pull requests and branches as well as the mainline
* every user can enable it for their repositories and forks

Travis-CI disadvantages:

* old OS:
  * default build infrastructure is Ubuntu 12.04
  * no OS more recent than Ubuntu 14.04 is available
  * these OS limitations are shared by other cloud CI infrastructure
* time limits:
  * jobs are limited to less than 2 hours
  * for Ubuntu 14.04, jobs are limited to about 50 minutes
  * if a repository has been tested a lot recently, new builds may be delayed
* memory limits:
  * machines have only 3-7 GB of memory; Java only uses 1/4 of this for its
      maximum heap size; so I sometimes need -Xmx2500M command-line argument
* no way to ssh in to virtual machines, which complicates debugging


A commit that has `[ci skip]` anywhere in the commit message is ignored by
Travis CI -- Travis does not run the continuous integration build/test
for that commit.


Travis will send email notifications about each broken build.  However, it
will only do so after you have logged in to the Travis website and given it
access to your GitHub account.


In your Travis CI .travis.yml file, it's best not to set the
"notifications" email.  If you do, and someone forks your repository, then
you will get notifications about their broken builds.  There isn't
currently a way to send email to a mailing list only if the failure is on
the main fork, but not on other people's forks.


Bootstrap (originally from Twitter) gives you templates and CSS for
creating "repsonsive" mobile-friendly webpages.


If your job is timing out because there wasn't any output in the last 10
minutes, then try making the `script:` line of your .travis.yml file be:

```yaml
  script: travis_wait 120 ./.travis-build.sh
```

travis_wait can only be used in the .travis.yml file, not in scripts called
by the .travis.yml file.
Calling travis_wait does not extend your timeout, it just prints a message
periodically so your job does not look hung to Travis.
Note that Travis seems to give more time on container-based than legacy infrastructure.


To enable Travis on your fork:

* Go to travis-ci.org
* Log in using GitHub
* You might need to click "refresh"
* turn on the toggle next to your fork's name

Now, the next time you push, the tests will run.


Travis debug VM:

1. Add

```yaml
- travis_debug
```

as one of the commands in the script block.

1. Send a POST request to /job/:job_id/debug using:
   TOKEN = your API token; see <https://github.com/travis-ci/travis.rb#token>
   JOB_ID = displayed in the build log after expanding "Build system information"

   ```sh
   #! /usr/bin/env bash
   curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Travis-API-Version: 3" \
     -H "Authorization: token <TOKEN>" \
     -d '{ "quiet": true }' \
     https://api.travis-ci.org/job/<JOB_ID>/debug
   ```

2. Head back to the web UI and in the log of your job. You should see the
   following lines to connect to the VM:

   ```text
   Setting up debug tools.
   Preparing debug sessions.
   Use the following SSH command to access the interactive debugging environment:
   ssh ukjiuCEkxBBnRAe32Y8xCH0zj@ny2.tmate.io
   ```

3. Connect from your computer using SSH into the interactive session, and once
   you're done, just type `exit` and your build will terminate.
   The job will skip the remaining phases after debug.
   Also, please consider removing the build log after you've finished debugging.


To install a different version of Docker on Travis:

```yaml
env:
  global:
   - DOCKER_VERSION="1.9.1-0~trusty"
before_install:
  - sudo apt update
  - sudo apt remove docker-engine -yq
  - sudo apt install docker-engine=$DOCKER_VERSION -yq --no-install-suggests --no-install-recommends --force-yes -o Dpkg::Options::="--force-confnew"
```


For a pull request, Travis-CI tests the branch and the PR merge commit.
These are two different SHAs.


This configuration of Travis cannot run docker; I get "docker: command not found" (though I guess I could install docker, since sudo is enabled):

```yaml
sudo: required
dist: precise
```


Typical invocation of trigger-travis:

```sh
~/bin/src/trigger-travis/trigger-travis.sh --branch master typetools commons-bcel `cat ~/private/.travis-access-token`
```


Sometimes, the Travis Gradle cache becomes corrupted and must be reset.
Clean the cache at the repository's settings page at <https://travis-ci.com/ORG/REPO/caches>


What to do if a Travis pull request fails:
Sometimes, your Travis pull request may fail even though your local build passed.
This is usually because Travis performed more tests than you ran locally.
First, examine the error logs, which contain diagnostic output from the failing command.
You can determine which command was run from the logs, or from the .travis.yml file.  (It might itself call some other file, such as .travis-build.sh.)
When there are multiple Travis jobs in a single Travis build, each job runs different commands, or they run the same command with different arguments.  You can determine those commands from the .travis.yml file and run them locally.


## GitHub Actions


GitHub Workflows CI is easy to set up: just commit a file to `.github/workflows/` (e.g., `gradle.yml`).
Beware that the default/suggested setup file only does CI on the master branch!


GitHub Actions offers free 2000 Linux minutes per month for public repositories.
  That's 1 hour per day.
  A macOS minutes costs 10 Linux minutes.
  A Windows minute costs 2 Linux minutes.
  Details at <https://help.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/about-billing-for-github-packages> .
Each virtual machine has a 2-core CPU with 7 GB of RAM
  Details at <https://help.github.com/en/actions/reference/virtual-environments-for-github-hosted-runners> .


GitHub Actions is problematic if you have flaky jobs.

* GitHub Actions halts all jobs if any job fails.
* GitHub Actions offers only a "Re-run all jobs" option,
   but no "Re-run failing jobs" option.  That means that if a job is flaky, it is
   expensive to re-run it.  Furthermore, starting lots of jobs at exactly the same
   time can *cause* flakiness as they all attempt to retrieve the same network
   resource, so on the re-run, the same or a different job may fail.


## GitLab CI runners


GitLab CI coordinates runners, farms out work to them, and keeps track build histories and whatnot, but doesn't do the build itself.
To use GitLab CI (continuous integration):

* In your project settings, enable the "Builds" feature.
* Click "Save changes"
* The page now shows a "CI token", which you can use to register a job runner for your project.
* Set up a runner.  If the GitLab server does not provide any shared runners, then set up a specific runner on another computer.  Navigate to "Settings >> Runners", and also see <https://gitlab.com/gitlab-org/gitlab-ci-multi-runner>


To register a GitLab CI multi-runner:

```sh
  gitlab-ci-multi-runner register --config=/etc/gitlab-runner/config.toml
```

Get the token it requests from your project's runners page.
As long as you pass in --config, the runner is automatically started;
you can ignore the output that tells you to start it.
Also go to the project's Settings > Services > Builds emails, to set an
email address for notification of failed builds.
To unregister a multi-runner:

```sh
  gitlab-ci-multi-runner unregister --token=<the runners token, which you can from the runners page on your project> 
```


## Jenkins


To give a new user permissions/privileges in Jenkins:

1. Find the Jenkins user name for the user:
  Go to (e.g.) <http://tern.cs.washington.edu:8080/>
  -> Manage Jenkins
  -> Manage Users (second to last option)
  We should request everybody from CSE to use their CSE account name.
2. Go to <http://tern.cs.washington.edu:8080/>
  -> Manage Jenkins
  -> Configure Global Security (second option)
  Now either look for whether that user is already present and adjust the
  privileges.
  Or add the user name into the small "User/group to add" box and then
  adjust the privileges.


## Dependabot


Dependabot runs on forks, which is irritating.
The workaround for now is to delete the fork and re-create it without enabling Dependabot security updates.
Or, use Renovate instead.
