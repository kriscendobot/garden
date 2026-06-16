---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §removed surface — what got cut
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The §What is Removed list is six entries — *the entire eval-
proposal handshake*:

- **`mail.evaluate()`** — proposal-creation logic in `mail.js`
  (creates proposal message, sends to reviewer, awaits grant or
  counter-proposal)
- **`mail.grantEvaluate()` and `mail.counterEvaluate()`** —
  reviewer-side grant and counter-proposal flows
- **`EvalProposalReviewer` and `EvalProposalProposer`** message
  types
- **`host.grantEvaluate()` and `host.counterEvaluate()`** in
  `host.js` — host methods that handle eval-proposal review
- **The `Responder` exo and its `resolveWithId` method** — the
  intermediary that connects proposal responses to formula
  creation
- **Related type definitions** in `types.d.ts` for the removed
  message types and proposal/reviewer interfaces

But the §Status block adds a *correction-after-the-fact*:

> *The `Responder` exo and its `resolveWithId` method are
> preserved because they remain in use by `request` and
> `definition` message types via persisted `resolverId` fields,
> contrary to the design's assumption that they were specific to
> the eval-proposal flow.*

The §design-was-wrong-about-Responder-being-eval-specific note is
the *honest-design-correction* discipline visible in cycles 114
(familiar-unified-weblet-server's prospective status correction)
and 124 (endopi-iterative-compaction's anticipated-algorithm-vs-
shipped-substrate). Here it's a *what-the-design-thought-was-
removable-but-isn't* correction: implementing the design surfaced
a cross-cutting use of `Responder` the original analysis missed.
