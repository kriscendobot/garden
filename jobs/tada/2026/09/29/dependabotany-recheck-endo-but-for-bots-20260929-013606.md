I re-checked both flagged Dependabot PRs on `endojs/endo-but-for-bots`. The Node-version conflict still holds for each, so I rejected and closed both with a verdict comment.

**PR #1354 — `vite` 6.4.2 → 8.3.0.** Closed 2026-09-29T01:38:36Z ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/1354#issuecomment-5881993865)).
- At the live head `9f8d3bd…`, the project still declares Node `^20.17.0 || >=22.9.0`.
- `packages/chat`, `packages/preact-container` and `packages/preact-social` each declare `vite ^8.3.0`, and the lockfile resolves 8.3.0.
- npm shows `vite@8.3.0` needs Node `^20.19.0 || >=22.12.0`, which drops Node 20.17 and 20.18, plus 22.9 through 22.11.
- The main branch (`llm`) already has `vite` 8.0.16 in its lockfile for another package, with the same Node requirement. So some of this Node-support gap is already in the tree. I said this in the verdict comment and flagged it as a support-range decision for a maintainer.

**PR #1351 — `@changesets/cli` 2.31.0 → 3.0.3.** Closed 2026-09-29T01:38:37Z ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/1351#issuecomment-5881993703)).
- At the live head `7e3953b…`, the root declares `@changesets/cli ^3.0.3`, and the lockfile resolves 3.0.3.
- That version needs Node `^22.11 || ^24 || >=26`, so it drops all of Node 20.
- 3.0.3 is the newest release on npm, so no newer version brings back Node 20 support.

As instructed, I skipped the full review (lockfile, source, advisories, tests) for both, since the conflict alone decides them.

**Other ledger rows:** none were due. I rebuilt the ledger from the journal and checked it against GitHub: every earlier embargo is merged or closed (#197, #362, #868, #1168). The newest recorded result is #1350, merged 2026-09-27. No recheck schedules needed changing, and the daily check stays in place.

**Ledger:** I added one terminal entry per PR:
- `journal/entries/2026/09/29/013853Z-message-botanist-329dc1.md` (#1354)
- `journal/entries/2026/09/29/013857Z-message-botanist-593e57.md` (#1351)

**Follow-ups:**
- **#1353 is still open** (`vitest` 4.1.11 → 5.0.1). It wasn't on my list and has no ledger row. The watcher found that `@vitest/browser-playwright ^4.1.11` in `packages/preact-container` can't coexist with `vitest` 5.0.1. Its own review job, `endojs-endo-but-for-bots-pr1353-dependabot`, was abandoned after too many retries and is parked in `jobs/plan/`. It needs someone to promote that job again, or a follow-up job for the same one-step check. While it stays open, Dependabot won't propose a newer `vitest` bump.
- The original review jobs for #1351 and #1354, also abandoned and parked in `jobs/plan/`, are now obsolete because both PRs are closed. They can be dropped.
- If the project raises its Node minimum to `^20.19 || >=22.12`, #1354 becomes acceptable; raising it to 22.11 or later does the same for #1351.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260929-013606.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1012852 cached reads)
- Output: 7695 tokens
- Cost: $0.9420064000000001
- Wall-clock: 104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
