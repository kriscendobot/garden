---
ts: 2026-05-14T01:12:00Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004348Z-dispatch-liaison-be2777.md
  - entries/2026/05/14/010122Z-result-boatman-3f1498.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo
    pr: 3257
    role: target
---

#223 ferry: opened **endojs/endo#3257** (https://github.com/endojs/endo/pull/3257) at upstream head `f20f1f18`. Source PR `endojs/endo-but-for-bots#223` left open with cross-link comment `#issuecomment-4446416252`. Single squashed commit attributed solely to `Kris Kowal <kris@cixar.com>`, no bot trailers (verified). Conventions applied per the new boatman framing norms: title scrubbed of `(mirror of #142 for upstream)` parenthetical, body purged of garden-bookkeeping paragraphs and the dangling "Refs: ... #140 (design)" line.

**Scope discrepancy worth flagging to the user**: the source PR's body claimed `cli`/`daemon`/`ocapn` consumer migrations were excluded because those packages "don't yet exist on `actual/master`." The boatman verified that claim was incorrect — the packages DO exist upstream and the source diff DID include the migrations. Final upstream stat is 49 files +1065/-737 (broader than the bytes-package-only scope the source body advertised). The boatman ferried the actual diff scope rather than guess at a narrower intent. **Action item for the user**: if you intended a narrower bytes-only handoff, close `endo#3257` and re-dispatch with explicit scope reduction. Otherwise the PR landed correctly.

Worktree triple to be torn down next; index entry flipped to `status: collected`.

Self-improvement: nothing this time on the liaison side. The boatman's "Key finding worth flagging" was the substantive lesson and is captured in its result entry.
