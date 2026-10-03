Panel round 1 on endojs/endo-but-for-bots#1397 came back **must-fix**. I posted the verdict to the PR as a comment review, not a request-changes review, because GitHub won't let the bot request changes on its own PR.

**How it ran**
- **Checkout:** isolated worktree `/home/kris/garden2/scratch/project-wt-ebfb-st-cbfc04a44954-b429abf3` at head `1eb434a3e8`.
- **Panel:** single-round mode against the PR's actual base commit `b0778fab75` (`build/sturdyref-captp-construct-b0778fa`), not the possibly stale `origin/<baseRef>`. It exited 0 with disposition `must-fix`.
- **Restart:** my first launch didn't record the exit code, so I killed it about a minute in and ran it again with the exit status captured. Only the second run produced the verdict.
- **Record:** the panel saved its run to the journal at `panel-runs/endojs-endo-but-for-bots-1397/c138b096effc.md`.
- **Seats:** 32 of 33 returned a labelled verdict: 6 request-changes (integrator, changeset-auditor, pruner, corner-prober, procurer, and one more), 7 comment-only, the rest approve. The archivist block had no verdict label in its heading, but its text says "Should-fix".

**What needs fixing**
- **Title and commit type:** both say `feat(ocapn): layer 7 — …`, but the change is a patch-level bug fix. The integrator suggests `fix(ocapn): enliven a returning SturdyRef with a wire-decoded swiss number`.
- **Stale base in the description:** it names `build/sturdyref-captp-construct-ef45f1d`; the real base is `…-b0778fa`.
- **Missing test:** nothing covers a locally minted byte secret that decodes as ASCII and is enlivened at home. The diff changes how that case resolves (it now tries the string lookup first, then the raw bytes).
- **Suggested but optional:** a `@returns` annotation on `lookupSwissnum`, and fast-check property tests for the string/byte round trip.

**The posted review:** https://github.com/endojs/endo-but-for-bots/pull/1397#pullrequestreview-5399006606
- The full text was 75 KB, over GitHub's 65,536-character limit. The review includes every request-changes and comment-only seat in full plus most approvals. Eight approving seats are listed by name only, with a pointer to the journal record for their full text.
- It ends with a `garden-gauntlet … disposition=must-fix` marker.

I didn't fix anything or take the PR out of draft. The fix loop is the next stage's job.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1522031 cached reads)
- Output: 7722 tokens
- Cost: $0.9563181999999999
- Wall-clock: 573s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
