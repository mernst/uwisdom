Contents:


```
From: Derek Rayside
Date: Wed, 9 May 2007

Here are a few things I have learned about working with large 64bit heaps
that you may also find useful:


Tuning the GC:

     OutOfMemoryError doesn't mean that you've run out of memory.  It
     means that the collector has run out of time to look for more
     memory.  You can adjust how much time the collector has with two
     command line arguments:

         -XX:GCTimeRatio=1
         -XX:MaxGCPauseMillis=99999

     I think the GC time ratio is the more important one.  It says how
     much of the execution time the program is allowed to spend
     collecting.  The default is 1% or 2%.  The formula is 1/(1+x), so
     a value of 1 means up to 50% of time can be spent in GC, and a
     value of 9 means up to 10% of time can be spent in GC.  For my
     program, setting the GC time ratio to 1 means that the peak memory
     consumption of the JVM process goes down by hundreds of megabytes.
     But you do pay for this in time.

      -XX:MaxGCPauseMillis=99999 says that the program can pause for a
      long time while the collector works.  I'm not sure if this
      setting matters, because the default is supposed to be unbounded.
      But the docs are for Java 5, and maybe that changed for Java 6.

     If you're pushing the limits of physical memory, you're willing to
     wait for the collector to find more garbage: let it know that.

     There are a variety of GC algorithms you can chose from, and each
     of them has a bunch of tunable parameters.  Selection of the
     collector is mostly about time: latency vs throughput, parallelism
     of your machine, etc.  You can read about that stuff here:

         http://java.sun.com/docs/hotspot/gc5.0/gc_tuning_5.html
         http://java.sun.com/docs/hotspot/gc5.0/ergo5.html
         http://java.sun.com/javase/technologies/hotspot/vmoptions.jsp


Tools:

     Get a histogram of the heap:

         jmap -histo:live pid > histo.txt

     Get a heap dump when the VM runs out of memory (actually, this
     isn't very useful if you're pushing the physical limits of the
     machine, because you won't be able to analyze the dump until you
     find a machine with more memory):

         -XX:+HeapDumpOnOutOfMemoryError

     Pause the VM when it runs out of memory so that you can get a
     histogram of the heap:

         -XX:OnOutOfMemoryError="read -p paused"

     Watch the heap grow:

         jconsole


Object Layout:

     - An object header is two words, whether those words are 32 bits
       or 64 bits (so objects are bigger in a 64bit VM).
     - Array headers are three words (another word for length).
     - A Pair object with just two int fields (ie, 64 bits of actual
       data) will only use three 64bit words (two for the header, and
       one for the data), which is what you want.
     - An object with a pointer and a boolean will require four 64bit
       words (two for the header, one for the pointer, and one for the
       boolean), which is 63bits of wasted space per object.  It is
       probably the case that objects are rounded up to the word
       boundary.
     - An object with a pointer and two booleans will require four
       64bit words: ie, only wasting 62 bits.  It doesn't seem to
       matter what order these fields are declared in.
     - I haven't investigated the effect of inheritance on the VMs
       ability to re-order fields.


It is possible to generate garbage that is too big for the GC to collect.
For a particular input, my analysis generates a large graph (about 5GB of
heap space).  This is too big for the GC to collect:  it first has to be
cut up into smaller pieces (ie, set lots of pointers to null).
```