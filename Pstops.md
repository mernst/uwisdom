@summary pstops HOWTO

Contents:


```
Date: Wed, 4 Dec 2002 14:07:30 -0500
From: Alan Donovan
Subject: pstops HOWTO


Hi everyone.  Hate the way postscript is always just slightly in the
wrong place?  Fed up with US Letter/ISO A4 incompatibility?  Confused
as to why psnup -2 doesn't collate pages right on a duplex printer?

Worry no more -- here is all you ever wanted to know about pstops --
but man pstops(1) was too ashamed to tell you -- in a handy
cut-out-n-keep format!  [NOTE that pstops != ps2ps]

pstops formats allow you to specify arbitrary linear transformations
(scale/translate/rotate).  Note that in Postscript, the origin is at
the bottom left corner and positive x/y are right/up, just as with
Descartes).  What pstops does, in order (and order does matter) is:

1. TRANSLATE: your input is shifted by the desired vector w.r.t the
   output page origin.

2. ROTATE: your translated input is rotated around its bottom left
   corner.

3. SCALE: the translated, rotated input is then scaled w.r.t. its
   origin -- which might not now be at the bottom left!

4. CLIP: so far all that you have been transforming is the bounding
   box.  Now this box is clipped (i.e. intersected with the bbox of
   the output page.

5. RENDER: now pstops renders your input as large as possible in the
   transformed input bounding box using a rectilinear scaling (i.e. no
   x/y distortion).  Note that the clipping of the previous step may
   have made the box very narrow, so this will effect another scaling.
   Use pstops -d1 to draw the bbox -- this well help you see what is
   going on.

Example: 

In this example, the ABC denotes the contents of the page to make it
easier to visualise.  For example, to do this transformation

   +-----+                      O------+
   |  A  |                      |C B A |
   |     |                      |      |
   |  B  |    --- to this --->  +------+
   |     |                      |      |
   |  C  |                      |      |
   O-----+                      +------+

We need to:

   1. translate it up by a whole page height.

   2. rotate it 90 deg clockwise (right) around its origin 'O'

   3. scale it by sqrt(2) (approx) around its origin (note how the
      rotation origin is now at the top left corner of the output page

Which comes out in pstops as:

   % pstops '0R@.707(0,27.9cm)' foo.ps


Whereas to transform:

   +-----+                      +------+
   |  A  |                      |      |
   |     |                      |      |
   |  B  |    --- to this --->  +------+
   |     |                      |A B C |
   |  C  |                      |      |
   O-----+                      +------O

We need to:

   1. translate it right by one page width.
  
   2. rotate it left by 90 deg around its origin 'O'.

   3. scale it by sqrt(2) w.r.t origin 'O'.

which comes out as:

   % pstops '0L@.707(20.3cm,0)' foo.ps


Now the collation: (this bit is explained well in the manual). To make
even pages do the first of the transforms shown above, and odd do the
second, we set up a 'repeat period' of 2, and designate the (x mod 2
== 0) pages for the first transform and the (x mod 2 == 0) pages for
the second:

   % pstops '2:0R@.707(0,27.9cm)+1L@.707(20.3cm,0)' foo.ps
             ^ ^                 ^
             | |                 |
  [repeat=2]-+ +-[even pages]    +-[odd pages]

And we get:

   +-----+ +-----+                     +------+
   |  A  | |  D  |                     |C B A |
   |     | |     |                     |      |
   |  B  | |  E  |   --- to this --->  +------+
   |     | |     |                     |D E F |
   |  C  | |  F  |                     |      |
   O-----+ O-----+                     +------+

While this particular transform it pretty useless, hopefully you can
see where this is going.  There's also trickery for forward/reverse
collating (for when you want to fold a page in two to make a booklet
-- see the manpage).

Anyway, here's a useful one (why I got here in the first place):

   % pstops '4:0L@.647(21.59cm,0)+1L@.647(21.59cm,13.97cm),'\
            '2R@.647(0,27.94cm)+3R@.647(0,13.97cm)'

which means: print out a US Letter document, 2 up, so that it doesn't
screw up the up-down orientation on alternate physical pages.


You might want to think about borders too.  Note that ISO paper has
the rather nice sqrt(2) property, so you can always scale by that
(0.707).  With US Letter, you might want to use (11/2)/8.5 which is
0.647 or 8.5/11 which is 0.773 -- it depends.

Note that paper sizes are:
  US Letter (8" x 11")    21.59cm x 27.94cm
  ISO A4                  21.00cm x 29.70cm

and that 1 in = 72 pt ~ 2.54cm.
```