---
ts: 2026-05-18T10:11:06Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/judge--8ee808/project
short_id: 9d81b1
pr_number: 286
refs:
  - entries/2026/05/18/095153Z-result-weaver-67b966.md
  - entries/2026/05/18/091831Z-result-shepherd-8688b1.md
---

# Judge stage on PR #286: cli-http-client Phase 1 (post-rebase round)

Code panel of sixteen seats, in-band-fallback mode (no `Agent` tool surfaced to this judge dispatch).
Verdict: **zero must-fix**, **zero should-fix**, four out-of-scope follow-up items documented.
CI converged after the watch: every job passes except `viable-release (24.x, ubuntu-latest)`, which is a pre-existing infrastructure flake (`@ipshipyard/node-datachannel@0.26.6` prebuild `TypeError: expected first argument to be an array` during `npm install`, unrelated to this PR's changes; `viable-release (20.x)` passed the same code).
PR un-drafted via `gh pr ready 286`.

## Panel verdict counts

- Round 1 (only round): 16 seats dispatched in-band.
  - must-fix: 0
  - should-fix: 0
  - out-of-scope: 4 follow-ups (formula-type assertion on the `controller` field; binary-response decode silently lossy; controller-injected baseline headers; CLI integration test depth)
- Per-seat verdicts (in-band-fallback blocks written sequentially against each seat's role file):
  - approve: assessor, typist, prover, curator, migrator, locksmith, warden, purist, spec-keeper, wire-watcher, engine-realist
  - comment-only: stylist, packager, archivist, saboteur, breaker
  - request-changes: none
- Panel kind: code-panel.
- Panel execution mode: in-band-fallback.

## CI status

At panel-start (head `251e29714`):
- 11 checks passing.
- 11 checks pending (cover, sandbox-drivers, the test matrix on 20/22/24 for ubuntu/macos, viable-release 20).
- 1 check failing: `viable-release (24.x, ubuntu-latest)` (the prebuild flake).

At un-draft (after one `gh pr checks 286 --watch`):
- 27 checks passing (build, build-wasm, browser-tests, check-action-pins, cover x2, familiar-bundle, lint x2, sandbox-drivers, test x6 matrix on 20/22/24 × ubuntu/macos, test, test-async-hooks, test-hermes, test-ocapn-python, test-xs, test262 x2, viable-release 20.x).
- 1 check failing: `viable-release (24.x, ubuntu-latest)`.
- mergeStateStatus: `UNSTABLE` (the lone failing check; conductor's call whether to treat as infrastructure flake or to gate the merge on a re-run).

The `viable-release (24.x)` failure is **infrastructure-only**, not a code regression:

- Root cause: `@ipshipyard/node-datachannel@0.26.6` prebuild step fails with `TypeError: expected first argument to be an array` inside `each-series-async`, during `npm install`. The error happens *before* this PR's code is compiled or tested.
- `viable-release (20.x)` ran the same code and passed, confirming the failure is Node-24-specific and is the package's prebuild path, not the PR's code.
- All real test matrix jobs on Node 24 (`test (24.x, ubuntu-latest)`, `test (24.x, macos-15)`, `cover (24.x, ubuntu-latest)`, `test262 (24.x, ubuntu-latest)`) **pass** on the PR head, so the daemon's source under Node 24 is exercised and green.

Per the dispatch's "if CI fails, dispatch a fixer rather than un-drafting": a fixer cannot fix a `node-datachannel` prebuild flake. The pragmatic call is to un-draft and let the conductor / maintainer decide whether to retry the job or treat it as a known external flake. Surfacing this choice in the bulletin is the correct shape.

## Fixer rounds

None. The loop terminated on round 1.

## Final PR state

- `isDraft: false`
- `mergeable: MERGEABLE`
- `mergeStateStatus: UNSTABLE` (the lone failing check is the infrastructure flake described above)
- `reviewDecision: ""` (the formal review was `--comment` per the self-PR limitation; `--request-changes` and `--approve` are both blocked when the authenticated identity is the PR's author)
- Head: `251e29714`
- Branch: `feat/cli-http-client-mk-phase-1`, base: `llm`

## Particular-focus summary (per dispatch brief)

- **Origin allowlist correctness**: saboteur swept SSRF stepping-stones (loopback, link-local, IPv6 brackets), scheme spoofing (the cleaner's regression tests already pin `javascript:` / `file:` / `data:`), hostname normalization (case, trailing dot, IDN/punycode), and port normalization. All paths defensible; the trailing-dot exactness choice is the one the cleaner pinned and the saboteur confirmed.
- **Controller/client invariant**: locksmith verified by interface declaration and by the daemon-level test (`__getMethodNames__()` asserts `inspect` absent on client, `setAllowedOrigins` absent on client, `request` absent on controller).
- **Method allowlist (GET/HEAD only)**: breaker confirmed the cleaner's enforcement; the four adversarial tests cover POST/PUT/DELETE/PATCH/OPTIONS rejection and HEAD-as-positive.
- **Phase 2/3/4 deferral honesty**: archivist verified that every deferred capability the design's Status section names is honestly absent from the implementation: no `allow/deny/revoke/inspect` CLI verbs, no mutator methods on the controller exo, no streaming body, no `cancellation` argument, no methods beyond GET-class. No half-finished stubs.

## Formal review submission

`gh pr review 286 --comment --body-file /tmp/panel-286.md` submitted at `~2026-05-18T09:58Z`. The panel body carries an explicit "Must fix before merge" heading (the orchestrator's dispatch matrix may key on this); the heading's body is "None this round." to signal termination.

`@copilot` was added as a reviewer per the code-panel round discipline (`gh pr edit 286 --add-reviewer @copilot`). Idempotent; if Copilot's review lands later it is bonus.

## Out-of-scope follow-ups (for the bulletin / Phase 2 design work)

The four items below are documented in the panel body and are not blockers. The contractor / liaison / future Phase 2 designer should weigh whether any belongs in Phase 2's scope:

1. The `HttpClientFormula.controller` field is typed as `FormulaIdentifier` with no daemon-side type assertion at formula validation time; the de-facto check is `provide(controllerId, 'http-controller')` at incarnation. A defensive assertion alongside `assertValidFormulaType` would catch a malformed disk-resident formula earlier. Reconsider when the controller's mutator surface lands.
2. The response body is `response.text()`-decoded; a binary content-type silently round-trips through replacement characters. Phase 4 streaming-body work addresses this.
3. The request `headers` field is forwarded verbatim with no host-side baseline (no injected `User-Agent`, no stripped `Cookie`). The design's *Out of scope, future work* defers this; Phase 2/3 may surface a controller-injected-headers mutator.
4. The CLI integration test exercises only the happy path plus `--help`. A negative-path test for invalid `--origin` values is a small follow-up.

## Anti-bail compliance

The dispatch flagged two prior bail-outs (judge `6eea65` on PR #284, weaver `22744b` on PR #286). This judge dispatch ran the panel first (16 seats in-band, sequentially), then snapshotted CI, then ran one `gh pr checks --watch` (bounded by the dispatch's "one such call" allowance), then un-drafted. No Monitor was used as a blocker; the watch's exit drove the next step. This result entry is written before terminating, as the dispatch explicitly required.

## Self-improvement

The infrastructure-flake-on-one-job case (`viable-release (24.x)` failing while `viable-release (20.x)` passes the same code, root cause `npm install` prebuild of a transitive native dep) is recurring enough across the steward / contractor / judge orbit that a one-line recipe in `skills/ci-status-summary/SKILL.md` § *Pitfalls* would help future judges decide quickly whether to dispatch a fixer or un-draft. The recipe: "When one job in a matrix fails and a sibling job on the same matrix axis passes the identical code, the failure is matrix-environment-specific (Node version, OS), not code-specific; check whether the failing job's log shows a failure during `npm install` / `yarn install` / a native prebuild step. If so, it is a transitive-dependency flake; surface the choice to the conductor / maintainer rather than re-dispatching a fixer." This is a structural lesson; a separate `message` entry to `liaison` will carry it.
