The ci-watcher's stale-shepherd sweep can now retire a claimed auto-shepherd, but only once that shepherd's run has ended and CI is no longer red. The change is pushed to main2 as `3c8215c9251`. The ci-watcher test suite passes 132/0, including two new cases.

**What changed** (`scripts/jobs/ci-watcher.sh`):
- **Which jobs it touches:** besides unclaimed `todo/` shepherds, the sweep now also checks `doin/` auto-shepherds that carry the gardener's reap-now hint. That hint is the gardener's durable record that the run has ended and nobody is working the job, which is the state the pr1636 shepherd was left in. A `doin/` shepherd without the hint is still being worked and is never touched, so the existing "never touch a claim" test still holds.
- **Same-claim check:** when the sweep reads a `doin/` shepherd, it records that file's git blob id. `retire_stale_shepherd` now takes a lane argument (`todo` or `doin` plus the blob id). On every attempt inside the retry loop it re-checks that the live file is still exactly that blob and still has the hint. If the job was re-claimed, requeued, rewritten by the reaper or re-stamped, it is left alone and the refusal is logged. Because the push to origin is the serialization point, a peer push in between makes ours fail, and the check re-runs after re-syncing.
- **When it retires:** only on the same definitive verdicts as before (green, no checks, or in progress/queued). A still-red or unreadable rollup leaves the job where it is. It shares the existing per-tick rollup budget and stops at the primary-quota limit like the `todo/` path.
- **Record:** the same tada completion record with the completion marker, with wording for the claimed case and the lane named in the commit subject.

**Tests** (`scripts/jobs/test/ci-watcher-test.sh`):
- **O2:** a claimed shepherd with the hint stays in `doin/` while CI is red, then retires to `tada/` with the completion marker once CI is green.
- **O3:** a re-claim that lands after the sweep's check (pushed by the stub that fakes the rollup check) stays in `doin/`, and the refusal is logged.
- I also made the suite's hardcoded scratch root overridable with `GARDEN_CIW_TEST_ROOT`. The default `/home/kris/.garden-ciw-test` can't be written from the monk sandbox (read-only), so the suite couldn't run there.

**Follow-ups:** none required. The pr1636 shepherd itself, if it is still in `doin/` with the hint, should be retired by the leader's ci-watcher on its first tick after this is deployed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-retire-claimed-stale-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1711105 cached reads)
- Output: 15924 tokens
- Cost: $1.3240290000000003
- Wall-clock: 267s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
