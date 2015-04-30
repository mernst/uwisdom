Contents:


Adapted from http://en.wikipedia.org/wiki/Dependability:
  * Defect:
> > A flaw, failing, or imperfection in a system, such as an
> > incorrect design, algorithm, or implementation.  Also known as a
> > fault or bug.  Typically caused by a human mistake.
  * Error:
> > An error is a discrepancy between the intended behaviour of a
> > system and its actual behavior inside the system boundary.  Not
> > detectable without assert statements and the like.
  * Failure:
> > A failure is an instance in time when a system displays
> > behavior that is contrary to its specification.
IEEE Std 610.12-1990 IEEE Standard Glossary of Software Engineering
Terminology says:
```
  error.
  (1) The difference between a computed, observed, or measured value or
    condition and the true, specified, or theoretically correct value or
    condition. For example, a difference of 30 meters between a computed result
    and the correct result.
  (2) An incorrect step, process, or data definition. For example, an
    incorrect instruction in a computer program.
  (3) An incorrect result. For example, a computed result of 12 when the
    correct result is 10.
  (4) A human action that produces an incorrect result. For example, an
    incorrect action on the part of a programmer or operator.
  Note: While all four definitions are commonly used, one distinction assigns
  definition 1 to the word "error," definition 2 to the word "fault,"
  definition 3 to the word "failure," and definition 4 to the word "mistake."
  See also: dynamic error; fatal error; indigenous error; semantic error;
  syntactic error; static error; transient error.
```
Note that IEEE Std 610.12-1990 does not distinguish between the (Wikipedia)
dependability notions of error and failure -- it calls them both failures
(and a failure is either present or not, but does not have a magnitude).
It uses "error" to mean the magnitude or characterization of the
discrepancy.


Threats to the validity of research.
Most often these are clumped into just
  * Internal validity
> > refers specifically to whether an experimental
> > treatment/condition makes a difference or not, and whether there is
> > sufficient evidence to support the claim.
  * External validity
> > refers to the generalizibility of the treatment/condition outcomes.
But sometimes the threats are more finely broken down.  Example from
http://www.psych.sjsu.edu/~mvselst/courses/psyc18/lecture/validity/validity.htm
  1. Threats to construct validity.
> > The measured variables may not actually measure the conceptual variable.

> 2. Threats to statistical conclusion validity.
> > Type I (mistakenly rejects null hypothesis) or Type II error (mistake
> > of failing to reject the null) may have occurred.

> 3. Threats to internal validity.
> > IV - DV relation may not be directly causal (confounds = another
> > variable mixed up with the IV; confounds provide alternative
> > interpretations or alternative explanations for the results of the
> > experiment).   Internal validity is perfect only when there are no
> > confounding influences.

> 4. Threats to external validity.
> > Results may only apply to limited set of
> > circumstances (e.g., specific groups of people or only some typefaces...)
Another list of types of threats is:
  * construct (correct measurements)
  * internal (alternative explanations)
  * external (generalize beyond subjects)
  * reliability (reproduce)


Item #2 of Strunk & White's _The Elements of Style_ states,

> In a series of three or more terms with a single conjunction, use a
> comma after each term except the last.
For example, don't write
> I bought milk, macaroni and cheese and crackers.
but instead write one of these:
  * I bought milk, macaroni, and cheese and crackers.
  * I bought milk, macaroni and cheese, and crackers.
Using commas everywhere is better style, it is easier to read, and in cases
like this one it also resolves ambiguity.

We have a sample of some data.  We have calculated the sample mean and
the sample standard deviation.  We want to know that the sample mean
is within +-E of the population mean, with 95% confidence.  How large
of a sample must we take?
  * n = necessary sample size
  * z = z_(u/2) = 1.96 for 95% confidence
  * sigma = population standard deviation
  * E = error tolerance, in the same units as original measurement
  * n = ((z `*` sigma) / E)^2
If the original sample size is 30 or more, you can safely replace the
population standard deviation with the sample standard deviation.
Taken from: http://www.isixsigma.com/library/content/c000709ex.asp_

In statistics:
  * a type I error is a false alarm
  * a type II error is a failed alarm:  you miss the effect

Here are three variants of the word "run time" in computer science:
run-time -- adjective ("the run-time performance")
run time -- noun -- a moment in time ("occurs at run time"), or an amount of time ("the run time is 8 hours")
runtime -- noun -- a program that runs/supports another program ("the runtime handles memory allocation"); a synonym for "runtime system"

Heilmeier's catechism:
  * What are you trying to do? Articulate your objectives using absolutely no jargon.
  * How is it done today, and what are the limits of current practice?
  * What's new in your approach and why do you think it will be successful?
  * Who cares?
  * If you're successful, what difference will it make?
  * What are the risks and the payoffs?
  * How much will it cost? How long will it take?
  * What are the midterm and final "exams" to check for success?