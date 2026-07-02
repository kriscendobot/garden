All work is landed on `main2` and verified. Here is my completion report.

---

## Completion report: rework-poison-park-and-dedup

**What the job asked:** change the reaper's POISON path on two axes — (1) park a requeue-exhausted job in `jobs/plan/` instead of dropping it, and (2) amend an existing keyed maintainer notice instead of posting one message per poison event (the 37-identical-messages restart flood).

**What I changed** (landed on `main2` as `63d0ce804`):

1. **`scripts/jobs/reaper.sh` — park, don't drop.** On poison the reaper now writes `jobs/plan/<spine>.md` (in the same batched board commit that removes the `doin/` claim) under a **held `go-ahead` gate** with poison provenance (`poison_signature`, `poison_count`, `requeue_cycles`, `deadline_overruns`, `poisoned_at/on`) and the preserved original body. I chose `go-ahead` (not the spec's loosely-worded "deferred") **specifically because** `deferred` is auto-promotable by the foreman via `plan_deferred_ranked`; `go-ahead` is selected by *no* auto-promoter (verified: foreman→`deferred`, unblock→`blocked`, orchestrate→`orchestrated`), so a poisoned job stays held until a human runs `promote-plan.sh`. Basename = the original spine, so a re-poison overwrites the same entry (no duplicates).

2. **`scripts/jobs/poison-notice.sh` (new) — amend-or-post dedup.** A sibling of `inbox-send.sh` keyed on `<job-base>+<failure-signature>` → deterministic file `inbox/maintainer/unread/poison-<base>-<sig>.md`. Present-and-unread ⇒ amend (bump `notice_count`, refresh `last_seen`, keep `first_seen`); absent ⇒ post fresh. "Substantially different" = different job **or** different signature (`requeue-exhausted` vs `deadline-overrun`). Archived-then-recurs ⇒ fresh notice.

3. **`scripts/jobs/orchestrate.sh` — regression fix I discovered.** A poisoned *orchestrated* child now lands in `plan/` (`poisoned: true`) instead of vanishing, so `child_state` had to be taught to read a poisoned plan as `failed` — otherwise the watcher would re-promote and re-run a job that fails every cycle, forever. Applies the on-child-failure policy while preserving the work in `plan/`.

**Verification (executed, cited):**
- New `reaper-poison-park-test.sh`: **5/5 pass** — park (gate=go-ahead, provenance, original body, gone from doin, not in todo, excluded from `plan_deferred_ranked`); dedup (2nd poison → one plan entry + `notice_count: 2` amended, not two); different-reason → new keyed notice.
- New `orchestrate-test.sh` SUBTEST 5: **pass** — poisoned parked child read as failed, not re-promoted; full suite **16/16**.
- Updated poison assertions in `run-test.sh`/`timeout-classifier-test.sh`/`completion-signal-test.sh` from "dropped" to "parked in plan/": `timeout-classifier` **32/32**, `completion-signal` **17/17**.
- Full `run-test.sh` parity confirmed by running **baseline (stashed) vs branch**: baseline **258 pass / 4 fail**, branch **259 pass / 4 fail** (one added assertion). The 4 failures are **pre-existing** and in unrelated subtests (SUBTEST 26 issue-inbox, G issue-source-gh) — present identically on the untouched baseline.

**Follow-ups / notes:**
- Poison-parked plans surface in the bulletin as ordinary parked jobs (arguably desirable visibility); not changed.
- `poison_count` accumulates only across re-poisons *while the plan file persists*; a promote→re-poison cycle resets it to 1 (promote removes the plan file). The dedup guarantee (one entry, one amended message) holds regardless — the message dedup lives in the maintainer inbox, independent of the plan file.
- The board-contract README (`journal/jobs/README.md`) lives on the journal branch and needed no change — I reused the existing `go-ahead` gate rather than forking a new state, per the spec.
