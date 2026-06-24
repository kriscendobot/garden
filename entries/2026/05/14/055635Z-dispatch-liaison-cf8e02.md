---
ts: 2026-05-14T05:56:35Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/13/013320Z-dispatch-liaison-e88a31.md
  - entries/2026/05/13/014830Z-result-liaison-7e3b9a.md
  - entries/2026/05/14/041650Z-message-liaison-dc1f5b.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry #109 → #3256 (second pass; first pass landed at upstream `ed80869d`).

**Fast-forward advance**: source PR #109's head moved from `4ffb3d84` (prior ferry) to `642ce3fd` (now). `4ffb3d84` is still an ancestor of `642ce3fd`. Three new commits added:

- `e7f141a4e refactor(syrup-frame): rename @endo/syrups package to @endo/syrup-frame (#109)` — **package rename**: `@endo/syrups` → `@endo/syrup-frame`.
- `5c91a7832 chore: Update yarn.lock`
- `642ce3fd6 chore(syrup-frame): delimit thousands with underscores (#109)`

The package rename is significant: the upstream PR title currently still reads `feat(syrups): add @endo/syrups package (comma-less netstring variant)` and refers to `@endo/syrups`. After the re-ferry the new package name will be `@endo/syrup-frame`. The PR title and (probably) body need updating to match.

**Title update**: per the identity-discipline rule, primary-repo PR title edits should also route via the steward. The boatman should propose an updated title in the message-to-steward (suggested: `feat(syrup-frame): add @endo/syrup-frame package (comma-less netstring variant)`).

**Upstream `#3256`** still at `ed80869d` — no parallel work to reconcile.

**Source**: `endojs/endo-but-for-bots#109`, branch `feat/syrups-package`, head `642ce3fd6b8c5ff0d3cae7657eaa42145810662a`. State OPEN, MERGEABLE.

**Upstream**: `endojs/endo:feat/syrups-package`, current head `ed80869d` (PR #3256).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true**.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--re-ferry-syrup-frame-109--20260514-055543--1e1ee4/`.

**Boatman direction**:
- Re-apply source's full diff onto fresh branch off `upstream/master`. Force-push to `feat/syrups-package`. Prior tip `ed80869d` will be replaced.
- Single squashed commit, attributed to `Kris Kowal <kris@cixar.com>`.
- Same approach as prior ferry (squash via merge-base diff naturally elides the unrelated PR #84 hardened-url-shim merge in the source's history).
- **Identity discipline**: explanatory comment on #3256 (noting the package rename) goes via `message`-to-`steward`. Suggested title update should also be in that message body. Source-side cross-link on #109 is fine to post directly.
- **Branch-name consideration**: the upstream branch `feat/syrups-package` may want renaming to `feat/syrup-frame-package` to match. Do not rename in this dispatch (would require deleting the existing upstream branch, breaking the PR). Leave for the user to decide and flag in the result entry.

**Expected report**: upstream PR head SHA, attribution-verified, source PR forward-link, message-to-steward (carrying the upstream comment + suggested title update), journal `result`, `Self-improvement: ...`. Branch-name rename question noted in the result for liaison/user follow-up.
