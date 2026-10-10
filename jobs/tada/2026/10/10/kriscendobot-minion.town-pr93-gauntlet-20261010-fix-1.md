Fix round 1 for kriscendobot/minion.town#93 is pushed, and CI is green on the new head (`ci-wait-merge` returned 0).

**The panel's one must-fix:** the PR body was 472 words against a 300-word limit. I rewrote it at about 230 words:
- Removed the "Why this is the authoritative strand" section.
- Replaced the inline test tally with a link to the CI checks.
- Added a sentence on why guest-side cleanup and `--drop-unresolved` belong in this PR, which another panel item asked for.

**Should-fix items also applied**, pushed through `safe-push-pr-head.sh` as `0022b04` → `2df7849`:
- **`11a96f2`:**
  - `deploy.yml`: put back the blank line that had been removed by mistake.
  - `.env.example`: moved the `GATEWAY_GC_*` lines into their own section, with an accurate note on the deploy default and the CLI's `--delete` flag.
  - `endo-gateway-gc.service`: added `TimeoutStartSec=30min` so a stuck run can't block the next timer firing.
- **`1b53b8d`:** when `internBlob`'s timestamp refresh on an already-stored blob fails with any error (not just a missing file), it now re-writes the blob instead of failing the publish. I added a regression test and confirmed it fails against the old code.
- **`2df7849`:** `DEPLOYMENT.md` now explains how to recover by hand when a bad settled record blocks every GC run.

**Tests:** typecheck passes and the gateway tests pass (180). The full local `npm test` had one failure, in `test/git-remote/capability.test.ts`, which this PR doesn't touch; I didn't check it against the unchanged head. CI's `test` job passed.

I posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/93#issuecomment-6096925503

**Left for later:**
- Merging the two near-duplicate guest pet-name removers.
- Direct tests for the atomic `writeVhostRecord` and the worker-name fallback.
- Reverting the unrelated docs typography changes.
- The panel's follow-up items: the small race window in the sweep, and a privilege review of the GC unit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2193507 cached reads)
- Output: 11706 tokens
- Cost: $1.2960294
- Wall-clock: 871s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
