---
ts: 2026-05-21T12:05:49Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/21/115137Z-result-fixer-295f9f.md
  - entries/2026/05/21/054802Z-result-weaver-7d7d5e.md
  - entries/2026/05/21/073647Z-result-judge-0a27af.md
---

Fixer dispatch on PR endojs/endo-but-for-bots#101 ("feat(chat): voice
input") post-weaver-bb0b4c rebase. CI snapshot named three reds:
`cover (20.x)`, `cover (24.x)`, `lint`. Investigated all three.

Disposition: **all three failures are pre-existing infra debt on the
`llm` base**, not PR-introduced. **No fixes shipped from this dispatch**;
HEAD remains `2f017c04e`.

Root cause (single, shared by all three jobs): upstream master commit
`bdb9ddc5` ("feat(syrup-frame): add @endo/syrup-frame package and
opt-in syrup framing for OCapN TCP-for-testing") landed on `llm` via
the `b381e6ada` merge ("merge: actual/master into llm"). The new test
file `packages/ocapn/test/netlayer-tcp-syrup.test.js` imports
`makeClient` from `../src/client/index.js`, but the `llm` branch's
`@endo/ocapn` exports `makeOcapn` and never had `makeClient`. The
rename / API reshape on master did not land in the bot estate. Same
gap weaver 7d7d5e called out and the prior fixer 295f9f addressed on
PR #125's branch.

Per-failure detail:

- **`cover (20.x, ubuntu-latest)` (job 77166034112)**: failed at step 7
  `Run yarn test:c8` with `Uncaught exception in test/netlayer-tcp-syrup.test.js`
  / `SyntaxError: The requested module '../src/client/index.js' does
  not provide an export named 'makeClient'`. The `@endo/ocapn`
  workspace failed; all other workspaces' tests passed, including the
  PR's own `packages/chat/test/component/voice-input.test.js` (22
  tests, all green; coverage 100% statements, 96.77% branches on the
  new `voice-input.js`).
- **`cover (24.x, ubuntu-latest)` (job 77166034101)**: identical
  failure shape and root cause as 20.x.
- **`lint` (job 77166034090)**: failed at step 7 `Run yarn lint` with
  `error  makeClient not found in '../src/client/index.js'
  import/named`. The lint surface shows 1839 problems total (1 error,
  1838 warnings); the lone error is the same `makeClient` import in
  the new test file. The PR's own diff (`packages/chat/*`,
  `designs/*`) shows no lint errors.

PR-introduced vs pre-existing analysis:

- The PR's diff vs `origin/llm` is bounded to `packages/chat/` and
  `designs/*` (10 commits, all `feat(chat)` / `fix(chat)` /
  `docs(chat)` / `design(chat)` / `fixup(design)`). The PR does not
  touch `packages/ocapn` at any point.
- The `makeClient`-importing test file is in
  `packages/ocapn/test/netlayer-tcp-syrup.test.js` and is present on
  `origin/llm` (the merge from upstream master brought it in). It is
  not on the PR's diff.
- Any PR opened against the current `origin/llm` (head `ea8f5bfb5`)
  whose base is post-`b381e6ada` will hit the same three failures.
  Verified by inspecting #333 (dependabot, post-merge base): same
  three reds. PR #330 (open, but with a pre-merge base
  `37dce60ef`) has all three green.

Why no fix on this PR's branch:

- The dispatch prompt distinguishes infra failures from
  PR-introduced failures and asks the fixer to "leave" the former.
  The lint failure here is at the `Run yarn lint` step (not at the
  SECURITY.md uniformity step the prompt named), but it is not "a
  real lint error in the PR" since it touches a file outside the
  PR's diff. The right reading is the dispatch's spirit: infra-debt
  failures inherited from the base are not the fixer's lane on PR
  #101.
- Fixer 295f9f (11:51 UTC today) addressed the same gap on PR #125
  by stubbing the broken test file to a 14-line `test.skip`
  placeholder. That stub will land on `llm` when #125 merges, after
  which a rebase of #101 onto post-merge `llm` will inherit the
  stub and CI will be green (modulo SECURITY.md hash divergence,
  which is a separate llm-base hygiene debt).
- Duplicating the stub across every PR open against `llm` would
  multiply the same fix across branches; the single-PR-#125 path is
  the cleaner ledger.

Recommended next step for the orchestrator:

- Option A: merge #125 first (it carries the stub), then rebase #101
  onto the post-merge `llm`. After rebase the three reds become two
  (`lint` reverts to `Check SECURITY.md uniformity` infra debt;
  `zizmor` is another pre-existing red). Cover should go green.
- Option B: if #101 needs to merge before #125, cherry-pick the
  `93e9cd2d0` stub commit (or equivalent) onto #101 explicitly as
  a "chore(ocapn): stub broken test (port owed to upstream
  makeClient API)" commit. This is the same shape fixer 295f9f
  used and would unblock #101's CI.

The dispatch's task framing ("ship fixes for PR-introduced failures")
plus the explicit SECURITY.md-style guidance ("if it's at yarn lint
(a real lint error in the PR), fix it") read as Option A's spirit:
the lint error is not a real lint error in the PR.

Post-fix CI snapshot: not applicable (no fix pushed).

Self-improvement: nothing this time. The pre-existing-infra-vs-PR
disposition discipline is well-documented in the prior fixer
(295f9f), weaver (7d7d5e), and judge (0a27af) entries; the chain
worked.
