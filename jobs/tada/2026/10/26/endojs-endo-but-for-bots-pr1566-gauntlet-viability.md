## Viability report: endojs/endo-but-for-bots#1566

**Result: overtaken.** No clean, panel, fix, CI-wait or un-draft budget was spent, and I changed nothing.

**PR facts:** The PR is open and still a draft. It was opened 2026-10-26T08:20Z on the pinned base `llm-d5ac419`, with head `04a8ce586d`. Its title is "fix(ci): install graphviz-tools and make bwrap tests runner-portable", and it touches two files: `.github/workflows/depcheck.yml` and `packages/sandbox/test/bwrap.test.js`.

**Deciding question:** Is #1566 the only live fix for the Ubuntu 26.04 graphviz and bwrap-test breakages, and does its graphviz premise ("installing `graphviz-tools` restores `tred` and `acyclic`") actually hold?

**Evidence:**
- **The bwrap half duplicates #1542.** #1542 is older (2026-10-22), on the same base `llm-d5ac419`, and no longer a draft. It makes the same two test fixes: it reads `Max processes` from `/proc/self/limits` instead of running `ulimit -u` under dash, and it gives the parent-death test an assertion. It also fixes a driver bug (`--info-fd` init-pid kill). It has been through three fix rounds and CI is green on head `43998e611f` (14 passed, 20 skipped, 0 failed). Its gauntlet stopped at the clean stage and is waiting on the maintainer. It has not been displaced.
- **The graphviz half duplicates #1546, and its premise is false.** #1546 is older (2026-10-24), on the same pinned base, and no longer a draft. It pins `depcheck.yml` to `ubuntu-24.04` because Ubuntu 26.04's Graphviz 14 packaging has no `acyclic` binary at all. #1566's own CI shows that: the `build` job fails at "Check for cycles" with `scripts/graph.sh: line 36: acyclic: command not found` (run 40291625166, job 121467929755). Installing `graphviz-tools` does not restore the check, so #1566's graphviz approach cannot work.
- **Nothing in #1566 is new.** Its test changes are already covered by #1542, and its workflow change is beaten by #1546's runner pin. On `llm`, `depcheck.yml` and the `ulimit -u` test are still unchanged, so the need is real, but the two older PRs already cover it.

**Option: close as superseded**

Instead, the maintainer could move #1542 forward (its gauntlet is waiting on them after the clean stage). #1546 also needs a gauntlet re-run, since it was halted for a floating base and has since moved to `llm-d5ac419`. Once both land, the M3 stack #1560–#1564 that #1566 references is unblocked.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1566-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (422276 cached reads)
- Output: 3268 tokens
- Cost: $0.5497272000000001
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
