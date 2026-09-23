Work complete. Report:

## What the directive was

dckc's comment on endojs/endo-but-for-bots#825 (`5095971416`) was a reply to my earlier explanation of why `collection-store.js` sits in `@endo/daemon` rather than its own package:

> sounds like — making a new formula type — synchronous I/O — mandate staying inside the daemon package

Read as agreement plus a distillation: those two properties are what mandate keeping it in the daemon package. No code change was requested, so I routed it to (a) verifying both claims against the code, (b) recording the rationale durably, (c) replying.

## What I did

**Preflight.** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution; fail-open). `inbox-list.sh` confirmed no other live worker on PR 825 — the two earlier jobs (`…-83a474e1`, `…-gauntlet`) had completed.

**Verified both claims against the branch** (`daemon-store-phase4-sorted`, isolated checkout):
- *Formula type* — `collection-store` is a member of the **closed** `formulaTypes` set literal in `formula-type.js:8`, plus a case in `formula-record.js:280` and a dispatch-table entry in `manager.js:4083`. No registration seam exists, so adding a formula type is by construction an edit to daemon-internal files.
- *Synchronous I/O* — confirmed and load-bearing. Every collection op in `DaemonicPersistencePowers` (`types.d.ts:2323-2380`) is synchronous, backed by the in-process `better-sqlite3` handle (`manager-database.js:700-735`). Two sites depend on it: `collectWeakEntries` must delete rows and report retention edges *within the collecting turn*, and restart rebuilds each store's index and per-slot refcounts synchronously before the exo is handed out. The daemon's boundary to anything outside itself is async, so neither guarantee survives a move past it. This is the harder of the two constraints — it would bind even given a hypothetical formula-type registration seam.

**Recorded the rationale in source.** Added a 25-line module comment at the top of `packages/daemon/src/collection-store.js` stating why the module is daemon-internal, citing both constraints and the discussion URL. Comment-only, no behavior change.

**Verified locally:** `prettier --check` clean; `eslint` at **0 errors / 26 warnings**, byte-identical to the pre-edit baseline I measured by stashing (the warnings are pre-existing jsdoc/safe-await-separator noise in the file).

**Pushed** `74f71d55b` to `daemon-store-phase4-sorted` via a rebase CAS loop.

**Replied** on the PR: https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5100139593 — confirming the distillation with the code evidence, and noting the commit is easy to drop if dckc would rather the rationale live only in the thread. Added a `+1` reactji (the `eyes` ack was already there from the watcher).

## Follow-ups

- **Withdrawn, not filed:** the "extract `collection-store` into its own package behind a generic persistence/identity/retention interface" follow-up I floated in my earlier reply. dckc's response settles that it stays in the daemon, so filing it would have tracked work we've agreed not to do. I said so explicitly in the reply rather than letting it lapse silently. No issue exists for it (searched; none).
- PR 825 remains **OPEN, non-draft, MERGEABLE**. The gauntlet already ran under its own job; my commit lands after it, so if a green-CI record is wanted on the final head, CI needs to re-run on `74f71d55b` — it is comment-only, so no substantive risk.
- No garden (`main2`) changes were needed; my per-job garden worktree has no commits.
