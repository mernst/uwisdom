# Tools for manipulating Java programs


On github.com, you can view the table of contents of this file by clicking the
menu icon (three lines or dots) in the top corner.


One advantage of ASTs is that they give information about variable scope.


In javac, the best place is probably just after a ClassDeclaration is set
to CS_CHECKED (but then I'll want to re-check it, no?); that is in
SourceClass.check or SourceClass.checkInternal.
Possibly I would rather do this just before that happens (so I don't try to
check and get number-of-arguments errors), after it's set to CS_PARSED.
This would be after endClass (I think; beginClass actually sets the
status to CS_PARSED, but the parsing isn't done yet then), or possibly just
do this immediately before SourceClass.check (though is that too late?).
  Some control flow analysis (on bytecodes) in
src/share/sun/sun/tools/debug/FlowTracer.java


(Email I sent (long ago) looking for additional suggestions.)


I want to instrument Java code, primarily to add instructions for writing
out the run-time values of certain variables.  Ideally, I would locate a
system which reads either .java or .class files, presents me with a
convenient intermediate representation, and then outputs some compilable
form (such as .class, Java, or C files).  The intermediate representation
should permit me to

* locate all uses/updates of a particular variable
* determine all variables in scope at a particular program point
* locate all procedure exits
* add instrumentation code, including new (class, member, and local) variables
* perhaps write other analyses


I've found a dozen or two systems which show some promise, but none of them
is perfect.  There seem to be four different tacks I could take:

* source-to-source with a grammar and AST
   examples: JavaCC (with JJTree or JTB), SableCC, ANTLR, JavaCUP
* modify an existing Java compiler
   examples: Javac, Jikes, Pizza
* bytecode rewriting
   examples: ASM, BCEL, JOIE, BIT, BCA, Javassist
* decompiler or other tool to read .class files
   examples: Jasmine, some compilers (Toba, Harissa, Vortex); also see below


Each of these has its own advantages and disadvantages; I am leaning toward
modifying an existing Java compiler.  If you have any advice or
suggestions, I would be grateful to hear it.


Spoon Java analysis tool
<http://spoon.gforge.inria.fr/>
It seems to mostly be a wrapper around the AST, permitting analysis and transformation via Java code.


Gail Murphy says:
  The JavaCC approach has worked out fine, but does require writing a *ton*
  of support code: probably more than is worth it for what you want to do.
  [This isn't AST creation, traversal, or unparsing, but looking up types
  of imported and parent classes, and so forth.  It would be nice if I
  could get that from a compiler, though there would be more additional
  cruft than I really want.]  This also includes dealing with anonymous and
  inner classes, etc.


Questions:

* Includes Java grammar?
* Creates AST?
* Includes pretty-printer?


java_cup:

* grammar
* no ast
* no pp


JavaCC (<http://www.suntest.com/JavaCC/>) has JJTree which creates an AST
FAQ at <http://www.suntest.com/JavaCC/FAQ/faq.html> or <http://www.metamata.com/javacc/Faq/faq.html>

* grammar
* ast: JJTree (distributed with JavaCC) will create one.
   Also see <http://www.compapp.dcu.ie/CA_Software/lang/Java/JavaCC/DOC/JJTree.html>
* pp: the Pretty package does this, but it's from October, 1997
   requires changes to the grammar (maybe not any more).
   Supposedly supported by Sun.  (Where do I see that claim?)
   Pretty:
   <http://www.almide.demon.co.uk/source_code/java/JavaCC/Pretty/Pretty.html>
   1.0.1 ALPHA, updated Tue 23-Mar-99
   Pretty relies on JJTree.


SableCC creates an AST.  <http://www.sable.mcgill.ca/sablecc/>

* grammar; but the names of the elements are unusably long, must be changed
* ast
* tree walkers, but no unparsers

Apparently no analyses are provided.
They have a mailing list archive and seem decently active, but I don't know
what kind of support is available (or needed).
Marius Nita says (4/2009):
  SableCC keeps all concrete syntax except whitespace.  
  You can write visitors that visit only AST nodes, only tokens, or a  
  combination. Because it keeps concrete syntax details, writing a  
  deparser is pretty easy.


Soot is a Java bytecode analysis and transformation framework from McGill.
As of September 2003, Greg Kapfhammer recommends Soot:  he finds it easy to
use and understand, and it is very well-supported by a community of
developers and users on its mailing list.
Soot provides a three-address intermediate representation ("Jimple") that
frees you from having to think about JVM bytecodes or the stack.


JTB. <http://www.cs.purdue.edu/jtb/>

* grammar
* ast
* pretty-printer
     -printer creates TreeDumper and TreeFormatter methods;
     there is also visitor/JavaPrinter.java provided with the
     distribution; how do they differ  from TreeDumper and TreePrinter?
     (The distribution's  visitor/Printer.java is for JTB grammars.)

requires no change to the grammar.
children are accessed by position, not name.
  (partly fixed in JTB 1.1.2; use -f flag, but names still aren't great.
  A potential disadvantage of that field is incompatibility with JavaPrinter.)
JTB 1.3.2 (released Jan 2005) is most recent as of Feb 2010.  Sai Zhang
reports that JTB 1.3.2 seems to be incompatible with the latest JavaCC
(released in 2008).
So, JJTree, which builds on JavaCC in much the same way that JTB does, may
be a better approach.


ANTLR.  <http://www.ANTLR.org/>

* grammar
* ast
* tree walker, but no pretty-printer


Eclipse.  <http://www.eclipse.org/>
 Integrated IDE, AST, symbol table.  No unparser.
 As of August 2001, is still very rough, probably not worth using.  But
 Manos Renieris's opinion is that eventually it will be unstoppable.


"Barat is a front-end for Java. It parses source and byte-code, and
performs name and type analysis on demand."
 <http://www.sharemation.com/~bokowski/barat/index.html>
 <http://sourceforge.net/projects/barat>
Builds an AST.  Includes an unparser.  Apparently keeps around comments.
The AST built by Barat is a passive data structure which cannot be changed.
Parses the Java 1.1 language.


## Java compilers


<http://dir.yahoo.com/Computers_and_Internet/Programming_Languages/Java/Compilers/>


Most don't seem to do real optimizations or even create CFGs.  I would
probably have to do this myself.  The user interface could be most
convenient if we used this.


toba: <http://www.cs.arizona.edu/sumatra/toba/>
  reads .class files; outputs C; written in Java


Harissa: written in C; reads .class files; outputs C
  first major public release in January 1999; probably not stable enough
  1.0.2 JDK, I think


jikes: <http://www.research.ibm.com/jikes/>
  outputs .class files
  open source, written in C++ (which is kind of a minus:  I may want to get
    in the mind of the Java programmer while I'm doing this...)
  ast in ast.h; top level is CompilationUnit
  a feature is its incremental compilation, which I don't care about
  It took second place to javac in my evaluation, probably (but I don't
    remember the details) because I couldn't find the single place where I
    would have the AST conveniently available.  I'm not sure whether it
    *should* have taken second place.
  It is no longer maintained, and was never well-documented nor had
    community support.


J Accellerator: in Japanese


ElectricalFire: team disbanded


javac:  I have (physical) mailed my request for source code
  Gun has a copy of the 1.1.5 source.
  1.0.2 is in /uns/src/javasrc/src/share/sun/sun/tools/{javac,java,tree}
  1.1.5 is in ~/se/javasrc
  I didn't find "cfg" or "control.*flow" in the 1.0.2 source.


Vortex:  written in Cecil


AspectJ:  runs only on Windows


pizza: <http://www.cs.bell-labs.com/who/wadler/pizza/>
  Craig Chambers says to ask them for source and they'll probably provide
    it; he thinks it's well-written.
  It claims that sources are available, but actually it's distributed as
    .class files, and I didn't get any response from my query (not using
    Craig's name or my record, but polite) to <pizza@cis.unisa.edu.au>.


espresso: old version of pizza, now subsumed by it


Barat:  <http://www.inf.fu-berlin.de/~bokowski/javabarat/index.html>
  A Java front end that builds a complete abstract syntax tree from Java
    source code files, enriched with name and type analysis information, and
    supports regeneration of source code.
  Comes with a 38-page manual.
  Must send email to get the full version, which uses Poor Man's Genericity.


guavac: ftp://ftp.yggdrasil.com/pub/dist/devel/compilers/guavac/
  Written in C++, GPL'ed.
  This hasn't been updated since May 1998, apparently.
  Used by the PolyJ people at MIT.


KOPI a Completely Open Source Java Compiler
<http://www.dms.at/kopi>


Jackpot: a Java source code transformation framework.  Seems to be like
Eclipse refactorings.
<http://jackpot.netbeans.org/>
Perhaps it only works under NetBeans.


## Parsers


Parsers:

* JavaParser
   Widely used, but buggy in corner cases.
* Eclipse JDTParser and symbol resolver
   It's harder to use than JavaParser but more capable and better maintained.
  * EPL 2 is compatible with GPL.  See <https://www.eclipse.org/legal/epl-2.0/faq.php>.  Also, Wikipedia claims (this seems a bit inaccurate): "In terms of GPL compatibility, the new license [EPL 2] allows the initial contributor to a new project to opt in to a secondary license that provides explicit compatibility with the GNU General Public License version 2.0, or any later version. If this optional designation is absent, then the Eclipse license remains source incompatible with the GPL (any version)."
  * There is a grammar in ~/java/eclipse.jdt.core/org.eclipse.jdt.core.compiler.batch/grammar/java.g
  * I cannot compile Eclipse.  The setup suggests importing into the Eclipse IDE, which I don't want to use.  My attempts to compile with maven from the command line failed.  (Maybe this is because they have recently restructured their codebase?)
* Spoon uses Eclipse's JDT parser plus some custom code.  Easier to use than JDT.
   "Spoon is an open-source library to analyze, rewrite, transform, transpile Java source code."
   It is somewhat buggy.  (More so than JavaParser.)
* javac's parse tree -- not intended for external users (but Openrewrite uses it...)
   It uses a hand-written recursive descent parser:
   ~/java/jdk-openjdk/src/jdk.compiler/share/classes/com/sun/tools/javac/parser/JavacParser.java
   google-java-format uses the javac parser directly and it is quite a
   small amount of code, so using javac directly may not be so difficult.
   Maybe it is near here: <https://github.com/google/google-java-format/blob/4a22aab7b19a41d6267ea70c76f137a6fd49bc76/core/src/main/java/com/google/googlejavaformat/java/Formatter.java#L142>
   <https://github.com/google/google-java-format/blob/4a22aab7b19a41d6267ea70c76f137a6fd49bc76/core/src/main/java/com/google/googlejavaformat/java/JavaInput.java#L353>
   It does not retain comments, except for (optionally) Javadoc comments.
   javac's `keepComments` applies only to Javadoc comments.
* Openrewrite: <https://github.com/openrewrite/rewrite>
   This provides an AST that is built from the javac compiler's.
   Therefore, it is correct but may be harder to customize, unless I change javac too!
   In its source code, look for
    import com.sun.tools.javac.main.JavaCompiler;
    import com.sun.tools.javac.tree.JCTree;
   Essential parts are closed-source, such as serialization.  A user would
   have to re-create those from scratch.
* xtext uses ANTLR under the hood, and Java grammars for ANTLR exist; I
   don't know if any are up to date.
* EDG's JFE front end (commercial): <https://edg.com/java>
   As of Nov 2022, it mentions Java 7, but not more recent versions of Java.
* Java parser written in Python:
   <https://github.com/c2nes/javalang>
   As of June 2024, the most recent commit was Oct 2021.
* Java parser written in JavaScript:
   <https://www.npmjs.com/package/java-parser/v/2.0.0>


I recommend you to investigate how com.sun.tools.javac.main.JavaCompiler do symbol resolving. I think it is inside #enterTrees(List)
Also you may be interested in projectlombok.org

com.sun.tools.javac.comp.Resolve
Attr, Check, Infer and Resolve analyze all names and expressions within the program.
Flow performs static program flow analysis. It checks the following:

* Reachability: can a statement be executed?
* Definite Assignment: has a variable been initialized?
* Definite Unassignment: has a variable not been initialized?

attribute: Attributes the Syntax trees. This step includes name
resolution, type checking and constant folding.

Useful (but isn't deep):
<https://scg.unibe.ch/archive/projects/Erni08b.pdf>


## Pretty-printers/decompilers for .class files


Java decompiler CFR:
(cd ~/tmp && wget <https://github.com/leibnitz27/cfr/releases/download/0.148/cfr-0.148.jar>)
java -jar ~/tmp/cfr-0.148.jar ...


As of 2019, IntelliJ uses Fernflower
A clone is at <https://github.com/fesh0r/fernflower>


As of 9/2009, a survey paper "An evaluation of current Java bytecode
decompilers", by Hamilton and Danicic (appears in SCAM 2009), recommends:

* for javac-generated bytecodes, one of these:
    **Java Decompiler (<http://java.decompiler.free.fr/>)
    ** JODE (<http://jode.sourceforge.net/>)
* for arbitrary bytecode: Dava (<http://www.sable.mcgill.ca/dava/>)


David Saff recommends JAD.  Jeff Hoye does, too, as of 6/16/2008.
  <http://www.varaneckas.com/jad>
    OLDER:  <http://www.kpdus.com/jad.html>
  Written in C++, no source available.
Jad is no longer supported.  You can use JadRetro to enable it to work on
newer class files.


JD: <http://java.decompiler.free.fr/>
  A successor to JAD.  No command-line functionality:  only GUI and Eclipse.


DJ: <http://members.fortunecity.com/neshkov/dj.html>
  Windows only?


IceBreaker


WingDis: $40.  <http://www.wingsoft.com/wingdis.html>
  Was a Javaworld 1998 Editor's Choice finalist.


SourceAgain: $300.


ClassCracker:  about $55, doesn't work with Java 2.


Lists of decompilers:

* As of 2008, <http://stackoverflow.com/questions/272535/>
  * top recommendation: <https://github.com/java-decompiler>, still actively developed as of April 2015, but only has a GUI, no command-line tool.  Blech.
      As of 2024-12-14, last commit was 2020-02-26
* Sep 2002: <http://www.faqs.org/docs/Linux-HOWTO/Java-Decompiler-HOWTO.html>
   Has links to other resources
* July 1997 (two URLs for same article):
   <http://www.andromeda.com/people/ddyer/java/decompiler-table.html>
   <http://www.javaworld.com/javaworld/jw-07-1997/jw-07-decompilers.html>


jtrek's dump.  Leaves some "?" in file, so it isn't compilable...


Mocha: out of date


Jasmine:  <http://members.tripod.com/~SourceTec/jasmine.htm>
  An update to Mocha.
  Gun claims it's not actually an update to Mocha, but a disassembler; I
    suspect he was thinking of Jasmin, not Jasmine.
  The authors are not very good speakers of English.
  Shareware: $30.
  Non-registered version asks a question every time I run it.


"Java Decompiler Workshop 1.0", <http://www.megatrend.hu/jdw.htm>, is
actually a disassembler, not a decompiler, it seems.


## Bytecode/classfile instrumenters/processing/rewriters


Java class-file API:
<https://openjdk.org/jeps/484>
Objects are immutable, but there are builders (so one can build new class files) and transformers.  There is both a streaming and a materialized view of a classfile.


Comparison of "Open Source ByteCode Libraries in Java"
(really just a list of them with a paragraph taken from each one's website,
and in no order (example: obsolete BCEL, last released in 2/2006) is still
2nd in the list as of 8/2013)):
<http://java-source.net/open-source/bytecode-libraries>


ASM:  <http://asm.objectweb.org/>
  As of June 2006 and August 2013, ASM is clearly the best tool.
  It is being maintained, it handles recent JVM classfiles, it is easy to use.
  Here is a comparison with BCEL and Javassist:
    `+http://mail-archives.apache.org/mod_mbox/jakarta-bcel-dev/200505.mbox/%3C9aface8705050312074a895525@mail.gmail.com%3E+`
  It says that ASM has no classloader related utilities.
  Many people say ASM is better than BCEL, but it doesn't look so much
  better that it's worth changing existing code, even if ASM is better for
  new projects.


WALA: <http://wala.sourceforge.net>
  IBM "T.J. Watson Libraries for Analysis" of bytecode.
  WALA is a subset of IBM's DOMO program analysis infrastructure.
  Seems like a good choice for new projects (as of late 2006).
  Should be solid, since it is used by commercial projects within IBM.
  Has lots of analyses built in, including a slicer.
  Documentation is a bit spotty (but so is that of other tools like Soot),
  since the developers are primarily trying to solve their own problems
  rather than support a community.
    wala.properties, the Java runtime directory is in "Getting Started":
    <http://wala.sourceforge.net/wiki/index.php/UserGuide:Getting_Started>
  There's a mailing list (approx 30 messages per month as of 2/2008) at
    <http://sourceforge.net/mailarchive/forum.php?forum_name=wala-wala>
  As of 4/2008, also has a front end for Java 1.4 source code built by Evan
    Battaglia (<elb@eecs.berkeley.edu>), but not yet a front end for Java 1.5
    (generics, annotations, etc.).
  CAst ("common AST"?) is a part of WALA.
  As of 7/2008, Stephen Fink says,
    The annotation support in WALA from class files is relatively new
    (under a year).  I don't think anyone has used it but me.  So it's
    rough, but it at least does something.
  WALA comes with a Shrike bytecode rewriting tool, but the WALA
  contributors say that ASM is better for bytecode manipulation projects:
  <https://groups.google.com/forum/#!search/asm$20vs$20wala/wala-sourceforge-net/l1G-1xdrZgw/V49k407sDysJ>
  WALA is really intended more for code analysis.


Javassist: <http://www.csg.is.titech.ac.jp/~chiba/javassist/>
  Like BCEL, but includes both a high-level (source code) and a low-level
  (bytecode) interface.
  As of 8/2013, the last release is version 3.12.0.GA, dated 7/2011.
  As of 3/2016, the latest release is verssion 3.20.0-G, dated 6/2015.


The "Java SE Development Kit (7u45) Demos and Samples" contains
java_crw_demo.[c,h].  This is a byte code rewriter that is used in hprof
(and other applications).  It allows you to inject code, but does not
appear to allow you to create new variables.


Serp:  <http://serp.sourceforge.net/>
  As of 8/2013, the download links at <http://serp.sourceforge.net/#download>
  are broken and the CVS repository at
  <http://sourceforge.net/p/serp/code/?source=navbar> seems to have been
  cleaned out.


Jrat: Java runtime analysis toolkit
jrat.sourceforge.net


BCEL:  <http://jakarta.apache.org/bcel/>
  An API to class files; permits modification of them.
  (previously named JavaClass:  <http://www.inf.fu-berlin.de/~dahm/JavaClass>)
  BCEL was the long-time standard, but its developers abandoned it to build ASM.
  Version 5.2 was released in June 2006.
  As of 2013, BCEL is receiving some maintenance.  See the repository:
    svn checkout <http://svn.apache.org/repos/asf/commons/proper/bcel/trunk> bcel
  For example, this version might support updating the stack map table.
  BCEL example (reference implementation of application tracing):
    <http://www.geocities.com/mcphailmj/Trace/>:
  Code analysis (but WALA is better for bytecode analysis):

* bcel.verifier.structurals framework for code analysis
* jDFA: dataflow analysis framework, using BCEL:  <http://jdfa.sourceforge.net/>


JOIE: The Java Object Instrumentation Environment
  <http://www.cs.duke.edu/ari/joie/>  (Duke and IBM)
  ftp://ftp.cs.duke.edu/pub/gac/joie0.10a.jar
  Requires (physically?) signing a license
  Enhanced class loader implementation; that means I deal with bytecodes.
    Gun suggests staying away from class loaders...
  Includes an example of a single dirty bit for all instance variables (but
    suggests that a more complete example would build control flow graphs
    to avoid overhead of setting the bit multiple times, etc.).
  Can add fields to a class.
  After 4 days I finally got a response from Duke; mail to IBM bounced
    (I didn't try the address on the paper, only one I found on the web).
  Can remove/modify instructions
  Gail Murphy says:
    Here's a couple of problems I've run into (based on a few hour look):
    *its supposed to handle instrumentation of System classes, but
      its a bit murky as to what that actually means in practice.
      I had to muck with the JOIE code to try and resolve some loading
      problems (the method were sitting there but not hooked in
      the framework I would have thought).
    * the transformers must be stack neutral
    * you can't necessary determine the procedure exits easily. Probably
      wrapping the methods is the easiest way to handle this.
  I tried to use JOIE but found many, many bugs; the author did respond to
    my bug reports, but he did not test his changes at all, so sometimes the
    same problem remained, but on a less trivial example (I'd sent him very
    small ones).  He also appears not to have a test suite, so this isn't
    worth the pain to me.


BIT: Bytecode Instrumenting Tool
  <http://www.cs.colorado.edu/~hanlee/BIT/>
  Requires physically signing a license
  May only permit adding instructions, not fields


BCA: <http://www.cs.ucsb.edu/oocsb/papers/TRCS97-20.html>
  Requires modified JVM, rather specific delta files.


Digital JTrek: <http://www.digital.com/java/download/jtrek/index.html>
  (or directly: <http://www.digital.com/java/download/jtrek/download.html>)
  Only in .class file format.
  Only two example instrumentations.
  At least it's available!
  Includes a decompiler ("dump")
  It looks like this only permits inserting calls, not (say) adding variables.


ClassFilters:  <http://www.cs.uni-bonn.de/~costanza/ClassFilters/>
  Looks just like JOIE; modifies class files at load time.
  "A description about how to write a ClassFilter is not yet available.
    NOTE: The ClassFilters package has been written within a few days. It has
    not been extensively tested. It may contain bugs. It is just meant as an
    experimental try, nothing else!"
  Requires JDK 1.2.  (I'm not sure why it requires the extensions framework.)


Cider: <http://tochna.technion.ac.il/project/CIDER/html/CIDER.html>
  Interactive tool


Kimera: Gun Sirer and Brian Bershad
  Must sign a nondisclosure agreement of some sort.
  Is supposedly industrial strength.
  Only supports what they have needed so far.
  Ignores all debugging info.


gnu.bytecode:  A package to create, read, write, and print .class files.
It's part of the Kawa Scheme interpreter.
<http://www.gnu.org/software/kawa/api/gnu/bytecode/package-summary.html>
Documentation doesn't seem stellar.
Also see <http://www.gnu.org/software/java/java-software.html>


## Bytecode instrumenters and other tools


From David Saff, October 3, 2004:


One note of general use to the group, I guess most specifically people
considering packages for utilities for Java bytecode instrumentation.  
I've now used tools from the following four toolkits: the JDK, BCEL,
jad, and JODE.  The three main tasks I've used them for are
instrumentation (changing bytecodes in compiled files), verification
(ensuring that the altered bytecodes encode valid Java classes, and if
not, why not), and decompilation (determining the meaning of the
generated Java classes, most usefully by recreating source code that
corresponds to it)


JDK:

* Bytecode instrumentation: you're on your own to edit bytes.
* Verification: The only verifier that matters, but diagnostic
information is severely lacking.
* Decompilation: Only disassembly.


BCEL:

* Bytecode instrumentation: very nice package
* Verification: on the one hand, overly picky.  On the other, when it
actually verifies all the aspects of your class except the one you
expected to fail, the diagnostic information is excellent.
* Decompilation: contains a "BCELifier" which, given a class, generates
BCEL code that would have generated that class file.


jad:

* Bytecode instrumentation: n/a
* Verification: n/a
* Decompilation: Very decent decompilation.  It does have an Eclipse
integration plug-in, which only works about half the time.  It's
closed-source and written in C.


JODE:

* Bytecode instrumentation: n/a
* Verification: the most useful of the verifiers.  Rarely gripes about
anything that Java itself wouldn't.  Diagnostics printed on verification
failures contain most of the information BCEL provides, but not in as
pretty or readable a format.
* Decompilation: at least as good as jad, in 100% open-source Java.  
This makes it easy to plug in a call to the decompiler wherever I want
during my class file's transformation, which is nice.  No Eclipse
plug-in, but the jad one wasn't that good anyway.


In summary, I find that using BCEL for instrumentation and JODE for
verification/decompilation is currently the best working environment for
me.  Your mileage may vary.


Kaffe: free Java VM, <http://www.transvirtual.com/>


Japhar: free Java VM


Rivet: <http://sdg.lcs.mit.edu/rivet.html>
Rivet is an extensible tool platform structured as a Java virtual
machine. The goal is to make advanced debugging and analysis tools
available to Java programmers. Rivet has a modular internal structure that
makes it easy to add new tools.
(Abandoned by 1999 or so.)


## Java test suites


TCK: Java Technology Compatibility Kits.  There is one for each JSR.  The
one for J2SE (Java language and VM) is called JCK, Java Compatibility Kit.
  <https://jck.dev.java.net/>
The JCK 5.0 Read-only source license only permits you to view and read the
sources; no other uses are permitted including compiling, executing, or
redistributing the sources.  For more on the license:
  <http://weblogs.java.net/blog/kgh/archive/2004/12/j2se_compatibil.html>
For commercial use, these licenses start at about $5OK, including some
minimal support.  TCK scholarships (free licenses) are available for
legitimate not-for-profit groups trying to pass the JCK. And typically we
also provide basic support.  For more details on the TCK scholarship program see:
  <http://java.sun.com/scholarship/>
  (application form: <http://java.sun.com/scholarship/application_form.txt> )
That appears to only apply to specific JSRs.


For the Java class libraries:

* Mauve: <http://sources.redhat.com/mauve/>
     The Mauve Project is a collaborative effort to write a free test suite
     for the Java class libraries.
     As of June 2004, it may not be dead:  the ChangeLog lists 104 checkins
     between January 1 and June 12.  The mauve-discuss mailing list does
     have a fair amount of volume (maybe 1 message per day?).
     However, the "Breaking news: Despite rumors to the contrary, Mauve is
     not dead." message has been on their homepage (with no new homepage
     content or announcements) for many years, and no messages have
     apparently been sent to mauve-announce since at least 2001.
     The 1999-03-03 snapshot didn't run right out of the box; as of that
     date, there were 87 classes (tests, I think).
For Java compilers:

* Jacks
   <http://sources.redhat.com/mauve/>
   (I think that this is only Java 1.4 as of May 2005?)
Performance-oriented:

* JavaSPEC


javacheck, javadis:  Gun's Java bytecode verifier and disassembler
        javacheck nameofclass
runs the verifier on the class. If the class is, say java.io.Reader,
you should invoke javacheck with `javacheck java/io/Reader`.
        javadis works the same way, except you can also use the -conspool
option to print out the constant pool entries. Javadis does not care
whether or not the .class suffix is at the end of the filename.


BCEL bytecode verifier: Diagnostics an order of magnitude better than
Java's built-in complaints.  However, it also gripes about some javac
quirks, which you have to work around or ignore.


## Java interpreter


<http://www.beanshell.org/>
Version 0.96 was released in January 1999.
As of 3/17/99, the author promises release to fix the known bugs "soon".
As of 5/12, that's still the current version, and the author says, "I hope
to put out a new release in the next few weeks."
A beta, Version bsh-2.0b4, was released May 2005, but no official release 2
has been made as of 10/12.


Java Expressions Library (JEL): <http://galaxy.fzu.cz/JEL/>
It's under GPL, so any program using it must be under GPL as well.
Fatally, it only seems to deal with numbers (and strings).
Instead, use BeanShell's eval().


Groovy console


Eclipse's "Scrapbook page"


DrJava


Metamata has a commercial product for semantic analysis of Java:
        <http://www.metamata.com>
It is not free but they do have an educational license program.
If you are intersted, send email to: <contact@metamata.com>.


## Java debuggers


* NetBeans Developer
   <http://www.netbeans.com/>
* Jikes debugger?  -- Windows only
* Interfaces to jdb:
    **ftp://ftp.ips.cs.tu-bs.de/pub/local/softech/ddd/
    ** <http://sunsite.auc.dk/jde/>
        I must set jde-db-source-directories or I won't get the "=>"
        current-line marker.
* AnyJ (an IDE)
* Java Workshop: <http://www.sun.com/workshop/java/download.html>
   See ~/wisdom/building/build-jws


<http://jswat.sourceforge.net/> -- a standalone GUI debugger


To run java so that a debugger can be attached, add the following to your commandline:
 -Xdebug -Djava.compiler=NONE -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000
You can use any port for address, but 8000 seems to be the standard one.


Jeff Perkins likes jdebugtool.com (<http://www.debugtools.com/>)
A script to start it is ~jhp/bin/jd:
  #! /bin/csh -f
  set jdir = "~jhp/j2sdk1.4.1_02"
  #set jdir = "/usr/local/pkg/java/java-1.4.1/j2sdk1.4.1_01"
  $jdir/bin/java -jar ~/jdebugtool/jdebugtool_jdk13.jar $*


"Omniscient debugger" lets you go backwards in time, heavy marketing hype:
<http://www.lambdacs.com/debugger/debugger.html>


JPDA is Java Platform Debugger Architecture, which is infrastructure for
building debuggers and such.


List of debuggers at <http://www.daimi.au.dk/~beta/ooli/Compare.html>
As of 6/2017, not updated since 8/2011.


## Compilers


The Flex compiler system built by Martin Rinard's group, over 100,000 lines
of Java for compilation and analysis. We've used it for doing our
compositional pointer and escape analysis, and are actively developing a
range of deep program analyses. It is also a complete compilation system,
with back ends to byte code, C, StrongARM assembly, and MIPS
assembly. Right now it reads in Java byte codes and builds an intermediate
representation based on a variant of SSA form.  See <www.flexc.lcs.mit.edu>.


## Pointer analysis


The GraalVM pointer analysis is fast and precise.


## Lightweight static checkers


findbugs:
findbugs.sourceforge.net
(From Bill Pugh at the University of Maryland.)


Checkstyle (download from Sourceforge, or "apt install checkstyle")
checks Java code, for instance indicating unused imports.


JLint:
<http://artho.com/jlint/>
Jlint 1.21 (since superseded):
<http://www.garret.ru/~knizhnik/>
The latest JLint crashed when I tried to run it (June 2004).


maudit (from metamata)
Metamata no longer exists (as a company), and I can't find this software
for download any longer.


lgtm.com issues false positive warnings, and I don't see how to suppress them.


## Profilers


jcmd can print a stack trace of a running Java program, at the current
moment.
This gives a poor man's version of profiling.


Baeldung's overview:
<https://www.baeldung.com/java-profilers>
It mentions JProfiler, YourKit, VisualVM, and others with smaller market
share.  It shows screenshots but gives no usage instructions.


### Profilers in the JDK


Flight Recorder:
...


jcmd views a running Java process.  I'm not sure whether it can profile a
Java application end-to-end.


Other profiling tools in the JDK are jconsole (time and space, by gui), jmap
(space), and jhat (space).


The Java Hotspot profiler is very fast but doesn't do attribution (only
local counts of time spent, not transitive for all calls within the method).
Without attribution, counts of time spent may not be very useful.


VisualVM is a well-regarded GUI for heap debugging.
It's free, from Oracle.


Eclipse's Memory Analyzer (MAT) is well-regarded for analyzing .hprof heap dumps.
It can be run as a standalone application.  To install:
<https://www.eclipse.org/mat/downloads.php>


## Other Java profilers


Yourkit, or YJP, is a Java profiler.
(Ilya Sergey of Jetbrains, Ivan Beschastnikh, and others say it is nice.)
<http://www.yourkit.com/>
Cost:

* Has an academic license for $99, via the Academic tab at: <http://www.yourkit.com/purchase/index.jsp>
* Free to open source projects "with an established and active community"
   in return for referencing them on the project web-page; see the "Open
   Source" tab at: <http://www.yourkit.com/purchase/index.jsp>


Oracle's VisualVM (<http://visualvm.java.net/>).


jvmtop: <https://github.com/patric-r/jvmtop>


Commercial products are sometimes superior for profiling, e.g. Borland
OptimizeIt or IBM/Rational Quantify or Yourkit.


<http://www.khelekore.org/jmp/tijmp/> -- works on Java 6 and later
  <http://www.khelekore.org/jmp/> -- only works on Java 1.2 to 1.5


JProfiler
<http://www.ej-technologies.com/products/jprofiler/overview.html>


ProfileViewer helps in interpreting Java profiling output.
<http://www.ulfdittmer.com/profileviewer/index.html>


OLD, no longer works in JDK 17:
java -prof
  puts output in java.prof


OLD, removed somewhere around OpenJDK 9:
But still available in VisualVM which Oracle still distributes.
java -Xrunhprof:cpu=samples ...
java -Xrunhprof:cpu=samples,heap=all ...
  Ignore all the "HPROF ERROR" output at the beginning of the run.
  Output appears in file java.hprof.txt .
  For command-line options, do
    java -Xrunhprof:help


## Java code coverage


* JaCoCo: <http://www.eclemma.org/jacoco/>
     (previously named Emma, <http://emma.sourceforge.net/>)
  * Codecov.io is GitHub integration with JaCoCo
* JCov is a Sun/Oracle tool that was open-sourced as part of the OpenJDK
     codetools project in 2014.
     But, the link to the manual from
     <https://wiki.openjdk.java.net/display/CodeTools/jcov> does not work.
* Clover:  <http://www.atlassian.com/software/clover/> (was <http://www.thecortex.net/clover/>)
     Instruments source code (most/all other tools instrument bytecode), so
     integration requires a build.
  * Clover's comparison of Clover, Cobertura, and JaCoCo:
 <https://confluence.atlassian.com/clover/comparison-of-code-coverage-tools-681706101.html>
* Cobertura: <https://github.com/cobertura/cobertura>
     As of 6/2018, last release is "version 2.1.1, 2015-02-26"
     You may have to remove DOS-style carriage returns from the scripts before
     running it.
* Rational's Visual PureCoverage
* JProbe coverage: <http://www.quest.com/jprobe/coverage-home.aspx>
     free trial version apparently available
* Gretel, Residual code coverage for Java:
     <http://www.cs.uoregon.edu/Research/perpetual/Software/Gretel/index.html>
* TCAT for Java for Windows (only; no Solaris)
     <http://www.soft.com/Products/Coverage.msw/tcatj.html>
     trial version available
* JIE does branch coverage


## Mutation coverage ("mutation testing") tools


For a much more complete survey, see Gareth Snow's report of June 2010.

* muJava
    Version 3 was released in November 2008.  It supports all of Java 1.5
    except generics (but lack of generics is a big omission!).
    "Source files are available on a limited basis to researchers in
    mutation analysis; please contact Offutt for more information."
    Brian Robinson of ABB chose this mutation tool, in summer
    2009, because his source code didn't use generics and he liked its
    infrastructure for running the tests.  mujava was able to generate
    mutants for 50% of his source files; I guess mujava crashed while
    processing the other half.
* Jumble.  Operates on classfiles.  Integrated with JUnit.  Released under GPL.
    As of 2/2009, latest release is 1.0.0, released 6/15/2007.
    But the version control repository shows commits in 2009; do
      svn co <https://jumble.svn.sourceforge.net/svnroot/jumble/trunk> jumble
    (or if the above gives an SSL error, use "http" instead of "https"??).
    The release contains only the same meager documentation as the website.
    Run it like this:
      java -jar jumble.jar MyClass
    which looks for tests in class MyClassTest, or name the tests
      java -jar jumble.jar MyClass MyTest1 MyTest2
* Javalanche.
    <http://www.st.cs.uni-saarland.de/mutation/>
    Webpage claims it will be made publicly available in August 2009.
* Test Police.  Not maintained since 2007 (as of 2/2009).
* Jester.  Operates on source code.
    Ported to Python and C#.
    At one time, was recommended by Kent Beck and Rusty Elliotte Harold.
    Jester 1.37 was released 2/26/2005 (that's the latest version as of
    2/2009).  Apparently no development has happened since then.
    Many broken links (esp. in documentation) at <http://jester.sourceforge.net/> .
    Recommended at JavaOne 2009.


On Oct 15, 2001, IBM released the Jikes Research Virtual Machine (formerly
Jalapeno) under an open-source license.
  Jikes RVM homepage: <http://www-124.ibm.com/developerworks/oss/jikesrvm/>
  Jalapeno research group homepage: <http://www.research.ibm.com/jalapeno>
  Press release:
  <http://www-124.ibm.com/developerworks/forum/forum.php?forum_id=362>


Branch coverage for Java:
  <http://glassjartoolkit.com/gjtk.html>
As of April 2002, it is in beta.  They will sell it to us (academic price)
for $99; we should buy it when it comes out.


## JVMs


Supporting Java 5.0:


Sun (obviously)


BEA has a free server-side JVM called JRockit:
    <http://dev2dev.bea.com/products/wljrockit/index.jsp>
Derek Rayside says (10/2002):
A friend of mine has had some good experiences with it for highly multi-
threaded I/O intensive programs.  They claim to scale almost linearly with
multiple processors.


Eclipse 3.1


Not supporting Java 5.0 (as of early 2005):


IBM
<http://www-128.ibm.com/developerworks/java/jdk/index.html>
JDK 1.4.2


Joeq (<http://sourceforge.net/projects/joeq>): JDK 1.4


Jikes RVM:
<http://jikesrvm.sourceforge.net/>
As of 3/24/2005, I can find no indication regarding whether it supports
Java 5.0.


VMs available as Debian packages (filtered output of "apt-cache search jvm"):
jamvm - Java Virtual Machine which conforms to JVM specification 2
  <http://jamvm.sourceforge.net/>
  1.2.5 was released 3/2/2005
  Does not appear to support Java 5.0
kaffe - A JVM to run Java bytecode
  1.1.4 was released 2/18/2004 (and thus does not support Java 5.0)
sablevm - Free implementation of Java Virtual Machine (JVM) second edition
  Does not appear to support Java 5.0


summer 2002:  KaffeOS Java (from Wilson Hsieh at the University of Utah)
virtual machine provides precise accounting of memory by applications.


Also see JMP, <http://www.khelekore.org/jmp/>.  Actively developed as of July
2003.


Sameer Ajmani says (10/2002):
Andrew Meyers's "Polyglot" framework permits easy construction of tools for
(dialects of Java); he has used it for three different such extensions so
far.


Kopi is a Java compiler that both Chandra Boyapati and Bill Thies have used
as a framework for Java language extensions (10/2002).
Patrick Lam abandoned it for Polyglot.


Polyglot only supports Java 1.4.  There is an extension for Java 5, but it
only supports a subset of the Java 5 features.  As of 4/2009, the latest
release is 3/2007.


JTest creates random unit tests based on the types of the arguments.
If pre- and post-conditions are present, then it additionally uses them.
(Gary Sevitsky and Tao Xie used it at IBM during summer 2002.)


Semantic Designs (<www.semanticdesigns.com>) offers Java/C++ front ends
(parser and unparser), designed for source-to-source transformation tools.
It's $5000 for an academic license ($50,000 for a commercial one).


## Improving startup time


GraalVM Native Image
This creates an ahead-of-time compiled binary that doesn't require any VM,
runtime, interpreter, etc.

```sh
javac HelloWorld.java
native-image HelloWorld
```

It is better if none of the code uses reflection, as the binary can be
faster.
It is especially good for very short-lived applications, as it eliminates
startup time.
It loses JIT compilation (except in the paid version), so it can be slower
for long-running applications (even 5 seconds).
It can be a bit difficult to adapt code for GraalVM (such as identifying
uses of reflection and other features).
The general consensus on Reddit is that it's not ready for prime time as of
mid-2024; that probably just means it is hard to use.


The ahead-of-time `jaotc` compiler was removed in JDK 16.  It's now only in GraalVM.


jpackage is a command-line tool to create native installers and packages
for Java applications.
The user doesn't have to install Java in order to run the application.
I don't think it does any optimization.
The jpackage tool takes as input a Java application and a Java run-time
image, and produces a Java application image that includes all the necessary
dependencies.
Maybe this obviates jlink?


jlink creates a self-contained executable.  It runs just like the regular
JVM (no new optimizations are enabled), but is smaller and thus loads
faster (the JVM starts up faster).
The executable includes a subset of the JRE, omitting features not needed for a particular program.
It might require modularization (Java modules).
jlink has command-line options for optimization.
jlink is quite solid and easy-to-use.
Figuring out what modules you need to ship can be done with the jdeps tool:
`jdeps --list-deps my.jar`.
JLink can replace JARs with an optimized file format called "jimage".


The CRaC (Coordinated Restore at Checkpoint) Project checkpoints (makes an
image of, snapshots) a Java instance while it is executing. Restoring from
the image leads to faster start-up and warm-up times.
Some documentation is at: <https://github.com/CRaC/docs/blob/master/STEP-BY-STEP.md>
It seems a bit involved, but might work well.
It's built into Azul Zulu builds of OpenJDK.
Also there are releases at <https://github.com/CRaC/openjdk-builds/releases> .
Given that warm-up is required, this might be more appropriate for servers
(which warm up and continue running, servicing new requests) than for an
end-to-end program.  Or for one that can be warmed up by running on a
particular workload, and then takes input (maybe on standard in?).


Azul Platform Prime's "ReadyNow" caches JIT work so an app starts running
optimized compiled code as soon as it reaches main().


AppCDS (Application Class Data Sharing).
It preloads (parses, verifies, etc.) certain classes and stores them in a
file in a binary form that allows direct mapping the image into the address
space of JVM.  This can be done for JVM classes, but also for application
classes.  The JDK already does this for JVM classses, automatically.  The
biggest benefits come when multiple apps are running and share the AppCDS
information; for one application running, it isn't much of a win.


Write the Java program as a server that services requests, to avoid the
cost of JVM startup and to make CRaC applicable.
This may greatly complicate the application in question.


micronaut is a framework for microservices.  I doubt that I want to add
another framework.  It supports CRaC.


Quarkus is a framework for kubernetes.  It supports CRaC.


Nailgun is no longer maintained.


## Slicers


Many papers claim results from a slicing tool (for example, there is a long
series of papers from Georgia Tech), but in January 2006 the only publicly
available slicer for Java appears to be Indus.


Nate (<http://progtools.comlab.ox.ac.uk/projects/nate/>) does not seem to be
available.


Several publicly available slicing tools exist for C, however.


More details, mostly taken from papers that claim to have a Java slicer:


Indus Java Program Slicer (Kansas State, John Hatcliff)
  Available for download.
  <http://indus.projects.cis.ksu.edu/>
  Kaveri is the Eclipse plug-in
U. Wisconsin (Susan Horwitz, Matthew Allen):
  PEPM'03 paper "Slicing Java programs that throw and catch exceptions"
  includes no implementation or experimental work.
  Wisconsin Program-Slicing Project <http://www.cs.wisc.edu/wpis/html/>
  indicates their tools are only for C.
Java program Analyzing TOol (JATO)
Georgia Tech:
  pubs at <http://www.cc.gatech.edu/aristotle/Publications/slicing.html>
  Much of the slicing work was in the 90s and thus probably not for Java
Mark Harman: nothing


Slicing concurrent java programs
Zhenqiang Chen, Baowen Xu
Slicing object-oriented java programs
Zhenqiang Chen, Baowen Xu


Context-sensitive slicing of concurrent programs
Jens Krinke


An improved slicer for Java
Christian Hammer, Gregor Snelting
Implemented in Flex/Harpoon infrastructure
There is no tool download from his webpage, or from the webpage about this paper.


Dynamic slicing:
Tao Wang, Abhik Roychoudhury (NUS)
  "Using Compressed Bytecode Traces for Slicing Java Programs", in ICSE'04.
"Using Program Slicing to Analyze Aspect Oriented Composition", in FOAL
  2004, claims to use Soot, but provides no experimental results.


Probes to extract runtime data without source code:
Aspectwerks, TPTP


Jass: Java extended assertions (pre-and post-conditions, class invariants).


Non-Java tools:
For C, see <http://saturn.stanford.edu> (and it links to related projects on
its webpage).


XStream: quick-and-dirty, human-legible, easy-to-use object serialization.


Java HTML parsing:  There are two fundamental models
 tree-based (object model) such as DOM
 event-based (streaming) such as SAX
   (The events are "open TITLE tag", "close TITLE tag", etc.  The user
   must write hooks that are called for each event, which seems irritating
   and clumsy.  The advantage is that the entire document need not be read
   into memory at once, and you can always use event processing to build a
   tree if memory is not a concern.)
Some packages claim to support both models.


A newer one I have not tried is jsoup.


Tree-based:
  XOM <http://www.cafeconleche.org/XOM/> tree-based API for processing XML,
  best documentation including lots of examples, claims to support both models.
  [I'm going to try this one.]
  XOM requires perfectly valid XML, or it throws an exception.
  If you want to process HTML that is not under your control,
  use XOM along with John Cowan's TagSoup parser.  See
  <http://www.cafeconleche.org/XOM/tutorial.xhtml#d0e532> .
  (Running the "tidy" program first does *not* work; XOM rejects tidy's output.)


Event-based (such as SAX):
  <http://xerces.apache.org/xerces2-j/>
  javax.xml.parsers.SAXParser
  tagsoup <http://mercury.ccil.org/~cowan/XML/tagsoup/>
  <http://ws.apache.org/commons/axiom/>  Uses pull parsing.  Superseded by xerces2?


This one has decent documentation:
<http://jerichohtml.sourceforge.net/doc/index.html>
"It is neither an event nor tree based parser"; tries to handle invalid HTML.


Some advice:
  First use something like HTMLTidy or JTidy to convert the HTML to XHTML.
  Since XHTML is a dialect of XML, it can be processed by any XML parser.
But some parsers claim to deal with bad HTML.


Java call graph (dependences) extraction:

* Understand: <http://www.scitools.com/products/understand/>
* Doxygen generates class diagrams, call trees, dependency graphs, and
   Javadoc-like documentation.  It has its own markup language but works
   even with un-marked-up code.
* Soot
   <http://www.sable.mcgill.ca/pipermail/soot-list/2004-October/000047.html>
* WALA
   Requires Eclipse.
   <http://wala.sourceforge.net/javadocs/trunk/com/ibm/wala/examples/drivers/PDFCallGraph.html>
* depfind: <http://depfind.sourceforge.net/>
* JayFX
   Requires Eclipse.
   <http://www.cs.mcgill.ca/~swevo/jayfx/>
* <https://bitbucket.org/rtholmes/inconsistencyinspectorresources>
   Analyzed software must be built using Ant.
   Static and dynamic call graphs.
* GNU GLOBAL is for source tagging, does not generate call graphs.
* Eclipse's Call Hierarchy: Highlight your method, right click and select
   Open Call Hierarchy (Windows keyboard shortcut: CTRL+ALT+H).  For
   programmatic access:
   <http://stackoverflow.com/questions/5321290/invoking-call-hierarchy-from-eclipse-plug-in>
* JChord, <http://code.google.com/p/jchord/>
* Dynamic call graphs: AspectJ makes it trivial to weave into call sites


## Formatters


I prefer google-java-format (<https://github.com/google/google-java-format>) for Java formatting.
<http://www.peterfriese.de/formatting-your-code-using-the-eclipse-code-formatter/>
left a space at the end of a line


The com.github.sherter.google-java-format plugin is not maintained, per this discussion:
<https://github.com/sherter/google-java-format-gradle-plugin/issues/57#issuecomment-782886280> .
So, use Spotless (<https://github.com/diffplug/spotless>) to run google-java-format.


## Continuous integration


Build systems (in my order of preference, which agrees with Jonathan Burke's):


* Gradle
  Has O'Reilly books (none of the others do).  This is a measure of popularity.
  Maven compatibility.
  Best documentation.
  Seems to do everything that is needed.
  Jonathan Burke says:  Gradle has by far the best documentation and to me
  has the most intuitive usage.  Gradle seems the most flexible but I'll
  admit I spent less time with buildr.
* buildr
  Built on top of Rake, but intended for Java-based applications.
  Seems reasonable enough.
  Good Maven integration.
  Different directory structure than Maven.
  Getting started guide is very short (and too much hype), but PDF version
  is more extensive.
  Jonathan Burke says:  Buildr seemed reasonable but it felt like Gradle
  was more easily read and better documented.
* sbt
  Same directory structure as Maven
  Has continuous testing mode.
  Complicated explanations; uses lots of types without explaining them and
  seems to make concepts more complex than necessary.  The complexity
  probably has some benefits, but I don't see them yet, and this tends to
  turn me off a bit.
  Jonathan Burke says:  I wrote a build script in SBT but I think we should
  probably go with Gradle.  It takes quite a bit of time to understand concepts
  that should be relatively simple.  The documentation is extensive but I have to
  consult 3 different documentation threads and the code in order to find what I
  want and it takes a long time.
  It's more cohesive than the docs would lead you to believe but that said it
  feels like death from a thousand papercuts.  You tend to end up having a script
  that's half java, half "DSL" (I say "DSL" because there seems to be no
  underlying AST it's all just function calls that build a Map[Key -> Some action
  or setting]).  I feel like every time I want to do something simple I have to
  wrestle with some new abstraction.  
* Rake
  con: not from JVM community.  Possible to use, but support may be worse.
  JVM startup time is slow and painful.  buildr is probably better and
  higher-level.
* scons
  Built in Python
  No Scala support
  Limited Java support


## C# tools


Static rewriting:
* CCI
  On-disk only.  Doesn't even work for rewriting at load time.


Dynamic rewriting:
* ER, for "Extended Reflection" (though it's really dynamic monitoring)
  Available in binary form only.
  Provides a callback for every event at run time, such as field access,
  method call, assignment, arithmetic, ...
  Causes 1000x slowdown.
  All of the below are built on ER.
* Moles:  detouring, or AOP for mocking
* PEX
    Uses ER, Moles, Z3
    Docs & tutorials:
      <http://research.microsoft.com/en-us/projects/pex/documentation.aspx>
    Open source projects that use/extend Pex (e.g., DySy, REX for regexps):
      <http://research.microsoft.com/en-us/projects/pex/community.aspx>
* CHESS


