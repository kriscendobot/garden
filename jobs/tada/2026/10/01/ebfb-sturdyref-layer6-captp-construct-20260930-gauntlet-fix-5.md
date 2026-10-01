# Gauntlet fix round 5 — endojs/endo-but-for-bots#1396: fixes pushed, CI green

I applied all four must-fix items from panel round 5, pushed them to the PR head (`be6579730c`), and CI is now green. `ci-wait-merge.sh` returned rc 0 with 0 failures out of 66 checks.

## What changed on the PR

1. **Weave and the `l-0` locator.**
   - I froze #1394's current head (`75167825`) as a new base branch, `build/sturdyref-captp-wire-7516782`, rebased the PR onto it, and moved the PR's base and the base name in its body to match.
   - This brings in the base's `Far` enliven facet. The `l-0` SturdyRef locator now gets the same treatment: it answers only `locate` with exactly one string argument, and rejects any other method, argument count, or property get.
   - A new test covers those refusals.
2. **ocapn copies at mint time.** Minting a SturdyRef now copies its location, `hints`, and secret bytes. Reading the data builds a fresh `hints` record, so it no longer freezes the caller's object. A new test mutates the caller's objects before the first read and checks the data is unchanged.
3. **Type forward.** `packages/ocapn/index.js` now forwards the `SturdyRefData` type.
4. **Changeset.** `.changeset/sturdyref-captp-construct.md` is wrapped to 80 columns.

I did not apply the panel's optional should-fix items.

## Getting CI to green

- **Flakes:** The macOS test jobs timed out in hosted-agent and daemon, and a `cover` job failed in thixotrope. None of those packages are changed by this PR, and all passed on rerun.
- **Stale cancelled entries:** Reruns of two CI runs on the same commit cancelled each other, because they share a concurrency group. That left cancelled jobs on the commit that `ci-wait-merge.sh` counted as red even though the live checks had passed. I reran the cancelled jobs, and the next check came back green.

## Follow-up

`ci-wait-merge.sh` reads every check entry on the commit rather than the latest result for each check name. Any cancelled run left on the same commit therefore makes CI read red even when all live checks pass. This is worth fixing in the garden.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 160 tokens (7556473 cached reads)
- Output: 27889 tokens
- Cost: $6.0378571999999995
- Wall-clock: 7650s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
