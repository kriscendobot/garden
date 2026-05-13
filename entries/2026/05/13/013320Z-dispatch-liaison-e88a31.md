---
ts: 2026-05-13T01:33:20Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs: []
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: null
    role: target
---

Dispatching the boatman to ferry endojs/endo-but-for-bots#109 to endojs/endo.

**Source**: `endojs/endo-but-for-bots#109`, branch `feat/syrups-package`, head `4ffb3d84e50c35f330d90e7e600040944e789a3c`. Title `feat(syrups): add @endo/syrups package (comma-less netstring variant)`. State OPEN, MERGEABLE, mergeStateStatus CLEAN, all 27 CI checks SUCCESS. Diff +1560/-3 across 17 files.

**Upstream**: `endojs/endo`, target branch `master`.

**Human**: `Kris Kowal <kris@cixar.com>` (per the local git config and prior identity-convention journal entries; the source PR's syrups-related commits already attribute to this name+email, so the boatman's rewrite gate likely needs only to handle the two `claude`-authored design-shim commits and the closing `claude` fixup).

**identity_switch_authorized: true** — explicitly authorized by the user in this dispatch ("Remember your training. This is not a drill.").

**Source-branch caveat for the boatman**: the branch contains an unrelated merge commit (`4cb1ed4d26`, merging PR #84's hardened-url-shim design work) that landed before the syrups commits. The boatman should NOT carry the hardened-url-shim content upstream as part of this handoff; the syrups work alone is the intended diff. Cherry-picking the syrups commits onto endo:master, or using the diff against the merge base on the bots repo, are both reasonable approaches.

**Expected report shape**: the boatman returns with the upstream PR URL, the upstream head SHA, a confirmation that all transferred commits are authored solely by Kris Kowal, the cross-link comment posted on the source PR, and a `Self-improvement: ...` line. Per the boatman role, this is the first clean handoff in our garden, so the boatman should also include a `message`-to-liaison proposing `skills/pr-handoff/SKILL.md` capturing the verified procedure.

Per-dispatch worktree triple to be created next via `scripts/dispatch-prepare.sh boatman ferry-syrups-109 endojs/endo-but-for-bots feat/syrups-package`.
