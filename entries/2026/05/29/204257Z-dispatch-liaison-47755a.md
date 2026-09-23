---
ts: 2026-05-29T20:42:57Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--47755a`) to re-ferry endojs/endo-but-for-bots#244 to its existing upstream PR endojs/endo#3263.

Source: endojs/endo-but-for-bots#244, branch `chore/eslint-numeric-separators-style-master`, head `63a1a6068`, 9 commits, frozen base `master-814dfa1`. Title "chore(eslint-plugin): require underscore-delimited groups in numeric literals"; adds eslint-plugin-unicorn numeric-separators-style to the @endo/internal preset plus a 47-file autofix migration. The 9 commits are the original 4 plus 5 gamut refinements (test pinning, hex-by-two grouping, mnemonic-seed + comparison-literal exemptions, yarn.lock, syrup-frame 4-digit fix). Mix of `kris@cixar.com` and `endolinbot` authorship. Body says it mirrors the sibling bot-side #243 (the llm-branch variant), not an upstream PR.

Upstream: endojs/endo#3263, existing branch `kriskowal-eslint-numeric-separators-style`, current head `512438a27` (4 commits, `kris@cixar.com`). State OPEN, non-draft, reviewDecision REVIEW_REQUIRED (only a turadg COMMENTED; **no approval at risk**), and currently **mergeable: CONFLICTING** against master.

Shape: **Shape 2 (re-ferry, recompute-from-master, force-push)** to the existing `kriskowal-eslint-numeric-separators-style` branch. Live origin/master is `c49fb048b`; the source's frozen base `master-814dfa1` is an older snapshot, so the cherry-pick recompute may hit conflicts on files that changed since. Boatman instructed: resolve mechanical autofix conflicts (re-run eslint --fix on the touched set); if conflicts are structural/non-mechanical, stop and surface so the liaison routes to a weaver instead of guessing. The recompute onto current master is also expected to clear the upstream CONFLICTING state.

Human attribution `Kris Kowal <kriskowal@kriskowal.com>` (author+committer all 9; normalize cixar+endolinbot), strip `(#244)` suffix and bot trailers. `identity_switch_authorized: true`. No prior Mirror cross-link on #244; boatman creates the garden-side one and hands the upstream-side to steward.

Expected report: post-push head SHA + force-push confirmation, post-push mergeable state (CONFLICTING expected to clear), conflict-handling outcome, attribution/trailer verification, net-diff-matches-source check, CI status, garden-side cross-link comment ID. If the boatman bailed on structural conflicts, it reports that instead and pushes nothing.
