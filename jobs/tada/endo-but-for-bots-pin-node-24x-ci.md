## Completion report

**Diagnosis confirmed against actual logs.** The red `test (24.x, ubuntu-latest)` run on PR #340's head (`f081208e1`, run 31870260229) resolved `node: v24.19.0` and crashed in `RemoveEnvironmentCleanupHook` with `Assertion failed: (env) != nullptr` while tearing down better-sqlite3 11.10.0 AVA workers. The last green 24.x runs were on 24.18.0; the float advanced 24.18.0 → 24.19.0 mid-cycle. Both upstream references check out as real and on-point: nodejs/node#65195 ("Use-after-free in `CleanupHookThunkRun`…") and nodejs/node#65196 ("src: fix use-after-free in CleanupHookThunkRun"). One nuance worth recording: the crash is *intermittent* on 24.19.0 (an `llm`-head run at 24.19.0 happened to pass), but 24.19.0 is the version that introduced the regression.

**Change made (narrowest that stops the float).** In `endojs/endo-but-for-bots` `.github/workflows/ci.yml`, pinned all four `24.x` matrix entries (the test/cover/test262-style jobs at the old lines 166, 332, 374, 480) from `[22.x, 24.x]` to `[22.x, 24.18.0]`, each with a comment explaining the pin and citing the two upstream links so it can be lifted once the Node fix ships. The `22.x` lane and the viable-release `'22'` list are untouched. YAML validated.

**PR opened against `llm`:** https://github.com/endojs/endo-but-for-bots/pull/1000 (branch `fix/pin-node-24x-ci-teardown-crash`). **Pin validated:** #1000's own matrix now shows `test (24.18.0, ubuntu-latest)`, which ran and passed **GREEN** — i.e. the previously-red cell is green under the pin.

**Remaining step — gated on a maintainer merge (not doable by this job).** "Re-run CI on the three PRs so they go green" only takes effect once #1000 lands and each PR rebases to pick up the pinned workflow; re-running their current CI before the merge would just re-float. I flagged this to the maintainer via the liaison and asked whether to post the follow-up, including one caveat that blocks a clean sweep:
- **#340** and **#877** — base `llm`; go green once #1000 merges and they rebase.
- **#475** — bases **`llm-a54c3ad`, not `llm`**, so an `llm`-only merge does **not** reach it; it needs `llm-a54c3ad` updated or #475 retargeted.

**Follow-ups:** (1) maintainer merges #1000 to `llm`; (2) rebase/re-run #340 and #877; (3) decide on #475's base (`llm-a54c3ad` update vs. retarget); (4) lift the pin once the Node 24 fix ships (nodejs/node#65196).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-pin-node-24x-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 96 tokens (2635835 cached reads)
- Output: 26939 tokens
- Cost: $2.9808244999999998
- Wall-clock: 678s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
