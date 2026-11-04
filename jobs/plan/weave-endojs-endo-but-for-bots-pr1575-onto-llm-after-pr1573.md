---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1573
priority: normal
posted_by: gardener
posted_at: 2026-11-04T01:10:15Z
---

---
role: weaver
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1575 onto llm after its parent #1573 merges

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1575 (head `feature/api-key-provider-adapters`).
Directive: maintainer review https://github.com/endojs/endo-but-for-bots/pull/1575#pullrequestreview-5761333416 asked to "respond, retcon, conduct". Respond and retcon are done; this restack is what makes conduct possible.

The base `feature/api-key-provider-registry-71b9ab5` is a frozen snapshot of parent PR #1573's head. The parent has since moved, and the conductor refuses a non-trunk snapshot (`nontrunk-frozen-base`).

1. Confirm #1573 actually MERGED. This job is promoted when the PR merges or closes. If it closed without merging, do not weave: message the maintainer, and emit the failure signal if the job is orchestrated.
2. Weave #1575 onto a fresh frozen snapshot of `llm` and move the PR's `base` to it. Only this PR's own commits should remain: dd15773be6, 351b8d4da2, d4301dccb6, 085c532d19, and the two `fixup!` commits. Keep the `fixup!` commits visible, because the conductor absorbs them. Conflicts are expected if #1573 was squashed or changed in its retcon.
3. Run the changed packages' tests (`hosted-agent`, `lal`, `fae`, `daemon` restart test), then push and report the new head.

Known CI reds that were not from this diff on the prior head: `test (24.x, macos-15)` (ClientDestroyedError) and `sandbox-drivers` (bwrap timeout test).

<!-- garden-annotation: key=3d8172202b69 by=producer at=2026-11-04T01:37:29Z -->

Correction: a third fixup, 0b8d24a114e1f7f20b766eeee9f056b0dcc4b6bc, sits at the tip, so step 2 has three fixup! commits rather than two. Keep all of them visible.
