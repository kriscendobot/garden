---
slug: cross-package-fidelity-contract-ownership
category: docs-drift
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-6c57250a
prs: [475]
---


A client package begins depending on a provider package's deliberate fidelity loss, but the change records the dependency and regression guard only on the client side instead of specifying and pinning the provider-side contract too.

**Threshold rationale:** Held below the dispatch floor. This new cluster contains one moderate miss from
one PR (`count=1`, `prs=[475]`), so it does not meet the default threshold of at
least three misses across at least two PRs. The severity bypass does not apply:
the omission exposed a plausible future compatibility break, but it was caught
before merge and is not a major miss. No improvement job is dispatched.
