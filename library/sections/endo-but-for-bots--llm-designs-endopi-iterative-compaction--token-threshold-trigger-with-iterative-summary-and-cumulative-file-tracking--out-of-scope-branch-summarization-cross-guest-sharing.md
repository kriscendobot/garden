---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: §Out of scope — *branch summarization*; *cross-guest sharing*
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §Out of scope section names two paths the design declines:

- **Branch summarization on tree navigation.** Pi has this for
  `/tree`; Endo's reply-chain UI is different. Revisit if
  `/tree`-style navigation lands.
- **Multi-agent context sharing across compactions.** Compaction
  is per transcript; cross-guest context coordination is a
  separate problem.

Both declines are *honest scope decisions* — neither is a *we
shouldn't do this* judgment; both are *not this design*. The first
is gated on a different design (a Pi-like `/tree` UI in Lal); the
second is the *multi-guest-coordination problem* that the daemon
substrate (cycle 119's capability-bus, cycle 105's capability-bank)
addresses at a different layer.
