---
job: ea095b
posted_by_role: justice
posted_by_host: endolinbot
posted_at: 2026-06-14T10:52:26Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 440
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
  - steward
refs:
  - entries/2026/06/14/104800Z-dispatch-justice-1eed16.md
  - entries/2026/06/14/095115Z-result-barrister-103358.md
  - entries/2026/06/14/104357Z-result-fixer-9bf98b.md
preconditions: []
claimed_by_role: fixer
claimed_by_host: endolinbot
claimed_by_session: f00a
claimed_at: 2026-06-14T11:02:42Z
---

# Summary-fix bundle for endo-but-for-bots#440 (justice round 2)

One summary-fix item from the code-panel re-run at PR #440 (https://github.com/endojs/endo-but-for-bots/pull/440), submitted as review pullrequestreview-4492801941. The jury-fixer loop terminated on this round (zero must-fix-loop); this bundle is the small registry-alignment work that can land before or after un-draft.

## Items

1. **`packages/chat/formula-view-registry.js` host entry alignment with the daemon's rewritten host case.** The fixer's commit `ef6fb7950` rewrote `packages/daemon/src/formula-record.js`'s `host` case to emit `handle`, `hostHandle`, `mainWorker`, `nodeWorker`, `inspector`, `petStore`, `mailboxStore`, `mailHub`, `endo`, `networks`, `pins` (matching `HostFormula` in `types.d.ts:141-153`). The chat-side registry's `host` `propertyList` (around `formula-view-registry.js` lines 95-115) still lists the older shape: `worker`, `inspector`, `petStore`, `mailboxStore`, `mailHub`, `endo`, `networks`, `pins`. Update the registry's host `propertyList` to match the daemon's emission (drop singular `worker`; add `handle`, `hostHandle`, `mainWorker`, `nodeWorker` in the curated order the back face should render). One-line summary on the registry's `host` entry; same shape as the `'make-archive'` and `'make-from-tree'` cases the fixer added.

   Optional, related: the broader daemon-vs-registry per-type catalog alignment carried as round 1 summary-fix item 1 (channel/timer/git/git-credential/git-remote/mount/scratch-mount/readable-tree have registry entries with no per-type daemon record producer). If the maintainer wants the registry and the daemon's record producer fully aligned before un-draft, fold the per-type catalog work into the same fixer dispatch; otherwise leave it as the existing follow-up ledger entry and address only the host-entry drift here.

## Acceptance

- Registry's `host` `propertyList` enumerates the daemon's emitted references in the curated order.
- The corresponding unit-test claim in `packages/chat/test/unit/formula-view-registry.test.js` (if any asserts the host's property list) is updated to match.
- `corepack yarn workspace @endo/chat test` passes.
- One commit; no panel re-run.
