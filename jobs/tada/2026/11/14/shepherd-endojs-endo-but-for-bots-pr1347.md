## Shepherd report: endojs/endo-but-for-bots#1347 (`build/endo-gateway`)

PR #1347 has no failures caused by its own changes, so I pushed nothing. Its two red checks come from a CI runner problem that is fixed in a different PR. That PR (#1585) has not merged yet. A weave job is already parked and will start when it does.

**CI state on head `c8c654e2d5`** (base frozen at `llm-9a14ddf`, 8 commits behind `llm`; mergeable, still a draft):
- All gateway and JavaScript checks pass: lint, build, tests and coverage on Node 22 and 24 for Ubuntu and macOS, viable-release, zizmor, check-action-pins, and more.
- Two checks fail: `test-ironhorse-oracle` (run 41195974871) and `ironhorse-oracle-sanitizers` (run 41195974856). These runs are from 2026-10-31.

**Why they fail and why it isn't this PR:**
- The two failing tests are in the IronHorse Rust engine: `ironhorse-262` `corpus_conversion_equivalence` and `generated_multi_crank`.
- The engine accepted test sources that the reference engine rejected. The values differ by one unit in the last place: `Expected SameValue(«1.475044781241425», «1.4750447812414251»)` and `«1.300820426840647»` vs `«1.3008204268406467»`, from `Math.asinh` and `Math.acosh`. Both jobs ran on the `ubuntu-26.04` runner image. This is the known glibc math-library drift on that image.
- The PR only touches `packages/gateway`, a changeset and `yarn.lock`. These oracle jobs run at all only because `scripts/ci-changes.py` treats the `yarn.lock` change as a shared JavaScript input.
- An earlier fixer job (`fix-endojs-endo-but-for-bots-pr1347-ci`) reached the same diagnosis.

**What is already queued:**
- `plan/endojs-endo-but-for-bots-pr1347-weave-after-pr1585` is parked and blocked on #1585 ("accept both faithful roundings for stage3-math asinh/acosh"). Once #1585 merges, it re-pins #1347 onto a fresh `llm` snapshot and checks that the two oracle checks pass.
- #1585 is still open and still a draft. It has one red check of its own, `test (22.x, macos-15)`.
- #1613 (move the oracle jobs to Ubuntu 24.04) is a second possible fix. It is open, not a draft, and all its checks pass. If it merges first, the parked weave's condition would need to point at it instead.

**What I did not do:**
- I did not rerun the two failed jobs. They would run on the same 26.04 image and fail the same way.
- I did not post anything on the PR, because the job didn't authorize comments.

**Verdict: `next: none`.** Nothing in the PR needs fixing. To get a fresh gauntlet, either #1585 or #1613 has to merge; the parked weave then starts and the gauntlet can be re-run on the new head. If you would rather have #1613 unblock it, the weave's `blocked_on` needs updating.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8f85b41bb307e512e4f810070dcfd67450d15c32`; this job presented `c8c654e2d5251ab5175226190b4cd8b59394f6c9`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket accepted a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1347.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1086057 cached reads)
- Output: 5769 tokens
- Cost: $0.9231834
- Wall-clock: 89s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
