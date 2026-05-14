---
title: History
source: README.md
source_repo: kriscendobot/ocapn
source_commit: 482d9cc9845a6580840711e518d71b4e27a2dcaf
source_date: 2025-07-10
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
---

> Abstract: Historical context for the protocol family: descent from E, Joe-E, CapTP work; the open-spec process; key contributors and venues.

## History

CapTP is something which has been implemented many times.
The first "open" version of CapTP was implemented in the
[E programming language](http://www.erights.org/)
(which itself was a continuation of the technical core of the
ambitious [Electric Communities Habitat](https://www.youtube.com/watch?v=KNiePoNiyvE)
distributed virtual worlds project),
though there have been many other (but incompatible) implementations
since, such as in [Cap'N Proto](https://capnproto.org/),
[Agoric's](https://agoric.com/)
[current implementation](https://github.com/endojs/endo/tree/master/packages/captp),
and [Spritely's](https://spritelyproject.org/)
[Goblins implementation](https://docs.racket-lang.org/goblins/index.html).
We are hoping to unify our work in the OCapN project.

CapTP usually comes with some other pieces.
The original implementation of CapTP was part of a suite called
"Pluribus" (with E and Pluribus being two parts of the joke "E
Pluribus Unum"); "OCapN" is thus the equivalent of "Pluribus".
If you are familiar with the original CapTP work, you can think of the
"netlayer" abstraction as being what used to be called
["VatTP"](http://erights.org/elib/distrib/vattp/index.html),
but generalized to permit multiple network transports.

When distinguishing from previous implementations, this particular
implementation of CapTP should be called "OCapN CapTP".

([Waterken](http://waterken.sourceforge.net/) does not have all the
properties associated with CapTP, but nonetheless extended and
provided many significant ideas for current generational work.)


Source: `README.md` at commit `482d9cc9` (held at kriscendobot/ocapn).
