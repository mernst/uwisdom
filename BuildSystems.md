# Build systems


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


## Make and Makefiles


make: "error 139" means that your program segfaulted:  139 = 128+11, and 11
is a segfault (<http://www.bitwizard.nl/sig11/>).

Exit code 137 is a good indication of being killed by the out-of-memory (OOM)
killer.  It means your process was killed by SIGKILL (signal 9), which is what
the OOM killer sends.  <http://tldp.org/LDP/abs/html/exitcodes.html>


Make has two flavors of variables that may appear in a Makefile.
The normal type is recursively expanded, re-evaluated on each use:

```make
foo = $(bar)
```

The GNU-specific type is simply expanded, set once when the assignment is
encountered.

```make
x := foo
```


In Makefiles, variables in rule targets and dependences are expanded as
soon as the rule target is read, but variables in rule actions are expanded
only when the action is actually executed.  Watch out for this
inconsistency!  This means that rules with variables in their
targets/dependences should come at the end of Makefiles.


In a Makefile, the right way to invoke make on a subdirectory or other
directory is

```sh
cd subdir && $(MAKE)
```

or, equivalently,

```sh
$(MAKE) -C subdir
```

To execute parallel jobs on a multiprocessor, use the "-j2" option.


In make, to ensure that a rule always runs even if the target seems to be
up to date, add an extra rule of the form

```make
.PHONY : clean
```

Once this is done, `make clean' will run the commands regardless of
whether there is a file named`clean'.


After Makefile.in is changed, it is necessary to rerun "config.status" and
then rerun "make".


Particularly useful special "automatic variables" used by make (in Makefile rules):

* `$@`   the target of the rule
* `$<`   the first prerequisite
* `$^`   all the prerequisites
* `$*`   the stem with which an implicit rule matches, including directory name

Example use of special automatic variables used by make:
`cp -p $< $@`


In Makefiles, to test whether a file/directory exists, do something like this:

```make
# Test that the directory exists.  There must be a better way to do this.
INV:=$(wildcard $(INV))
ifndef INV
  $(error Environment variable INV is not set to an existing directory)
endif
```

or alternately:

```make
ifeq "$(wildcard ${INV}/scripts)" "${INV}/scripts"
     ... it exists ...
else
     ... it does not exist ...
endif
```

or:

```make
ifneq ("$(wildcard $(PATH_TO_FILE))","")
  FILE_EXISTS = 1
else
  FILE_EXISTS = 0
endif
```


Suppose I want to write a rule that always performs a task, but doesn't
necessarily cause its dependence to execute first.  This is a snippet of
the Makefile I would like to write:

```make
.PHONY: maybe-update-file1
maybe-update-file1:
  Command A:  may or may not update file1.txt
file2.txt:  maybe-update-file1 file1.txt
  Command B:  computes file2.txt from file1.txt
```

Problem: because the maybe-update-file1 target always executes, Command B
always executes.  That wastes the time to execute Command B, and because it
unconditionally updates file2.txt, any command that depends on file2.txt
also executes unnecessarily.

Here is an approach that works:

```make
file2.txt: maybe-update-file1 .timestamp-file2
.PHONY: maybe-update-file1
maybe-update-file1:
 @if [ `fortune | wc -l` -eq 1 ] ; then echo touch file1.txt; touch file1.txt; fi
.timestamp-file2: file1.txt
 cp file1.txt file2.txt
 touch .timestamp-file2
```


The directory of the current Makefile:

```make
THIS_MAKEFILE:=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
```


## Ant and buildfiles, build.xml


An Ant guide (documentation) for beginners:
<http://wiki.apache.org/ant/TheElementsOfAntStyle>


To permit user-specific setting of variables in a Makefile, add this at the
top (and change assignments to use "=?" syntax):

```make
  # Put user-specific changes in your own Makefile.user.
  # Make will silently continue if that file does not exist.
  -include Makefile.user
```


To make a tags table for a LaTeX paper, using an Ant buildfile:

```ant
  <target name="etags" depends="tags">
  </target>
  <target name="tags" depends="init" description="builds Emacs TAGS table">
    <exec os="Linux" executable="etags" failonerror="true">
      <!-- args explicitly specified so that they are in the right order -->
      <!-- To regenerate, run:  latex-process-inputs -antlist main.tex -->
      ...
    </exec>
  </target>
```

To make a tags table for a Java project, using an Ant buildfile:

```ant
  <target name="etags" depends="tags">
  </target>
  <target name="tags" description="Create Emacs TAGS table">
    <exec executable="/bin/sh">
      <arg value="-c"/>
      <arg value="etags `find -name '*.java' | sort-directory-order`"/>
    </exec>
  </target>
```


To print out a path in ant, use this snippet of code at the end of your ant
file.  This is good for debugging classpath issues when running javac, as
ant ordinarily doesn't let you see the classpath or the javac command line.

```ant
  <!-- = = = = = = = = = = = = = = = = =
       macrodef: echopath
       Use as:    <echopath pathid="mypath"/>
       = = = = = = = = = = = = = = = = = -->
  <macrodef name="echopath">
    <attribute name="pathid"/>
    <sequential>
      <property name="line.pathprefix" value="| |-- "/>
      <!-- get given path in a printable form -->
      <pathconvert pathsep="${line.separator}${line.pathprefix}"
       property="echo.@{pathid}"
       refid="@{pathid}">
      </pathconvert>
      <echo>Path @{pathid}</echo>
      <echo>${line.pathprefix}${echo.@{pathid}}</echo>
    </sequential>
  </macrodef>
```


To print a fileset in Ant:

```ant
    <macrodef name="echo-fileset">
      <attribute name="filesetref" />
      <sequential>
      <pathconvert pathsep="\n " property="@{filesetref}.echopath">
        <path>
         <fileset refid="@{filesetref}" />
        </path>
       </pathconvert>
      <echo>   ------- echoing fileset @{filesetref} -------</echo>
      <echo>${@{filesetref}.echopath}</echo>
      </sequential>
    </macrodef>
...
    <echo-fileset filesetref="src.files"/>
```


To access environment variables in Ant:

```ant
  <property environment="env"/>
```

and then use

```ant
  ${env.HOME}
```


A recipe for a temporary directory in Ant:

```ant
  <property name="tmpdir" location="${java.io.tmpdir}/${user.name}/${ant.project.name}" />
  <delete dir="${tmpdir}" />
  <mkdir dir="${tmpdir}" />
```


ant wildcards - ** means the current directory or any directory
below it.  I still can't find where this is documented.


In Ant, to check whether files have the same contents, there is no "diff"
task but you can use the "filesmatch" condition.


In Ant, to convert a relative filename/pathname to absolute, use:

```ant
  <property name="x" location="folder/file.txt" />
```

and `${X}` will be the absolute path of the file relative to the `${basedir}` value.
In general, for a file or directory, it's less error-prone to use

```ant
  <property name="x" location="folder/file.txt" />
```

rather than

```ant
  <property name="x" value="folder/file.txt" />
```

Also consider using `${basedir}`, which is already absolute.
It defaults to the containing directory of the buildfile, and it can appear
in a build.properties file.
A slightly less clean approach than `${basedir}` is

```ant
  <dirname property="ant.file.dir" file="${ant.file}"/>
```


Ant permits you to specify that one target depends on another, but by
default every prerequisite is always rebuilt, even if it is already up to
date.  (This is a key difference between Ant and make:  by default, make
only re-builds a target if some prerequisite is newer.)

To make Ant re-build prerequisites only if necessary, there are two general
approaches.

1. Use the `uptodate` task to set a property.  Then, your task can test the
   property and build only if the property is (not) set.

   ```ant
     <uptodate property="mytarget.uptodate">  // in set.mytarget.uptodate task
       ...
     </uptodate>
     <!-- The prerequisites are executed before the "unless" is checked. -->
     <target name="mytarget" depends="set.mytarget.uptodate" unless="mytarget.uptodate">
       ...
     </target>
   ```

   Alternately, use the outofdate task from ant contrib.  It's nicer in
   that it is just one target without a separate property being defined; by
   contrast, outofdate requires separate targets to set and to test the
   property.

2. Create a <fileset> using the <modified> selector.  It calculates MD5
   hashes for files and selects files whose MD5 differs from earlier stored
   values.  It's optional to set

   ```ant
        <param name="cache.cachefile"     value="cache.properties"/>
   ```

   inside the <modified> selector; it defaults to "cache.properties".
   Example that copies all files from src to dest whose content has changed:

   ```ant
           <copy todir="dest">
               <fileset dir="src">
                   <modified/>
               </fileset>
           </copy>
   ```

There is also Ivy, but I can't tell from its documentation whether it
provides this feature.  The key use case in the documentation seems to be
downloading subprojects from the Internet rather than avoiding wasted work
by staging the parts of a single project.


In Ant, the path to the current ant build file (typically build.xml) is
available as property `ant.file`.  You can get its directory in this way:

```ant
<dirname property="ant.file.dir" file="${ant.file}"/>
```


In Ant, to jar up the contents of a set of existing .jar files:

```ant
    <zip destfile="out.jar">
 <zipgroupfileset dir="lib" includes="*.jar"/>
    </zip>
```


Vizant (<http://vizant.sourceforge.net/>) is an ant build visualization tool.


To make the junit task work in Ant without setting classpath, use the hack from:
<http://wiki.osuosl.org/display/howto/Running+JUnit+Tests+from+Ant+without+making+classpath+changes>


To list the projects (top-level targets) in an Ant build.xml file, do either of:

```sh
  ant -projecthelp
  ant -p
```


To get the current working directory from an ant file:

```ant
  ${bsh:WorkDirPath.getPath()}
```


To pass the -Xlint argument to javac when running from Ant, do:

```ant
      <compilerarg value="-Xlint"/>
```


To run ant without parallelism, to avoid bugs like
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=738789> :

```sh
ant -Doutgen.job.ant.opts=-XX:ActiveProcessorCount=1
```


## Maven and pom.xml


In a Maven buildfile pom.xml, here is where to put <plugins>:

```maven
<build>
  <plugins>
  ...
```


Uploading artifacts to Maven Central:
I give up on using Maven to upload artifacts to Maven Central.  There are
several different plugins that are intended to do this, but their
documentation is uniformly bad (or at least it assumes great familiarity
with Maven) and I couldn't get any of them to work despite significant
effort.  Their error messages are extremely obscure, too.
By contrast, Gradle has fewer plugins and I got one to work.


To ignore test sounrces altogether and not compile them:

```sh
mvn -Dmaven.test.skip package
```

To compile test files, but not run them, do one of these:

```sh
mvn install -Dmaven.test.skip=true
mvn -DskipTests compile
```


To see a project's Maven dependencies:

```sh
mvn dependency:tree
```

To see the dependencies of its buildfile (compilation-time dependencies):

```sh
mvn dependency:resolve-plugins
```

To update a project's Maven dependencies:

```sh
mvn versions:use-latest-releases
```


If you get a Maven error like

```text
Could not resolve dependencies for project <project-name>.
The following artifacts could not be resolved: <artifact>:
Failure to find <artifact> in ... was cached in the local repository,
resolution will not be reattempted until the update interval of central has elapsed or updates are forced
```

Then Maven will not retry for 1 day (!).
To force a retry, delete the offending directory under `~/.m2/` (or at least its *.repositories) file, or pass `-U` to Maven.


To delete Maven Central snapshots, delete this directory:
.m2/repository/org/checkerframework:


## Buck


Pass `--version 8` to see the javac command line that buck issues.


## Gradle and build.gradle


The standard gradle task (target), which builds all artifacts and runs all tests, is

```sh
./gradlew build
```


When debugging gradle, use `--info` (less verbose) or `--debug` (more verbose).
There are also Java properties; start the JVM with `-Dorg.gradle.logging.level=debug`.

`gradle --debug` outputs the full javac command, which can be given on the
command line to reproduce the effects of the gradle build.  It's painful to
find it in the voluminous debug output, though.

Gradle's `--dry-run` only shows the tasks that would have run, not their
actions/commands like make's `--dry-run` does.


If Gradle crashes, try deleting the project's .gradle/ directory.


Gradle task to create a TAGS table:

```gradle
/* Make Emacs TAGS table */
task tags(type: Exec, dependsOn: 'clone') {
  description "Run etags to create an Emacs TAGS table"
  environment PATH: "$System.env.PATH:$buildDir/utils/plume-lib/bin"
  commandLine "bash", "-c", "find src/ -name '*.java' | sort-directory-order | xargs etags"
}
```


How to publish a snapshot release to a local repository.
If your project uses the 'maven-publish' plugin:

```sh
./gradlew PublishToMavenLocal
```

In gradle, to make a projects use the snapshot:  adjust the version number and add to `build.gradle`:

```gradle
  repositories {
    mavenLocal()
  }
```

In Maven, projects automatically use the local repository, so just adjust the version number.


To replace a remote dependency (e.g., in Maven Central) by a local one (a file) in Gradle, do:

```gradle
implementation files('libs/options-0.2.2-all.jar')
```

But, it is usually better to install a snapshot version in a local Gradle
repository, then use that snapshot version number in your Gradle build file.


To test a new version of a Gradle dependency locally, you have several options:

* install a version (maybe a snapshot version) in a local Gradle repository
* Edit the build.gradle file, for instance by changing

   ```gradle
   implementation 'org.plumelib:bcel-util:1.1.3'
   ```

   to

   ```gradle
   implementation files("${rootDir}/libs/bcel-util-all.jar")
   ```

* Overwrite the `.jar` file in a subdirectory of
   `~/.gradle/caches/modules-2/files-2.1/` .
   This does not require changing your build.gradle file.
   Since you now have locally cached a different version than is in Maven
   Central, your local builds will not be the same as for other people.
   So you should probably delete the versions you put there when you are done
   with your experiments.


In Travis CI, it's a good idea to enable Gradle caching of downloaded
artifacts.  It reduces bandwidth and time usage, and more importantly it
reduces transient failures that happen due to loss/reduction of network
connectivity.  But, the cache periodically gets corrupted.

```yaml
## If the cache gets corrupted, clean it at https://travis-ci.com/ORG/REPO/caches .
before_cache:
  - rm -f  $HOME/.gradle/caches/modules-2/modules-2.lock
  - rm -fr $HOME/.gradle/caches/*/plugin-resolution/
cache:
  directories:
    - $HOME/.gradle/caches/
    - $HOME/.gradle/wrapper/
    - $HOME/.m2/
```


To enable Gradle caching within a Docker container:

```sh
docker run -v $HOME/.gradle:/root/.gradle -v $HOME/.m2:/root/.m2 USER/IMAGE-NAME /bin/bash -c "..."
```

Travis says not to cache Docker images:
<https://docs.travis-ci.com/user/caching/#things-not-to-cache>


Preparing the Gradle buildfile for uploading/releasing to Maven Central:
Set up directory:

1. Run once ever: ln -s ../../../gradle.properties gradle.properties
2. Add gradle.properties to .gitignore file.
3. Gradle buildfile rules:
   <http://central.sonatype.org/pages/gradle.html>
   (It's better to use the "maven-publish" plugin; does it now suport signing?)

Here are alternate, but worse, sources of Gradle buildfile rules:

* This doesn't give instructions about Maven Central in particular:
   <https://docs.gradle.org/current/userguide/maven_plugin.html>
* The "maven-publish" plugin doesn't support signing which Maven Central requires:
   <https://docs.gradle.org/current/userguide/publishing_maven.html>


To make a release to Maven Central using Gradle:

1. Create Gradle files using <http://central.sonatype.org/pages/gradle.html>
2. Increment the version number in buildfiles, documentation (README files), etc.
3. Run one of these:

   ```sh
   ./gradlew uploadArchives
   ./gradlew -b mavencentral.gradle uploadArchives
   ```

4. Manually release the deployment:
  a. Browse to <https://oss.sonatype.org/#stagingRepositories>
  b. Search for and select this repository, by group name.
  c. At the top, click "close" then "refresh" then "release".
     You might have to wait a little while between the clicks.
     Use the release message "Plume-lib Options X.Y.Z" (w/version number).

Artifacts should be available in 10+ minutes.
They will show up at search.maven.org in 2 hours.


To set up a Java project to build with Gradle (to create a build.gradle file):

1. `gradle wrapper --gradle-version 6.1.1`
2. Run one of the following lines:

   ```sh
   ./gradlew init --type java-library
   ./gradlew init --type java-application
   ```

Put the code under `src/main/java`.


You can include a remote Gradle build script by doing:

```gradle
apply from: "http://path/to/script.gradle"
```

The downside of this is that it downloads every time; there is no caching.
And maybe it doesn't work offline?


To visualize the task dependencies in a Gradle buildfile:

```gradle
plugins {
    id "com.dorongold.task-tree" version "4.0.0"
}
```

Then run

```sh
./gradlew SOMETASKNAME taskTree
```

When one of the tasks given to the gradle command is `taskTree`, execution
of all the other tasks on that line is skipped. Instead, their task
dependency tree is printed.


To exclude a file from Gradle's shadowJar plugin/task:

```gradle
shadowJar {
  // Toxic classfile, crashes Gradle (because ASM considers it malformed)
  exclude 'org.plumelib.util.OrderedPairIterator'
}
```


To solve the Gradle problem "Timeout waiting to lock daemon addresses
registry. It is currently in use by another Gradle instance..", remove all
Gradle lock files:

```sh
find ~ -type f -name "*.lock" | grep /.gradle/ | while read f; do rm $f; done
```

Possibly also `kill -9` the process number mentioned in the Gradle output.


The gradle error "Error snapshotting jar [httpclient-4.5.3.jar]" might be
due to a corrupted Gradle cache.  Blow away the cache (on Travis, comment
out the line, do a build, then re-enable; or leave it uncommented since the
problem may recur at any time).


To upgrade/update Gradle from one version to a newer version:
First, find the projects:

```sh
# In your shell:
locate gradlew
```

```elisp
# In Emacs:
(progn (delete-matching-lines "-fork-[^m]" nil nil t)
  (delete-matching-lines "branch-[^m]" nil nil t))
```

Then:

* ./gradlew wrapper --gradle-version 4.10.3 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 5.6.4 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 6.3 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 6.9 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 7.1 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 7.5.1 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 7.6.1 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 8.14.3 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations
* ./gradlew wrapper --gradle-version 9.2.0 && ./gradlew build --warning-mode=all
* Look for warnings and deprecations

The latest Gradle release version number is at <https://gradle.org/releases/> .

1. Add at beginning `settings.gradle`:

   ```gradle
   plugins { id "com.gradle.enterprise" version "3.2" }
   gradleEnterprise {
     buildScan { termsOfServiceUrl = 'https://gradle.com/terms-of-service'; termsOfServiceAgree = 'yes' }
   }
   ```

2. Run `./gradlew help --scan` and browse to the URL.  If the Deprecations tab appears, see it.  If the Deprecations tab does not apper, you are set.


Gradle caching:
To solve

```text
> Cannot lock execution history cache (...) as it has already been locked by this process.
```

run:

```sh
find ~/.gradle -type f -name "*.lock" -delete
```

Alternately, to blow away *all* gradle caches, run:

```sh
rm -rf ~/.gradle/caches
```


To fix the Gradle error

```text
Could not create service of type DefaultGeneralCompileCaches using GradleScopeCompileServices.createGeneralCompileCaches().
```

here are two possibilities:

* run `gradle --stop` to stop all daemons
* delete the project's `.gradle` directory


In gradle, to debug exec tasks:

```gradle
// Print the command line of each exec task before executing, for debugging.
allprojects {
  tasks.withType(Exec) {
    doFirst {
      println commandLine
    }
  }
}
```


In the Checker Framework Gradle plugin, set max heap space (max memory usage) via:

```gradle
compile.options.forkOptions.jvmArgs += [
            "-Xmx1g"
          ]
```


To provide more memory to Java processes started by Gradle such as Checker
Framework runs:

```gradle
tasks.withType(JavaCompile).configureEach {
  options.forkOptions.jvmArgs += "-Xmx2g"
}
```

To provide more memory (maximum heap size) to Gradle itself, add to file `settings.gradle`:

```groovy
org.gradle.jvmargs=-Xmx2g
```

To provide more memory to Gradle itself from the command line:

```sh
GRADLE_OPTS="-Xmx2g" ./gradlew build javadoc
```

Note that `GRADLE_OPTS` and `JAVA_OPTS` are treated identically by Gradle.
Also note that `GRADLE_OPTS` is *not* about options to Gradle such as `--console=plain`, but about JVM options such as `-Xmx2g`.  And, it doesn't affect the Gradle daemon, which is what you really care about.  That is controlled by `org.gradle.jvmargs` in file `gradle.properties` (in your project's root directory or in your Gradle user home directory (typically ~/.gradle/gradle.properties).

There is also `JAVA_TOOL_OPTS` which works for all Java processes (java, jar,
javac), but it is overridden by any command-line arguments that are passed by
Gradle when calling the subprocess:

```sh
JAVA_TOOL_OPTIONS="-Xmx2g" ./gradlew build javadoc
```

GitLab uses environment variable `GRADLE_CLI_OPTS`.


For a task to show up in the output of `gradle tasks` or `gradlew tasks`,
it must have a "group".


To run just some JUnit tests using Gradle:

```sh
./gradlew :systemTest --tests '*runCollectionsTest'
```


To use a locally-built version of a project:

1. Set the version number to end with "-SNAPSHOT".
2. Run `./gradlew publishToMavenLocal`
3. In the client, update the version number
   and add `mavenLocal()` to the `repositories {...}` block.


To force resolving and downloading all Gradle dependencies:

```sh
./gradlew --write-verification-metadata sha256 help --dry-run
```


Gradle's `implementation` dependency is found on compile classpath
of this component and consumers.


The Checkstyle linter isn't worth running.  It finds mostly shallow and formatting
issues, and its required configuration is voluminous and hard to understand.


It is possible to run the Checkstyle linter from Gradle, without having to write a configuration `.xml` file.  Here is an example:

```gradle
/// Checkstyle linter
// Run by `gradle check`, which is run by `gradle build`.
// 1. Note that the line length check may fail due to workarounds for
// https://github.com/google/google-java-format/issues/5, though that issue could
// be resolved by merging https://github.com/google/google-java-format/pull/802 .
// 2. I do not see how to disable/suppress a particular check, from the `build.gradle` file.
// 3. I don't see how to get the effect of <module name="SuppressionCommentFilter"/>, also
// without creating a separate `checkstyle.xml` or `checkstyle-suppressions.xml file`.
if (JavaVersion.current() != JavaVersion.VERSION_1_8) {
  apply plugin: 'checkstyle'
  ext.checkstyleVersion = '10.5.0'
  configurations {
    checkstyleConfig
  }
  dependencies {
    checkstyleConfig("com.puppycrawl.tools:checkstyle:${checkstyleVersion}") { transitive = false }
  }
  checkstyle {
    toolVersion "${checkstyleVersion}"
    config = resources.text.fromArchiveEntry(configurations.checkstyleConfig, 'google_checks.xml')
    ignoreFailures = false
  }
}
```

However, I do not see how to disable/suppress a particular check, still from the `build.gradle` file.
The type of `config` is org.gradle.api.internal.resources.FileCollectionBackedArchiveTextResource,
and the value of `configProperties` is `[:]`, an empty map.
When is `configProperties` set?


A hacky way to work around this problem:

```text
Execution failed for task ':signMavenPublication'.
> Cannot perform signing task ':signMavenPublication' because it has no configured signatory
```

is to run

```sh
./gradlew PublishToMavenLocal -x signMavenPublication
```


The solution to the Gradle problem
"Cannot lock execution history cache as it has already been locked by this process."
is `./gradlew --stop`


Gradle only checks for new SNAPSHOT versions (also called "changing versions") every 24 hours by default.  To get new snapshot releases, run Gradle with `--refresh-dependencies`


In Gradle, to see when each individual test is run (helps to determine which one is timing out):

```gradle
  test {
    testLogging {
      // This is all the events except standardOut and standardErr.
      events = [
        "started",
        "passed",
        "failed",
        "skipped"
      ]
    }
  }
```


Gradle:
  mustRunAfter
  shouldRunAfter
In each case, the directive has no effect unless both tasks would run anyway.
mustRunAfter is strict.  Gradle may violate shouldRunAfter to increase parallelism.


### Displaying Gradle dependencies


To see the source of the dependencies that end up in a fat/uber/shadow jar:

```sh
/gradlew :checker:dependencies
```


To print/show the classpath that Gradle uses:
From within the `build.gradle` file:

```gradle
task printCompileClasspath {
  description = 'Print the compile-time classpath'
  doFirst {
    println "Compile classpath:"
    sourceSets.main.compileClasspath.each { println it}
  }
}
task printTestCompileClasspath {
  description = 'Print the compile-time test classpath'
  doFirst {
    println "Compile classpath:"
    println sourceSets.test.compileClasspath.asPath
  }
}
task printTestClasspath {
  description = 'Print the runtime classpath'
  doLast {
    println "Runtime classpath:"
    sourceSets.main.runtimeClasspath.each { println it }
  }
}
```

Another way (this shows which files Gradle's shadowJar plugin/task will put in a fat jarfile):

```gradle
    doFirst {
      println sourceSets.main.runtimeClasspath.asPath
    }
```

From the command line, do this (but it includes .jar files with Gradle's implementation):

```sh
./gradlew clean assemble --debug | grep "Using implementation classpath"
```

From the command line, this only lists the dependency names and version numbers, not their .jar files.

```sh
gradle dependencies --configuration=testCompileClasspath
```


## Testing local version of Checker Framework by overwriting local caches


To copy a locally-built Checker Framework to the Gradle and Maven local caches:
(Must update gradle directory names when updating `$VER`!)

```sh
VER=3.10.0 && \
(cd $CHECKERFRAMEWORK && ./gradlew copyJarsToDist) && \
\cp -pf $CHECKERFRAMEWORK/checker/dist/checker.jar ~/.gradle/caches/modules-2/files-2.1/org.checkerframework/checker/${VER}/2c93f826fd862139bba9ac98b9822f19fb55060e/checker-${VER}.jar && \
\cp -pf $CHECKERFRAMEWORK/checker/dist/checker-qual.jar ~/.gradle/caches/modules-2/files-2.1/org.checkerframework/checker-qual/${VER}/710fd6abff4b26b40dc0917050dc4c67efcf60b6/checker-qual-${VER}.jar && \
\cp -pf $CHECKERFRAMEWORK/checker/dist/checker.jar ~/.m2/repository/org/checkerframework/checker/${VER}/checker-${VER}.jar && \
\cp -pf $CHECKERFRAMEWORK/checker/dist/checker-qual.jar ~/.m2/repository/org/checkerframework/checker-qual/${VER}/checker-qual-${VER}.jar && \
true
```

To clean the Gradle and Maven local caches (rarely needed):

```sh
VER=3.10.0 && \
rm -rf \
  ~/.gradle/caches/modules-2/files-2.1/org.checkerframework/checker/${VER}/ \
  ~/.gradle/caches/modules-2/files-2.1/org.checkerframework/checker-qual/${VER}/ \
  ~/.m2/repository/org/checkerframework/checker/${VER}/ \
  ~/.m2/repository/org/checkerframework/checker-qual/${VER}/ \
```
