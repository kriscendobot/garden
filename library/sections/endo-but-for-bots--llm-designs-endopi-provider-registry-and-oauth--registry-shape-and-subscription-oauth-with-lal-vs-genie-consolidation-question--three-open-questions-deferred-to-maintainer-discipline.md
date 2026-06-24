---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: §Three Open questions — *deferred-to-maintainer* discipline
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Open questions paragraph names three undecided issues:

1. **Lal vs Genie consolidation.** Three options:
   - (a) Lal consolidates onto Genie's `pi-ai` dependency,
     retiring `packages/lal/providers/`
   - (b) Lal and Genie coexist with separate registries
   - (c) The registry lives in a new shared `@endo/ai` package
     that both depend on

   *Recommend deferring to the maintainer after the OAuth flow's
   package-placement is settled.* The *option-(a)-vs-(b)-vs-(c)
   deferred-to-maintainer* is the §three-way-policy-question
   pattern — the design lays out the trade-offs but doesn't
   prescribe.

2. **Package placement** — `@endo/lal` vs `@endo/lal-ai` (mirror
   Pi's split for non-Lal consumer reuse).

3. **Subscription auth attack-surface widening** — subscription
   tokens are *account-level*, not *workspace-level* (API keys).
   The §recommendation: *a UI confirmation step on first use, plus
   documentation that subscription tokens are equivalent to
   logging in on the web*. The §account-level-vs-workspace-level
   distinction is the broader-blast-radius warning — *subscription
   tokens are equivalent to logging in on the web* names the
   actual threat shape (a leaked subscription token compromises
   the account, not just the workspace).
