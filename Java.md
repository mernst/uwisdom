# Wisdom about Java



## JIT


To disable the JIT, run Java with the  -Djava.compiler=DISABLED  option.


To make Throwable.printStackTrace() produce file names and line numbers in
Java (under Solaris, using Sun's JVM), disable the JIT that compiles away
source code information:

```sh
  setenv JAVA_COMPILER NONE
```

Of course, the code must have been compiled with debugging enabled (-g
switch to compiler)!


The Java bytecode verifier gave me

```text
  Exception in thread "main" java.lang.VerifyError: (class: Hello, method: main signature: ([Ljava/lang/String;)V) Incompatible object argument for function call
```

when the problem was that I had used "invokevirtual" where I should have
used "invokestatic".



## JUnit


To migrate from JUnit 4 to JUnit 5:
<https://junit.org/junit5/docs/current/user-guide/#migrating-from-junit4>


JUnit:  helps in writing Java test suites.  <www.junit.org>
To run JUnit 4 tests from the command line:

```sh
  java -cp .:junit.jar org.junit.runner.JUnitCore ps1.PublicTest
```

To run JUnit 3 tests from the command line:

```sh
  java -cp .:junit.jar junit.textui.TestRunner ps1.PublicTest
```


How do I launch a debugger (e.g. jdb) when a JUnit test fails?
Start the TestRunner under the debugger and configure the debugger so that
it catches the junit.framework.AssertionFailedError.  Notice that this will
only launch the debugger when an expected failure occurs.
For example

```sh
java -cp whatever:/path/to/junit.jar junit.textui.TestRunner MyTestClass
  catch junit.framework.AssertionFailedError
  run
```


Upgrading from JUnit 4 to JUnit 5:
Gradle buildfile logic:

```gradle
dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.6.2'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine'
}
test {
    useJUnitPlatform {
        includeEngines 'junit-jupiter'
        excludeEngines 'junit-vintage'
    }
}
```

Updating imports, using Emacs:

```elisp
(tags-query-replace "import \\(static \\)?org.junit.Assert\\(\\..*\\);" "import \\1org.junit.jupiter.api.Assertions\\2;")
(tags-query-replace "import \\(static \\)?org.junit.\\([A-Za-z]*\\);" "import \\1org.junit.jupiter.api.\\2;")
```


## Debugging


Graphical Java debugger:  jswat (<http://www.bluemarsh.com/java/jswat/>).
To run it:

```sh
  java com.bluemarsh.jswat.Main
```


To get a traceback (stack trace) from each Java thread (but keep running):

* `jstack _pid_`
* `jcmd _pid_ Thread.print`  (just `jcmd` gives a list of pids)
* `kill -QUIT _pid_`
* `ctrl-\` if Java is running in a shell.
This is useful for debugging an infinite loop in a Java program.

*

Use the -Xtrace:trigger option to produce a Java dump by whenever a given method is called.
For example, for a dump whenever the substring method is called:

```text
-Xtrace:trigger=method{java/lang/String.substring,javadump}
```


To eliminate nondeterminism from a (sequential, non-concurrent) Java program:

* Use `LinkedHashMap` and `LinkedHashSet` rather than `HashMap` and `HashSet`.
* Override hashCode(), so that your program does not use Object.hashCode() which is nondeterministic (it depends on when the garbage collector runs). Also don't instantiate the Object class, as in new Object(); instead, use some class that overrides hashCode().
* Mitigate other sources of nondeterminism, such as always calling `Arrays.sort` on the result of `File.listFiles`.


JVM segmentation faults (segfaults):
When the VM crashes, it generates a log file of the active frames.
To get line numbers too, make the VM create a core dump, then use jstack:

```sh
  jstack `which java` core.<pid>
```



## Profiling


For notes about Java garbage collection and the heap, see wiki page JavaHeap.


For notes about Java profiling, see wiki page JavaTools.


Some ways to profile/understand java memory use
  The Runtime class has methods that will return the total amount of
  memory used.  These don't seem to be terribly accurate.
  There is a heap/CPU profiler that seems to work pretty well.
  look at:
    <http://java.sun.com/j2se/1.4.2/docs/guide/jvmpi/jvmpi.html#hprof>
  By default, it gives only heap usage profiles; for CPU profiling, use:
    java -Xrunhprof:cpu=samples


Java timing information via System.currentTimeMillis() is only accurate
to milliseconds.  I couldn't find anything more precise.  Nor anything
that works with CPU time rather than wallclock time.





## Generics


Official (JLS) terminology for Java generics (parametric polymorphism):


* The formal type parameter is called a "type parameter".
   The parameter is
   also, equivalently, called a "type variable".  But "type parameter"
   tends to be used when speaking of the declaration and "type variable"
   tends to be used when speaking of its uses in the body.
   (For a method/constructor, it's called the "formal type parameter";
   JLS3, sec 8.4.4.)
   The "type parameter section" is delimited by angle brackets and
   declares the type variables.  (JLS3, sec 8.1.2).
* The actual type parameter is called a "type argument".
* A "parameterized type" is a type that has type arguments/parameters.
* A class is generic if it declares one or more type variables (JLS3, sec 8.1.2).
   JLS only uses "generic" to refer to class *declarations*, not
   classes.  "A generic class declaration defines a set of parameterized
   types, one for each possible invocation of the type parameter section."

*

Terminology for generics/parametric polymorphism in Java, from *Effective Java*, second edition, page 115.
|====
| Parameterized type      | `List<String>`              |
| Actual type parameter   | `String`                    |
| Generic type            | `List<E>`                   |
| Formal type parameter   | `E`                         |
| Unbounded wildcard type | `List<?>`                   |
| Raw type                | `List`                      |
| Bounded type parameter  | `<E extends Number>`        |
| Recursive type bound    | `<T extends Comparable<T>>` |
| Bounded wildcard type   | `List<? extends Number>`    |
| Generic method static   | `<E> List<E> asList(E[] a)` |
| Type token              | `String.class`              |
|====
The first part ("`List`") of a parameterized type name is called the
class name.
The first part ("`List`") of a generic type name is called:  (??? no
good name, Alex Buckley suggested that it also be "class name", but that
isn't quite right).
They don't have a name for a use of type parameter/variable, to distinguish
from the declaration.
(The *Effective Java* terminology differs from that used in the JLS.)



## javac


javac is a script that runs a Java program that runs on a JVM, and you can
pass command-line arguments to that JVM using the `-J` command-line
argument.  In particular, you can pass `-J-Xmx1024M` to give the JVM a
gigabyte of memory for the heap.


The command

```sh
javac -jar myjar.jar
```

ignores the CLASSPATH environment variable, so you may need to pass it
explicitly

```sh
javac -jar myjar.jar -cp ${CLASSPATH}
```


To limit/increase the number of errors that javac will print (default 100),
use `-Xmaxerrs N`.
The analogous command-line option for warnings is `-Xmaxwarns N`.


If javac says

```text
  warning: unmappable character for encoding UTF8
```

then change the Ant task:

```xml
  <javac encoding="8859_1" ...
```

or the command line:

```sh
  javac -encoding 8859_1 ...
```


There are two ways to disable javac warnings of the form

```text
  ... uses internal proprietary API that may be removed in a future release
  ... is internal proprietary API and may be removed in a future release
```

* Approach #1 is to run

```sh
  javac -XDignore.symbol.file ...
```

flag which will compile your program against Oracle's/Sun's internal rt.jar
rather than the public-facing symbol file `ct.sym`.

* Approach 2 has two variants
** Approach #2a is to run

```sh
  javac -XDenableSunApiLintControl -Xlint:-sunapi ...
```

This still issues a "note" but not a warning.
** Approach #2b is to suppress the warning and the note by writing

```java
  @SuppressWarnings("sunapi")
```

in the source code, but this still requires you to run javac as follows:

```sh
  javac -XDenableSunApiLintControl ...
```


To suppress a javac warning like

```text
warning: [options] bootstrap class path not set in conjunction with -source 1.7
```

that results from command-line arguments `-source 7 -target 7`,
supply the additional command-line argument: `-Xlint:-options`


To resolve

```output
warning: [classfile] MethodParameters attribute introduced in version 52.0 class files is ignored in version 51.0 class files
```

run javac with `-Xlint:-classfile`.
This is only needed in Java 8, because the bug is fixed in Java 11:
<https://bugs.openjdk.java.net/browse/JDK-8190452>



## javadoc


How to quote less than and greater than (angle brackets), such as for generics, without using &lt; and &gt; in Javadoc comments:

```text
 Equation: {@literal i > j}
 Inline code: {@code getThat<T>()}
 Multi line code:
   <pre>{@code
   ...
   }</pre>
 For the latter, if there is an unbalanced close curly brace, that will
 terminate the `{@code ...}` constrict early, but balanced braces are fine.
```

The purpose of `{@code ...}` is to prevent HTML interpretation:  characters
such as <, >, &amp;, are passed through unchanged.


You need to quote/escape the @ (at-sign) symbol in Javadoc when it appears
at the beginning of a line.  Use `{@literal @}` or `&#064;` or `&nbsp;@`
None of these works within `<pre>{@code ...}</pre>`.  If you need @ at the
beginning of the line in a code block, use `<pre><code> ... </code></pre>`
together with one of the above.
If you *also* need `<` in that code block:

* use {@code ...} on any line that needs `<` or `>`, or
* use `{@literal <}` (though the spacing will look bad) or `&lt;`.


Here is a webpage that discusses how to write code in Javadoc,
including quoting of @ (at-sign) and other characters:
<https://reflectoring.io/howto-format-code-snippets-in-javadoc/>


To avoid doclint messages about missing Javadoc tags, such as "no @param for someArg"

```text
-Xdoclint:all,-missing
```

This only works with Javadoc 8 and later; the command-line option is
illegal under Javadoc 7 and causes it to terminate abnormally.
In a Makefile, you can set a DOCLINT variable as follows

```make
ifneq (,$(findstring 1.8.,$(shell java -version 2>&1)))
  DOCLINT?=-Xdoclint:all,-missing
endif
```


In a Javadoc `@param`, `@return`, etc. clause, the initial text is a sentence
fragment that starts with a lowercase (not capital) letter and does not end
with a period unless followed by another sentence.


In Javadoc @see and @link clauses, nested classes must be specified as
`Outer.Inner`, not simply `Inner`.


The Javadoc @link clause takes an optional argument to indicate the displayed text:

```javadoc
{@link Class#member displaytext}
```


If a type is not used in the source code, then Javadoc mentions of it are
not made into links in the generated HTML.  So you need to create a dummy
public field (a private one doesn't work).  For example:

```java
  // Without this, the Javadoc mentions of "java.util.Vector" are not links
  // in the generated HTML.
  public Vector<?> javadocLossage;
```


To turn Javadoc warnings into errors, pass `-Xwerror` on the command line.
Here are two ways to do it in Gradle:

```gradle
javadoc {
  // Turn Javadoc warnings into errors.
  options.addStringOption('Xwerror', '-quiet')
}
```

or

```gradle
tasks.withType(Javadoc) {
  // Turn Javadoc warnings into errors.
  options.addStringOption('Xwerror', '-quiet')
}
```

To catch fewer warnings, use:

```gradle
  // Turn some Javadoc warnings into errors.
  options.addStringOption('Xwerror', '-Xdoclint:all,-missing')
```


It seems that to reference a nested/inner class in Javadoc requires giving
the fully-qualified class name.


To find Javadoc comments that use "<" or ">" but shouldn't

```sh
search -i -n '^ *\*.*(<[^/]|>)'
```

and then, in the result

```elisp
(query-replace-regexp "</?\\(li\\|p\\|b\\|tt\\|pre\\|i\\|a\\|a [^<>]*\\|blockquote\\|ul\\|code\\|em\\|strong\\|br\\)>" "" nil (if (and transient-mark-mode mark-active) (region-beginning)) (if (and transient-mark-mode mark-active) (region-end)))
```

and finally look for instances of `[<>]`.


The error message

```text
com.sun.tools.javac.code.Type$AnnotatedType cannot be cast to com.sun.tools.javac.code.Type$ClassType
```

is due to this JDK bug:
<https://bugs.openjdk.java.net/browse/JDK-8215542>.
It is fixed in JDK 9 ea b14 onwards.


Always run Javadoc with `-notimestamp`, to minimize gratuitous diffs.
A problem is that `-notimestamp` may get passed to doclets, so they need to be able to handle it.
In gradle, use

```gradle
  options.noTimestamp(false)
```

to not pass `-notimestamp`.


To resolve Javadoc errors like

```text
 package com.sun.tools.javac.api is not visible
 package com.sun.tools.javac.code is not visible
 package com.sun.tools.javac.main is not visible
 package com.sun.tools.javac.tree is not visible
 package com.sun.tools.javac.util is not visible
```

add to javadoc task in `build.gradle`:

```gradle
    options.addStringOption('source', '8')
```


Javadoc links:

* under JDK <= 17, use JDK 8 links
* under JDK > 17 (i.e., JDK >= 18), use JDK 17 links, and "--link-modularity-mismatch info"



## Command-line options


To run Java with a maximum of 4GB of memory:

```sh
  java -Xmx4g ...
```

To see the defaults:

```sh
java -XX:+PrintFlagsFinal -version | grep HeapSize
```

To see some environment variables that may affect the max size of the Java heap:

```sh
echo JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS"
echo JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS"
echo _JAVA_OPTIONS="$_JAVA_OPTIONS"
echo DEFAULT_JVM_OPTS="$DEFAULT_JVM_OPTS"
echo GRADLE_OPTS="$GRADLE_OPTS"
echo JAVA_OPTS="$JAVA_OPTS"
```


Setting Java command-line options, such as for max memory (RAM) size of the heap:
Precedence:

```text
  JAVA_TOOL_OPTIONS (weakest)
  JDK_JAVA_OPTIONS (JDK 9+, only applies to `java`, not `javac`, `jar`, etc.)
  Command line parameters
  _JAVA_OPTIONS (strongest)
```

Environment varibales used by Gradle (I don't know what the precedence is)

```sh
  DEFAULT_JVM_OPTS='-Xmx4g'
  GRADLE_OPTS='-Xmx4g'
  JAVA_OPTS='-Xmx4g' # also used by some other programs, maybe
```


"Could not reserve enough space for object heap" means that the
"-Xmx" argument on the java command line was too large.



## Everything else


JDK 1.4 is still distributed, but at an obscure URL:
 <http://java.sun.com/javase/downloads/jdk/142/>
Or, at <http://java.sun.com/javase/downloads/>, click on "Previous Releases".


To get a copy of the JDK 7 source:
  hg clone <http://hg.openjdk.java.net/jdk7/jdk7/jdk>


Major version number for the Java class file format (JVM version numbers)

* J2SE 26.0 = 70 (0x46 hex)   [released March 2026]
* J2SE 25.0 = 69 (0x45 hex)   [released September 2025; LTS version]
* J2SE 24.0 = 68 (0x44 hex)   [released March 2025]
* J2SE 23.0 = 67 (0x43 hex)   [released September 2024]
* J2SE 22.0 = 66 (0x42 hex)   [released March 2024]
* J2SE 21.0 = 65 (0x41 hex)   [released September 2023; LTS version]
* J2SE 20.0 = 64 (0x40 hex)   [released March 2023]
* J2SE 19.0 = 63 (0x3f hex)   [released September 2022]
* J2SE 18.0 = 62 (0x3e hex)   [released March 2022]
* J2SE 17.0 = 61 (0x3d hex)   [released September 2021; LTS version]
* J2SE 16.0 = 60 (0x3c hex)   [released March 2021]
* J2SE 15.0 = 59 (0x3b hex)   [released September 2020]
* J2SE 14.0 = 58 (0x3a hex)   [released March 2020]
* J2SE 13.0 = 57 (0x39 hex)   [released September 2019]
* J2SE 12.0 = 56 (0x38 hex)   [released March 2019]
* J2SE 11.0 = 55 (0x37 hex)   [released September 2018; LTS version]
* J2SE 10.0 = 54 (0x36 hex)   [released March 2018]
* J2SE 9.0 = 53 (0x35 hex)    [released September 2017]
* J2SE 8.0 = 52 (0x34 hex)    [released March 2014; LTS version; last update Jan 2019 (commercial), Dec 2020 (non-commercial)]
* J2SE 7.0 = 51 (0x33 hex)    [released July 2011]
* J2SE 6.0 = 50 (0x32 hex)    [released December 2006, public beta Feb. 2006]
* J2SE 5.0 = 49 (0x31 hex)    [released September 2004]
* JDK 1.4 = 48 (0x30 hex)     [released February 2002]
* JDK 1.3 = 47 (0x2F hex)     [released 2000]
* JDK 1.2 = 46 (0x2E hex)     [released 1998]
* JDK 1.1 = 45 (0x2D hex)     [released 1996]


To pretty-print or indent a Java program, do "java JavaPP filename.java".
Or, use my shell script "javapp file1.java file2.java file3.java ...",
which overwrites the original file.


java.lang.Class.forName requires different versions of the string
representation of a class as its argument depending on whether you want to
get back an array or not.  For instance, these are legal:

```java
  Class.forName("[Ljava.lang.Integer;")
  Class.forName("java.lang.Integer")
```

but this is not:

```java
  Class.forName("Ljava.lang.Integer;")
```


Java file reading usually permits either \n or \r\n to end a line.
However, if the first character of a file is \n, Java file reading seems to
produce blank lines for each subsequent \r\n.


Java 1.5 meta-data facility (annotations) (JSR 175) implements meta-data tags:
<http://www.jcp.org/en/jsr/detail?id=175>


JWhich tells where on the classpath a Java file is found.
I have a "jwhich" shell script wrapped around this.


In Java, "null instanceof Class" returns false for any Class.


Canonical use of package java.util.regex.* for Java regular expressions:

```java
  Pattern p = Pattern.compile("a*b");
  Matcher m = p.matcher("aaaaab");
  boolean b = m.matches();              // exact match (whole target string)
  boolean b = m.lookingAt();            // subsequence starting at beginning
  boolean b = m.find();                 // subsequence
  String g = m.group(2);                // text captured by the given group
```

or, less frequently,

```java
  boolean b = Pattern.matches("a*b", "aaaaab");
```


Here are ways to parse arrays without loops and repeatedly taking substrings:

```java
  private static Pattern arrayBracketsPattern = Pattern.compile("(\\[\\])+$");
  ...
    Matcher m = arrayBracketsPattern.matcher(typename);
    String classname = m.replaceFirst("");
    int dimensions = (typename.length() - classname.length()) / 2;
```

```java
  private static Pattern fdArrayBracketsPattern = Pattern.compile("^\\[+");
   ...
    Matcher m = arrayBracketsPattern.matcher(typename);
    String basename = m.replaceFirst("");
    int dimensions = typename.length() - classname.length();
```



Java issues (bug reports, RFEs, etc.):  <http://bugs.sun.com/bugdatabase/>


LVTT - Local Variable Type Table
Errors can occur when instrumenting with BCEL.  One error is

```text
     LVTT entry for 'list' in class file daikon/dcomp/Test does not match any LVT entry
```

The easiest solution I've found so far is to simply remove these tables.
They are only used by debuggers and when instrumenting, that is seldom
an issue.  utilMDE/BCELUtil has a method (remove_local_variable_type_tables)
that does this for a method.


Java classes are top level or nested:

```java
class TopLevel {
  // Java member classes are of two varieties:  static and inner.
  static class StaticMember {}
  class Inner {}
  void m() {
    class Local {}
    // this "new" expression creates an instance of an anonymous class
    new SuperTypeOfAnonymousClass() { ... }
  }
}
```


To determine which class files require a given JDK version (or earlier):

```sh
  find | xargs java ClassFileVersion -min 1.6 | grep -v "is neither a"
```

This is good for debugging errors of the form
  Exception in thread "main" java.lang.UnsupportedClassVersionError: Bad version number in .class file
that give no indication of what .class file was problematic.


To execute a shell command in Java:

```java
Runtime.getRuntime().exec(String [] cmdarray);
```


In Java, File.getName() returns the basename:  no directory components, but
does include the filename extension.


After starting jdb, do something like
  stop in utilMDE.JWhich.main
  run
lest when you issue the "run" command the application continues to termination.


In Java, to iterate over the elements of a HashMap, do:

```java
    for (Map.Entry entry : hash_map.entrySet()) {
      ... entry.getKey() ...
      ... entry.getValue() ...
    }
```

To iterate over the values:

```java
    for (ValType value : hash_map.values()) {
      ...
    }
```


A disadvantage of the new-style for loop is that there is no name for the
iterator, so there is no way to access important information such as the
current index or other information that a specialized iterator may make
available.

  A way to get around this is for a single object to implement both
Iterator and Iterable.  The Iterable.iterator() method would just return
"this", and within the foor loop body, the client can refer to the iterable
to obtain the desired information.

  The problem with this design is that it assumes that there is exactly one
iterator for the object at a time.  Clients may expect that it is possible
to have multiple iterators over a given Iterable, and thus may expect that
each call to Iterable.iterator returns a fresh iterator that shares no
state with other iterators.  But. clients really shouldn't assume this in
the absence of documentation so stating, and if something is both an
Iterable and an Iterator, it's intuitive (and should be documented) that
iterator() would return itself.



Notes about Java instrumentation:
Instrumenting annotation classes by adding parameters will cause
annotation to not be handled correctly.
Methods in an Annotation class can not have any parameters.  When you
add the DCompMarker parameter to those methods, AnnotationType will
throw an IllegalArgumentException.  This (unfortunately) does not
show up directly, but only results in the retention policy being set
to its Class (the default) rather than to what the user wanted (eg,
RUNTIME).  This manifested itself in our case by having the Option
annotations disappear (thus making it impossible to parse command line
options).  I think it should be safe to simply not add arguments to
Annotation methods.  Since these 'methods' aren't executable anyway.


replacing rt.jar
It is possible to override/replace the system rt.jar using the
-Xbootclasspath switch to java.  The documentation says that doing so
violates Sun's license agreement.  It is not clear why this is true.


You can turn off the verifier on any VM with -Xverify:none.  Derek discovered
this like so

```sh
$ strings `which java` | grep -i verif
-Xverify:all
-verify
-verifyremote
-Xverify:remote
-noverify
-Xverify:none
```


Jardiff takes two jar files and outputs all the public API changes.
<http://www.osjava.org/jardiff/>


To read a file line by line from Java use

```java
    BufferedReader br = new BufferedReader (new FileReader (filename));
    for (String line = br.readLine(); line != null; line = br.readLine())
        ;
```

Unfortunately, this will throw IOExceptions.  I don't know of any standard
Java class that does not.

Or, to read lines with line numbers use

```java
    LineNumberReader lr = new LineNumberReader (new FileReader (filename));
    for (String line = lr.readLine(); line != null; line = lr.readLine())
        lr.getLineNumber();
```

Or, you can use utilMDE.EntryReader which supports the new-style for loop.


Don't use Runtime.exec(); instead, use ProcessBuilder.start().


Here is how to set JAVA_HOME portably (including on Linux and Mac OS X).

In a sh script:

```sh
if [ "$(uname)" = "Darwin" ] ; then
  export JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home)}
else
  export JAVA_HOME=${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(which javac)")")")}
fi
```

In a Makefile:

```make
ifeq ($(shell uname), Darwin)
  JAVA_HOME ?= $(/usr/libexec/java_home)
else
  JAVA_HOME ?= $(shell readlink -f /usr/bin/javac | sed "s:bin/javac::")
endif
```


`JAVA_HOME` is the JDK install directory, e.g., ...jdk1.7.0 .
`java.home` is the JRE install directory, e.g., ...jre .
(See <http://javahowto.blogspot.com/2006/05/javahome-vs-javahome.html> .)


When you deprecate a method, also make it final.  That way you will find
places that it is overridden (because they won't compile any longer).


A way to iterate over the lines in a file is:

```java
BufferedReader br = new BufferedReader(new FileReader(file));
for (String line; (line = br.readLine()) != null; ) {
   ... // do stuff with line here  
}
```


This command lists all supertypes of all .class files in the current directory or below.

```sh
javap -v `find . -name '*.class'` | egrep '^(public |protected |private |abstract |default |static |final |transient |volatile |synchronized |native |strictfp )*(class|interface) .*(extends|implements)' | perl -p -e 's/<[^<>]*>//g' | perl -p -e 's/<[^<>]*>//g' | perl -p -e 's/(^.*?\b(class|interface) | extends | implements |, *)/\n/g' | perl -p -e 's/\$.*//g' | sort | uniq
```


SLF4J API:
<https://www.slf4j.org/apidocs/index.html>
The 5 error levels are:
ERROR, WARN, INFO, DEBUG, TRACE


To validate a class file (from <https://asm.ow2.io/faq.html>):

```sh
cd ~/tmp
VER=6.2.1
wget https://search.maven.org/remotecontent?filepath=org/ow2/asm/asm/${VER}/asm-${VER}.jar -O asm-${VER}.jar
wget https://search.maven.org/remotecontent?filepath=org/ow2/asm/asm-tree/${VER}/asm-tree-${VER}.jar -O asm-tree-${VER}.jar
wget https://search.maven.org/remotecontent?filepath=org/ow2/asm/asm-analysis/${VER}/asm-analysis-${VER}.jar -O asm-analysis-${VER}.jar
wget https://search.maven.org/remotecontent?filepath=org/ow2/asm/asm-util/${VER}/asm-util-${VER}.jar -O asm-util-${VER}.jar
java -cp "asm-${VER}.jar:asm-tree-${VER}.jar:asm-analysis-${VER}.jar:asm-util-${VER}.jar" org.objectweb.asm.util.CheckClassAdapter ~/tmp/plume-util-1.0.3-jar/org/plumelib/util/OrderedPairIterator.class
```

but for me this just crashed rather than giving a useful result.


To convert a .jar file to a module:

```sh
jdeps --generate-module-info . mylib.jar
javac --patch-module SOME.MODULE.NAME=mylib.jar module-info.java
```


Here is a formula to make a jar file into a modular jar file.

```sh
usejdk11
JARPATH=checker-qual.jar
MODULENAME=org.checkerframework.checker.qual
jdeps --generate-module-info . $JARPATH
javac --patch-module $MODULENAME=$JARPATH $MODULENAME/module-info.java
jar uf $JARPATH -C $MODULENAME module-info.class
```


Command-line options for the Java module system:

* `--patch-module`
    It adds classes into a module.
    The replacement of
    -Xbootclasspath/p is the option --patch-module to override classes in a module. It can also be used to augment the contents of module. The --patch-module option is also supported by javac to compile code "as if" part of the module.
    You need to supply it *both* to `javac` and to `java`.
* `--add-exports` (use ALL-UNNAMED to give access from the *classpath*; is anything else required for modules?
   --add-exports <exporter-module>/<package>=<accessor-module>(,<accessor-module>)*
* `--add-opens` enables reflection
* `--add-modules`
   add modules (and their dependencies) to the module graph that would otherwise not show up because the initial module does not depend on them (directly or indirectly).
* `--add-reads $module=$targets` adds readability edges from $module to all modules in the comma-separated list $targets. This allows $module to access all public types in packages exported by those modules even though $module has no requires clauses mentioning them. If $targets is set to ALL-UNNAMED, $module can even read the unnamed module.


`com.sun.javadoc` is deprecated and superseded by `jdk.javadoc.doclet`.
`jdk.javadoc.doclet` only exists in Java 9 and later, so switching to it means losing support for Java 8.
Another difference is that Javadoc in JDK 8 supports this option:

```text
  -d <directory>                   Destination directory for output files
```

but in JDK9+, only the standard doclet supports it.
Documentation on using the new Doclet API:
<https://openjdk.java.net/groups/compiler/using-new-doclet.html>
Gradle always passes the -d command-line argument.  Idea: If the doclet is always
run by itsef, on JDK 9+ it could support the `-d` command-line
argument, even if it ignores it.  But if the doclet is run together with the
standard doclet, I'm not sure that is the right thing.
You can use `title = ""` to prevent gradle from passing other command-line arguments.


Many Java `equals` methods should look like this:

```java
  public boolean equals(Object o) {
    return (o != null)
        && super.equals(o)
        && field1.equals(o.field1)
        && field2.equals(o.field2)
        && field3.equals(o.field3);
  }
```

Every Java `hashCode` method should look like one of these:

```java
  // If superclass has any fields.
  @Override
  public int hashCode() {
    return super.hashCode() + Objects.hash(field1, field2, field3);
  }
```

```java
  // If superclass has no fields (e.g., the superclass is java.lang.Object).
  @Override
  public int hashCode() {
    return Objects.hash(field1, field2, field3);
  }
```


In Java, `String.format` is much slower than string concatenation with `+`.
Multiple string concatenation with `+` gets converted into an efficient
StringBuilder, but not if there are potetnial side effects, so put any
computations into a local variable before doing the string concatenation.
(Or just use a StringBuilder directly, rather than repeated string
concatation.


`jshell` is a Java interpreter or REPL (read-eval-print loop).


In Java, an array's component type is the type of values retrieved directly from it.
An array's element type is a non-array type, obtained by taking component types as long as possible.
For example, the component type of `int[][]` is `int[]`, but its element type is `int`.


The `map` function over a list is implemented in Java as:

```java
Collection<E> c = ...
Object[] mapped = c.stream().map(e -> doMap(e)).toArray();
List<E> mapped = c.stream().map(e -> doMap(e)).collect(Collectors.toList());
```


To obtain the classpath at run time, on any JDK:

```java
# Get latest release number from https://github.com/classgraph/classgraph
dependencies {
  implementation 'io.github.classgraph:classgraph:4.8.110'
}
...
import io.github.classgraph.ClassGraph;
import java.net.URI;
...
List<URI> classpath = new ClassGraph().getClasspathURIs();
```

This is more reliable (works across JDK vernions) than
`((URLClassLoader) ClassLoader.getSystemClassLoader()).getURLs()`.


From a shell or bash script, to determine or test the Java version number:

```sh
java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1 | sed 's/-ea//'
```


To test the Java or JDK version number from a Unix shell command line
(from <https://stackoverflow.com/a/56243046/173852>):

```sh
JAVA_VER=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1 | sed 's/-ea//') && \
[ "$JAVA_VER" = "8" ] && make || echo "Use Java 8"
```


javax.tools.JavaCompiler is the user-visible, supported API.
com.sun.tools.javac.main.JavaCompiler is the internal implementation.  While it is not officially supported (it may change at any time), it has more methods and more functionality.


To replace uses of the deprecated `new URL()` constructor:

```java
        URL url = URI.create(filename).toURL();
```


In Java, to access a private field in `obj` via reflection and changing access modifiers:

```java
Field f = obj.getClass().getDeclaredField("fieldIWant"); // possible NoSuchFieldException
f.setAccessible(true);
value = f.get(obj); // possible IllegalAccessException
```


Here is Oracle's migration guide from java.io.File to java.nio.file.Path:
<https://docs.oracle.com/javase/tutorial/essential/io/legacy.html>


If you are targeting Java 17, then you should not use types like `Pair` and
`Triplet` (say, from the `org.javatuples` package).  A record:

* is very little code to define (thus, little code clutter),
* has a shorter name than an instantiated tuple (thus, less code clutter),
* is type-safe (you can't accidentally use one in the wrong context, as you can for a `Pair<String, String>`),
* is much more readable at uses (`mySextet.getValue3()` is inscrutible.  When using the `org.javatuples` package, it is also misleading.  When not indexing into a list or array, one starts counting at one rather than zero.  However, `getValue3()` is the *fourth* element of the sextet, which is rather surprising!)


Jacoco's "instruction coverage" is bytecode instructions.
Jacoco's "branch coverage" is branch coverage of bytecode conditions (= bytecode decisions).  It reports each direction of a boolean condition (= boolean expression) separately.
For example, `if (a > 0 && b > 0)` has 4 branches:  the true and false branches of `a > 0` and the true and false branches of `b > 0`.
Jacoco cannot compute source-code-level line, decision, or MC/DC coverage.
There are visualization tools that map Jacoco's output to source code lines, but that doesn't really give source-code-level coverage information.


The Java variant of the Google diff-match-patch program is not available on
Maven Central (except in some old and/or renamed versions), so it's best to
incorporate it directly in a project.  Its license (Apache 2.0) is compatible
with other lax licenses such as the MIT License.
Then, use:

```java
import name.fraser.neil.plaintext.diff_match_patch;
import name.fraser.neil.plaintext.diff_match_patch.Diff;
```


This talk says that in Java, no non-LTS version has ever passed 1% of market share:
<https://www.youtube.com/watch?v=SYO-LmA647E&t=186s>
However, this chart shows that developers are using non-LTS versions at considerable
rates (along with LTS versions too, which are more widely used):
<https://www.jetbrains.com/lp/devecosystem-2023/java/>



The Java diff_match_patch program creates Patch objects that have a leading and
a trailing EQUAL component, even with `Match_Threshold` and
`Patch_DeleteThreshold` set to 0.


Using Guava in a build.gradle file:

```gradle
// Using Guava also requires this, unfortunately, to avoid "class file for javax.annotation.meta.TypeQualifierDefault not found".
annotatedGuava 'com.google.code.findbugs:jsr305:3.0.2'
```


There is no longer a maintained (or even functional) version of Jar Jar Links (aka JarJar Links).
It just uses ASM for renaming, so use that directly.


Typical commands for Java native compilation with GraalVM:

```sh
./gradlew -Pagent test
./gradlew metadataCopy --task test --dir src/main/resources/META-INF/native-image
./gradlew -Pagent nativeTest
./gradlew nativeCompile
```


Java collection libraries:
For caching, use Caffeine (<https://github.com/ben-manes/caffeine>) rather than Google Guava.
Prefer Eclipse Collections over Guava?  Faster, less memory, smaller package.
There is little need for multimap and multisets with computeIfAbsent.


native compilation with picocli:

./gradlew -Pagent test
./gradlew metadataCopy --task test --dir src/main/resources/META-INF/native-image
./gradlew -Pagent nativeTest
./gradlew nativeCompile

# Binary at: build/native/nativeCompile/plumelib-merge-tool


To determine the default character set of the Java JVM, run these commands:

```sh
echo "public class DefaultCharset {
 public static void main(String args[]) throws Exception{
  // not crossplatform safe
  System.out.println(System.getProperty(\"file.encoding\"));
  // jdk1.4
  System.out.println(
     new java.io.OutputStreamWriter(
        new java.io.ByteArrayOutputStream()).getEncoding()
     );
  // jdk1.5
  System.out.println(java.nio.charset.Charset.defaultCharset().name());
  }
}" > DefaultCharset.java
javac DefaultCharset.java
java DefaultCharset
```


//  LocalWords:  jtrek JIT Djava Throwable printStackTrace Ljava toc java ps1 jdb TestRunner cp MyTestClass Hamcrest assertFalse assertThat assertTrue assertEquals SIGQUIT LinkedHashMap LinkedHashSet HashSet listFiles segfaults VM jstack wiki JavaHeap JavaTools hprof Xrunhprof cpu currentTimeMillis wallclock JLS JLS3 Xlint compilerarg Xmx1024M
//  LocalWords:  Solaris setenv invokevirtual invokestatic JavaPP filename javapp
//  LocalWords:  javadoc cd utilMDE subpackages dirname uniq perl HashMap itor Xmx
//  LocalWords:  entrySet getKey getValue ValType Mbytes forName JUnit ps jswat
//  LocalWords:  PublicTest ProfileViewer javac JSR JWhich classpath jwhich pid
//  LocalWords:  instanceof traceback ctrl aaaaab boolean lookingAt unjar jdk src
//  LocalWords:  RFEs LVTT BCEL daikon LVT BCELUtil
