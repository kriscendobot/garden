---
ts: 2026-05-14T05:56:20Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004348Z-dispatch-liaison-be2777.md
  - entries/2026/05/14/011200Z-result-liaison-9c4e2a.md
  - entries/2026/05/14/041650Z-message-liaison-dc1f5b.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo
    pr: 3257
    role: target
---

Re-ferry #223 → #3257 (second pass; first pass landed at upstream `f20f1f18`).

**Fast-forward advance**: source PR #223's head moved from `1baf237a` (prior ferry) to `a39c99325` (now). `1baf237a` is still an ancestor of `a39c99325`. Three new commits added, all addressing Copilot review on `endojs/endo#3257`:

- `b42a52f37 docs(bytes): correct README references and CHANGELOG export list (#223)` — drops a reference to nonexistent design doc; softens "captured and frozen" wording; expands CHANGELOG export list.
- `8ccbdce29 fix(cli): drop unused @endo/compartment-mapper dependency (#223)` — removes accidentally-added dep.
- `a39c99325 chore: Update yarn.lock`

Strict forward progress: addresses real review feedback Copilot left on the upstream PR. No surface regressions, no scope changes.

**Upstream `#3257`** still at `f20f1f18` — no parallel work to reconcile.

**Source**: `endojs/endo-but-for-bots#223`, branch `feat/endo-bytes-upstream`, head `a39c99325b39b56a3ed9d2087bc1e44eb41bb4c8`. State OPEN, MERGEABLE.

**Upstream**: `endojs/endo:feat/endo-bytes-package`, current head `f20f1f18` (PR #3257).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true**.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--re-ferry-bytes-223--20260514-055534--07a6c4/`.

**Boatman direction**:
- Re-apply the source's full diff onto a fresh branch off `upstream/master` (same procedure as the prior ferry). Force-push to `feat/endo-bytes-package`. Prior tip `f20f1f18` will be replaced.
- Single squashed commit, attributed to `Kris Kowal <kris@cixar.com>` (author + committer).
- Same scope decision as before: ferry the actual diff (which includes cli/daemon/ocapn migrations); the user has not asked to narrow.
- **Identity discipline**: explanatory comment on #3257 (probably noting the Copilot-review-response inclusion) goes via `message`-to-`steward`. Source-side cross-link comment on #223 is fine to post directly.

**Expected report**: upstream PR head SHA after force-push, attribution-verified, source PR forward-link, message-to-steward queued for the upstream comment, journal `result`, `Self-improvement: ...`.
