---
ts: 2026-05-25T19:35:18Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
---

Shepherd verdict on PR #362 (Dependabot all-minor-patch group, 15 updates): **needs-fixer (out of scope; pre-existing base failure, gated on PR #361)**.

Head SHA: `c0a38cde92e00324d3b86a5e113405e12ece8b10`. PR URL: https://github.com/endojs/endo-but-for-bots/pull/362. Base branch: `llm` at `b1c3f4dca97666b5dd975cc8640fe858a02be3a9`. mergeable=MERGEABLE, mergeStateStatus=UNSTABLE.

CI matrix on `c0a38cde9` (run https://github.com/endojs/endo-but-for-bots/actions/runs/26371350951):

- FAILURE: `lint` (single eslint error: `makeClient not found in '../src/client/index.js'  import/named` at `packages/ocapn/test/netlayer-tcp-syrup.test.js:7`)
- FAILURE: `test (20.x|22.x|24.x, ubuntu-latest|macos-15)` (6 jobs; `@endo/ocapn#test` exits 1, same underlying `netlayer-tcp-syrup.test.js` `makeClient` import resolution; layer tests also SIGINT-killed past the 5m mark but not the proximate cause)
- FAILURE: `cover (20.x|24.x, ubuntu-latest)` (2 jobs; same `@endo/ocapn#test` upstream)
- SUCCESS: everything else (build, browser-tests, zizmor, familiar-bundle, sandbox-drivers, test-async-hooks, test262 x2, test-hermes, check-action-pins, viable-release x2, test-xs, test-ocapn-python, build-wasm)

Root cause analysis. The failures are NOT introduced by the Dependabot bump. They are pre-existing on the `llm` base:

- `packages/ocapn/src/client/index.js` exports `makeOcapn` only (no `makeClient`).
- `packages/ocapn/test/netlayer-tcp-syrup.test.js:7` still imports `makeClient`, which lints as `import/named` error and breaks test resolution.
- The exact same failure pattern reproduces on **PR #357** (`chore(prettier): extend format to *.md files`) — a markdown-only PR with zero substance overlap — confirming the failure is base-branch state, not PR-side.
- **PR #361** (`fix(ocapn): port netlayer-tcp-syrup test from makeClient to makeOcapn`) is exactly the fix; on #361's CI run, the same `cover`, `test`, and the `import/named` lint error all go to SUCCESS. #361 still has its own lint and build failures (unrelated; not investigated here, that is #361's shepherd's problem).

Shepherd handling. This is **out of scope for the shepherd's surgical-fix bound** (the fix is a non-trivial test rewrite that already lives on a sibling PR awaiting merge; pulling that diff onto #362 would be the wrong shape). Per standing auto-chain rule, this would normally chain to fixer, but **the fix is already staged as PR #361**. The cheaper resolution is: land #361 first, then **rebase #362 on the new `llm` tip** (weaver dispatch, not fixer). No shepherd-surgical commits made; no push.

Botanist parallel-dispatch reminder per the dispatch prompt: shepherd verdict does not gate merge. Botanist must clear the dependency substance, and the maintainer-cleared embargo must be lifted, before the conductor.

Recommendation to orchestrator:
1. Merge PR #361 first (its own gauntlet permitting).
2. Then dispatch weaver on #362 to rebase onto updated `llm`; the lint and test failures resolve as a side-effect of the rebase incorporating #361's fix.
3. Re-shepherd #362 post-rebase.

Self-improvement: nothing this time. The pre-existing-base failure pattern (verify by checking an unrelated PR against the same base) is already documented in shepherd's *Operational-flake retirement* and `roles/shepherd/AGENT.md` *Take initiative*; the existing playbook handled this case cleanly.
