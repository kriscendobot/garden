Fix round 3 is pushed to kriscendobot/minion.town#216 and CI is green on the new head `8bd49c9d`.

**Must-fix items:** This round had no pre-pass block, so I worked from the latest panel review (04:58:09Z). Two of its seats asked for changes: decomplector and pruner.

- **decomplector #1** said the store keeps two sources of truth for a guest's bonds: the fingerprint index plus the per-guest ledger. It allowed two ways out: replace them with one bond item per (guest, identity), or say in the PR why that won't work. I wrote the justification and left the code as it is (commit `b16b040e`):
  - Bonds that `main` already wrote exist only as attributes on account rows. Only the index finds them without a backfill `Scan`. The app role is denied `Scan`, and an operator would have to time the backfill against the app restart.
  - The ledger is still needed because the index is eventually consistent.
  - Either design keeps the per-row confirming read, because an account can re-bond to another guest and leave an old entry behind.
  - The index can be removed once a backfill gives every older bond a ledger entry.

  This reasoning is now in the PR body and in the comment on `candidateKeys` in `src/auth/stores/dynamodb.ts`. The decomplector may still prefer the redesign when panel-4 runs.
- **pruner #1–4** asked for trims only, all applied (commit `8bd49c9d`):
  - The PR body is shorter: the feature list is cut and each commit gets one line.
  - The guest-credential gate comment in `deploy-app.sh` now keeps only the fail-closed rule and its `DEPLOYMENT.md` pointer.
  - In `designs/closed-beta-waitlist.md`, the slogan sentence is gone and the paragraph is re-wrapped.
  - Two doc comments that repeated the next line are deleted, in `root-host-socket.ts` and `account-deletion-audit.ts`.

I did not address the two should-fix items, decomplector #2 and #3.

**Checks:**
- Locally, `tsc --noEmit` is clean and the 4 affected test files pass (30 tests).
- I pushed with `safe-push-pr-head.sh` (`201f52b3` → `8bd49c9d`) and posted a fix-round comment on the PR.
- My first CI wait was killed by the tool's time limit before it reported. I re-ran `ci-wait-merge.sh` with a 540-second deadline instead of 3600 so it would finish in time; it returned rc 0 (GREEN).
- The bot token can't read the PR's check status, so the helper used the Actions runs API, which saw only the 2 Actions runs and no other kinds of check.

I did not re-run the panel; the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1831782 cached reads)
- Output: 13033 tokens
- Cost: $1.2296323999999998
- Wall-clock: 1968s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
