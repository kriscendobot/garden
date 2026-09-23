---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §regression-test-prevents-reintroduction
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The §Status block names a regression test:

> *PR #92 follows up by ... adding a regression test (`guest
> evaluate posts no message to host or guest mailbox`) that
> asserts a guest `evaluate` does not grow either side's mailbox,
> so a future re-introduction of any proposal-style send fails
> fast.*

The §regression-test-locks-in-the-removed-behavior discipline.
The eval-proposal flow *added* messages to mailboxes; the
simplification *removed* those messages. The regression test
asserts *zero mailbox growth* — a single integer invariant
that catches any future regression. The *what-was-removed-stays-
removed* invariant is now a test.
