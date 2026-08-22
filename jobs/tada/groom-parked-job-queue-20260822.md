All 34 withdrawals landed on `origin/journal2`, the `withdrawn/` tombstone shelf holds exactly 34, every kept entry is intact, and no target lingers in `plan/`. The `main2` script+doc push landed earlier. Work is complete.

---

## Completion report

**Job:** groom the parked-job queue — prune confirmed-moot `jobs/plan/` entries.

### Mechanism (new, auditable tool)
No existing cancel/withdraw/prune script existed, so I added one rather than hand-`git rm`-ing:

- **`scripts/jobs/withdraw-plan.sh [--by R] <base> <reason>`** — modeled on `promote-plan.sh`: operates on the shared producer clone, CAS-push retry-with-backoff loop, single-basename move. It **moves** `plan/<base>.md → jobs/withdrawn/<base>.md`, prepending a `withdrawn:` frontmatter block (reason / who / when / originating gate) and preserving the original body verbatim, so every pruning carries a durable, greppable "why" the same way every other board mutation is committed. `jobs/withdrawn/` is a deliberate sibling of `plan/todo/doin/tada` that **no watcher enumerates** (each scans its own specific dir — I verified nothing globs `jobs/*`), so it is inert: the "removed-without-completing" counterpart to `tada/`. Idempotent (no-op success if the base already left `plan/`), reason is required.
- Documented it as a **Withdraw** bullet in `skills/job-board/SKILL.md`.
- Committed + pushed to `main2` (commit landed on first attempt).

### Verification approach
Re-derived every candidate against live GitHub state (`gh pr view`/`checks`) and the live board — did not trust the hour-old survey. The board had already moved a lot: all ~50 `-retro` jobs the survey listed were already promoted+completed (in `tada/`), so only a fraction of the named candidates still existed in `plan/`.

### Pruned — 34 entries (each `withdrawn/` tombstone records the specific reason)
- **endojs/endo-but-for-bots #475 (OPEN) — 8 doomed review/attention dups**: `pr475-{54294cd3, e8792d98, review-07347c0d, review-1c227402, review-1c83e1bb, review-92a260ae, review-c85b88c9, review-f1df1c4f}`. Each is a requeue-exhausted doomed stub whose `-retro` audit sibling has **completed in `tada/`**, and #475 has been driven forward by a whole newer review round (08-21/22) plus many completed follow-up jobs — the specific threads are audited and superseded.
- **Resolved endo PRs**: `pr403-e97aa392` (#403 MERGED), `pr286-merge` + `pr286-refresh` (#286 CLOSED), `pr856-weave` (#856 MERGED), `ebfb-pr882-bootstrap-generators` (#882 MERGED), `pr980-review-aa7b9d57` (#980 MERGED — retro siblings left intact), `pr993-shepherd` (#993 CLOSED), `pr998-review-322c54b7` + `pr998-review-684b93c1` (#998 MERGED), `pr1006-dependabot` (#1006 MERGED), `pr1026-{4e268706,d59ca42b,ddfd6228}` (#1026 MERGED).
- **#910 (MERGED)**: `pr910-mustfix-round2-06-repanel`, `pr910-review-4941452327-fuzz-build`, `pr910-review-4941452327-shepherd` — confirmed the owning orchestration `pr910-review-4941452327-resolution` is already in `tada/` (complete, not active), so pruning the orphan children is safe.
- **minion.town**: `pr20-merge-20260819` + `pr20-review-c7ac7b26` (#20 MERGED), `pr21-gauntlet-clean` (#21 CLOSED), `pr39-gauntlet-panel-1` (#39 MERGED), `pr47-gauntlet-panel-1` (#47 MERGED), `build-minion-town-git-content-substrate-gauntlet-panel-5` (targets #48, CLOSED).
- **agoric-sdk**: `kriscendobot-agoric-sdk-pr15-shepherd` — verified #15 CI fully green (65 pass / 12 skip / 0 fail), nothing to shepherd.
- **Annotated-superseded**: `proposal-compartments-xs-source-phase-design` (its sibling `-parser-design` file explicitly says "discard rather than promote"), `finbot-pr5-panel-20260727` (`finbot-pr5-panel-20260801` says do-NOT-revive), `genie-docs-02-delete-from-llm` (its own in-file SUPERSEDED note; confirmed the r2 chain — `genie-docs-r2-01-migrate` + `genie-docs-r2-02-delete` — is **already completed in `tada/`**, so a bare prune, no repost needed).

### Left alone (and why)
- **`registry-immutable-byte-array-followup-gauntlet-panel-1`** (#888) — **#888 is still OPEN** and its own in-file liaison note says "the work is wanted." A doomed gauntlet stage on a live PR is a diagnose/requeue decision, not moot; that's outside this hygiene job's scope. Flagging for a separate decision.
- **`pr910-review-4941452327-base64-cleanup`** — kept per instructions (durable follow-up `gate: blocked` on the live #475).
- **`build-minion-town-ocap-mailboxes`** — `blocked_on` the OPEN #37; legitimately blocked, not moot.
- **`kriscendobot-minion.town-pr37-gauntlet-panel-6`** — #37 OPEN.
- **`proposal-compartments-xs-parser-design`** / **`finbot-pr5-panel-20260801`** — the superseding / deliberately-shelved entries (20260801 carries a 2026-08-22 "left parked, not pruned — deliberate deprioritization" note).
- **`pr475-arraybuffer-tests-5362070662`** and **`pr475-review-237b89d7-followup`** — not on the candidate list, distinct live work (not the `-retro` sibling), could not positively confirm moot → left parked.

### Counts
- `jobs/withdrawn/` shelf now holds exactly **34** tombstones (matches the 34 withdrawals).
- `jobs/plan/` observed **196 at survey start → 131 now** on `origin/journal2`. The net delta exceeds 34 because the live fleet promoted/completed other jobs concurrently while I worked (the withdrawals hit several push races and re-synced cleanly). My attributable change is the 34 withdrawals; no target lingers in `plan/` and all kept entries verified present.

### Follow-ups
- One flagged decision for the maintainer/liaison: `registry-immutable-byte-array-followup-gauntlet-panel-1` (#888 open, doomed since 08-01, "work is wanted") wants a diagnose-or-requeue call, not a prune.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/groom-parked-job-queue-20260822.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 59 tokens (2593128 cached reads)
- Output: 40616 tokens
- Cost: $3.3812090000000006
- Wall-clock: 806s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
