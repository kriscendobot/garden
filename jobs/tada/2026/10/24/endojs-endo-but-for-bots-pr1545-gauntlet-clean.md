---
orchestration-failed: true
---
orchestration-failed: true

# PR #1545 clean stage: coverage pushed, CI red from two runner-image breakages unrelated to this PR

CI is red at head `18d1a263eb`, so this stage fails. The four red checks all come from two known breakages caused by `ubuntu-latest` moving to the ubuntu-26.04 runner image. Neither involves `packages/exo-dynamodb`.

**What I changed:** one commit, `18d1a263eb`, pushed to `gardener/fu-design-recursive-dynamodb-capabilities-1` with `safe-push-pr-head.sh` (a fast-forward from `95ff807a07`).
- **Bug fix in `src/control.js`, found by the coverage pass.** A query that gave no sort condition used the outermost ancestor's sort range. A narrower descendant then rejected it. So a grandchild restricted to one exact sort key, under a root restricted to a sort-key prefix, could not run any query unless the caller passed an explicit sort. The query now collects every ancestor's sort bound, uses the narrowest one, and checks it against all of them. Existing error messages are unchanged.
- **New and extended tests:**
  - `test/control-responses.test.js` covers:
    - Items returned by update, delete, query and `transactGet` are trimmed to the fields the grant allows.
    - Query rows from outside the grant are rejected, not leaked.
    - Sort-range injection and rejection.
    - All four `transactWrite` member kinds, plus the idempotency token.
    - Rate-limit windows, cancellation and `inspect`, throttle errors, and SDK clients called by method name.
  - `marshal.test.js` adds number sets, fractions and invalid input. `restriction.test.js` adds attenuation conflicts and binary or numeric keys.
- **Coverage:** statements went from 86.4% to 98.35%, branches from 68.6% to 83.4%. All 24 tests pass locally, and package `tsc`, eslint, prettier and the repo-root `tsc` are clean. No dead code needed removing.

**CI failures at `18d1a263eb`:**
- **`build`** (workflow "Test project mutual dependency versions"): `scripts/graph.sh: line 32: tred: command not found`. graphviz 14 on 26.04 no longer provides `tred`. This has failed on every PR since about 2026-10-23T11:47Z and passed on ubuntu-24.04.
- **`sandbox-drivers`, `cover (22.x)` and `cover (24.x)`:** the two bwrap tests in `packages/sandbox` fail, one with `/bin/sh: ulimit: Illegal option -u` and the other ("parent death leaves no owned process group") ending without running any assertions. PR #1542 fixes this; it is still an open draft on `llm-d5ac419`.
- The four `test` legs were still running when I stopped. The failures above are already final, so the result cannot turn green.

**Follow-ups:**
- I posted job `endojs-endo-but-for-bots-ci-ubuntu2604-graphviz-tred`, a fixer for `depcheck.yml`, because nothing on the board owned the `tred` breakage.
- Once #1542 and the `tred` fix land, #1545 needs a weave onto the new base before CI can go green.
- **For the panel:** `types.ts` says sets may contain `Uint8Array`, but a CopySet cannot hold one. So the code that writes binary sets can never run, and reading a binary-set attribute throws "Cannot pass mutable typed arrays". This needs a design decision (for example, using the immutable byte-array pass style), so I left it alone.
- The PR #1544 gauntlet already told the maintainer about this runner breakage, so I did not alert them again.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1545-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (5407778 cached reads)
- Output: 30615 tokens
- Cost: $2.7270635999999993
- Wall-clock: 1934s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
