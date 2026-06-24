---
ts: 2026-05-18T21:12:00Z
kind: tick
role: steward
to: "*"
refs:
  - entries/2026/05/18/195800Z-message-liaison-12198.md
  - entries/2026/05/18/200000Z-message-steward-c3a91d.md
  - entries/2026/05/18/200700Z-dispatch-steward-977cf0.md
  - entries/2026/05/18/200800Z-dispatch-steward-61b0de.md
  - entries/2026/05/18/210719Z-result-fixer-977cf0.md
  - entries/2026/05/18/202239Z-result-fixer-61b0de.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 4
    role: target
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: target
---

Cycle close: heavy substantive work this turn.

**Inbox-drain Monitor outage** (second instance in 36 hours): the rebase on `/home/kris/main` progressed past commit `a782112` (the `scripts/` → `skills/inbox-drain/` move), making my prior `/home/kris/scripts/inbox-drain.sh` path stale. User flagged indirectly by asking *"Did you get that thing the liaison sent you about agoric-sdk sqlite fixers?"* — a steward-addressed message at `195800Z-message-liaison-12198.md` had not surfaced. Re-armed Monitor `b8tnhkgbw` with path-fallback wrapper (tries both layouts). Routed retro to gardener at `200000Z-message-steward-c3a91d.md`; this is the second time the script-path issue has bitten, urgency upgraded.

**Two parallel agoric-sdk sqlite migration fixers landed**:

- **Dispatch A** (`977cf0`, @photostructure/sqlite adapter — turadg's Step 1): PR [kriscendobot/agoric-sdk#4](https://github.com/kriscendobot/agoric-sdk/pull/4) (DRAFT) at `8270fb79b`. 85/85 tests passing (target met — recovered the 2 skipped + 7 failing tests from upstream #12198). All three mhofman review asks addressed (native `iterate`, native `isTransaction`, backup API for serialization). New backend-entrypoint `packages/swing-store/src/dbBackend.js` (~120 LOC) shaped to be native-first so Dispatch B's swap is a one-line constructor change.
- **Dispatch B** (`61b0de`, node:sqlite builtin — turadg's Step 2 directly): PR [kriscendobot/agoric-sdk#3](https://github.com/kriscendobot/agoric-sdk/pull/3) (DRAFT) at `025859930`. 85/85 tests passing. Engines bumped to `^22.16 || ^24.0` (no experimental-flag dance needed); rationale surfaced in PR body. New backend `packages/swing-store/src/sqliteBackend.js` (~332 LOC).

Both PRs ready for the next gamut stages (cleaner → judge → fixer-loop → un-draft) via the autonomous-steward's standing scan. The maintainer compares the two PRs at review time and picks (or merges complementary parts).

**Field notes from the two fixers** (worth promoting to a `node-sqlite-migration-gotchas` skill or library page, per their self-improvement lines):

- Five native-binding footguns: undefined-binding rejection, defensive-mode PRAGMA blocking, no implicit rollback on close, backup-vs-write-transaction conflict, Uint8Array-vs-Buffer for BLOBs.
- Two node:sqlite-specific gotchas: `undefined → null` parameter rejection (ERR_INVALID_ARG_TYPE), `Uint8Array` BLOB return type (breaking `Readable.from`).

Routed as candidate skill content via the fixers' result entries; gardener picks up on next pass.

**Other state**: 3 daemons healthy; #258 (OCapN Guile Interop iter III) still awaits maintainer merge; #280 (drop Node 18 + 20) awaits re-review post-history-restore (fixer `b326b0` at `c040dc77e`).

Self-improvement: the inbox-drain Monitor's second silent failure in 36 hours confirms the path-fallback shape is the right structural fix. Already routed to gardener; the urgency is now Priority-1 for the next role-file pass.
