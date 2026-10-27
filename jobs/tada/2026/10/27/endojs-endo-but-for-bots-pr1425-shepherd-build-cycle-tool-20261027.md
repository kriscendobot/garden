PR #1425 is now green: all 15 checks pass on the new head `2db6a81714`, including the `build` job that was failing.

**Cause:** the `ubuntu-latest` runner moved to Ubuntu 26.04. Its graphviz 14 package no longer includes `tred` (now in `graphviz-tools`) or `acyclic`. So `scripts/graph.sh` exited 127 in the "Check for cycles" step of `.github/workflows/depcheck.yml`. #1425 itself didn't cause it.

**What changed:** one commit on `fix/ses-xs-lockdown-compartment-intrinsics`, `2db6a81714 fix(ci): install graphviz-tools and detect cycles with tsort`:
- `.github/workflows/depcheck.yml` now installs `graphviz-tools` when `tred` is missing, then checks that `dot` and `tred` are present.
- `scripts/graph.sh` and `scripts/check-dependency-cycles.sh` now find dependency cycles with coreutils `tsort` instead of Graphviz `acyclic`.

This is the graphviz part of the existing draft PR #1566 (`fix/ci-runner-bwrap-and-graphviz`, based on `llm`), carried over as-is. I left out its bwrap test changes because no bwrap check failed on #1425. I had to carry it rather than wait because #1425 sits on a stack based on master (#1427, then `master-6ee3fda`), so it never picks up `llm`'s CI fixes. I couldn't run the cycle check on this host because graphviz isn't installed; CI is the only verification, and it passed.

**Follow-ups:**
- The carried commit isn't part of the SES change. Drop it once #1427 / `master-6ee3fda` gets the fix, or once #1566 lands and is carried to master.
- Any other PR on a stack based on master will hit the same `tred` failure until then.
- #1425 is still a draft; un-drafting is left to the usual gauntlet. Nothing else in its path to #1349 was touched.
- No inbox messages arrived.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-shepherd-build-cycle-tool-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (872842 cached reads)
- Output: 6209 tokens
- Cost: $0.7617563999999999
- Wall-clock: 645s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
