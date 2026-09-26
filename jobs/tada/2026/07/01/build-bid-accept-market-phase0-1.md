Inbox empty, PR #19 open/ready/mergeable. Job complete.

---

## Completion report

**Job:** `build-bid-accept-market-phase0-1` — first mergeable increment of `designs/gardener-bid-accept-market.md` (§6 phased rollout). Delivered as **DRAFT→ready PR [kriskowal/garden#19](https://github.com/kriskowal/garden/pull/19)** against `main2`, commit `e090a48d8`.

### What I did
Implemented the additive, zero-behavior-change Phase 0/1 base and ran the build gauntlet (design as the researcher reference, hermetic tests as local-verify, an adversarial panel self-review), then un-drafted the PR to terminate the chain and posted a top-level summary comment.

### What changed
- **Phase 0 — `market: race | bid` field (default `race`):**
  - `common.sh`: `job_market` / `job_is_bid` — normalize the frontmatter field; absent/blank/typo → `race` (never strands a job out of the race path).
  - `claim-job.sh`: the **no-op guard** — a `market: bid` job is skipped by the straight race (accrues in `todo/` for the future handshake); a `race`/default job takes exactly today's path.
  - `post-job.sh`: reject an invalid `market:` mode at post time.
- **Phase 1 — append-only shadow reputation ledger (accrues, never selects):**
  - `common.sh`: `stage_reputation_event` / `reputation_event_relpath` / `reputation_claim_field` / `iso_delta_seconds` — each event is its own date-sharded file (fast-forward ADD; no lock service, push is the serialization point).
  - `complete-job.sh`: records an `accepted` event in the same commit as the `tada`, with a real award→completion duration; dollars `unbooked` for the race path (honest per §3.4/§3.6). Strictly best-effort — cannot strand a completion.
  - `reputation-backfill.sh` (new): retroactively seeds events from `jobs/tada` history via `git log`; idempotent, batch-bounded.
  - `bulletin.sh`: a `## Shadow reputation` section surfaces per-gardener accept/reject tallies (deterministic, no LLM, capped).
  - `test/reputation-market-test.sh` (new): 28 hermetic assertions, all pass.

### Verification
28/28 tests pass against real primitives; `bash -n` clean over `scripts/`+`skills/`; grep-gates clean for touched files (the two firing gates are pre-existing on `main2`, confirmed identical on a pristine checkout). Panel self-review cleared all seven risk areas (`set -e` safety, race invariant, no stranding, CAS uniqueness, bulletin change-compare, the `rc=$?`-after-`if` pitfall, post validation). `main2` PRs get no CI run (workflow triggers on `main`), so the local gauntlet is the gate.

### Follow-ups
- **Design dependency:** the design doc lands via #16 (approved, still open); #19 references it by path and does not duplicate it — merge after/alongside #16.
- The pre-existing `bash -n`/grep-gate failures (`claude-md-inventory-drift`, `maintainer-inbox-information-hiding`, and `test_run_all`'s missing-`claude` sandbox failure) are unrelated to this diff.
- Later increments (deferred, not in scope): the broker (bid selection), the acceptance oracle (§4), and letting reputation actually drive selection (Phase 2+).
- Note: the adversarial-reviewer subagent I first dispatched died at a session limit without running; I performed the panel review directly after the reaper requeue resumed the job.
