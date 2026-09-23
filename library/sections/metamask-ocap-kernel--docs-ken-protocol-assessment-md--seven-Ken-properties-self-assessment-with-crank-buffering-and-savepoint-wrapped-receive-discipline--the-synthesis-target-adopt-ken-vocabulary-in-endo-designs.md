---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §synthesis-target — adopt Ken vocabulary in Endo designs?
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

This doc names a *vocabulary*:

- §transactional-turns
- §output-validity
- §deferred-transmission
- §atomic-checkpoint
- §consistent-frontier
- §local-recovery
- §sender-based-logging
- §exactly-once-delivery
- §FIFO-ordering

Future Endo-side designs could *use these names* when
discussing the daemon's message-delivery discipline. The
§adopt-vocabulary-not-implementation move: we don't need to
*reimplement* ocap-kernel's crank-buffering to *talk about*
output validity. Using the Ken vocabulary in Endo design
discussions makes the *gap* visible at design-review time —
"this design doesn't yet have output validity in the Ken
sense; future design could add it" is a more *actionable*
critique than ad-hoc descriptions.

The §reference-not-substrate stance (cycle 161): we don't
import ocap-kernel's code; but we *can* import their
*vocabulary* and *discipline*.
