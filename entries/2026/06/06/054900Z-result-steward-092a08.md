---
ts: 2026-06-06T05:49:00Z
kind: result
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - entries/2026/06/06/050800Z-dispatch-researcher-ec33c4.md
  - entries/2026/06/06/051300Z-result-researcher-ec33c4.md
  - entries/2026/06/06/051500Z-dispatch-builder-d94d05.md
  - entries/2026/06/06/052513Z-result-builder-101dc2.md
  - entries/2026/06/06/054300Z-dispatch-shepherd-092a08.md
  - entries/2026/06/06/054752Z-result-shepherd-092a08.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4637577349
---

# result: steward — master-into-llm chain returned; PR #426 escalates to liaison

User directive (*"dispatch a subagent to merge actual/master into
bots/llm for a PR to merge the branches, then shepherd that PR
through CI"*) ran researcher → builder → shepherd cleanly. The
shepherd's verdict is `next: liaison`: 5 of 25 CI checks fail with
a single root cause that the builder pre-flagged as out-of-scope
drift, and per the dispatch brief's explicit policy the shepherd
declined to push a fix.

## Chain summary

- **Researcher** `ec33c4`: produced the `## Library and project
  references` section inlined into the builder's brief; surfaced
  three prior precedents (2026-05-15 PR #257, 2026-05-21 direct push,
  2026-06-03 direct push) establishing the merge-not-rebase shape and
  the recurring conflict surface.
- **Builder** `d94d05`/`101dc2`: opened PR #426
  (`chore: merge actual/master into llm (2026-06-06)`) DRAFT, base
  `llm` (`2bd9e0c`), head `merge/actual-master-into-llm-20260606`
  (`6180467`). Absorbed upstream tip `4a04d078` with 9 file-level
  conflict resolutions and surfaced 2 out-of-scope drifts.
- **Shepherd** `092a08`: watched 25 CI checks; classified the 5
  failures (lint + 4 test-matrix) as a single-root-cause CI-fixable
  that the builder had pre-flagged. Per the dispatch brief's
  explicit policy (`do NOT fix; escalate to liaison`), declined to
  push and verdicted `next: liaison`.

## Escalation — needs maintainer decision

**Root cause**: the merge brought in master's new `unicorn/numeric-
separators-style` ESLint rule wired via `@endo/eslint-plugin`'s peer
dependency, but the bot fork's root `package.json` does not provide
`eslint-plugin-unicorn` as a devDependency. The 9p-server ESLint
config's `plugin:@endo/internal` extends fail to resolve. Turbo
cascades the abort so the test matrix never reaches its substance.

**Cheap fix** (one-line): add `"eslint-plugin-unicorn": "^X"` to root
`package.json` devDeps. The substance is master's lint discipline
being pulled forward; bot llm just needs to provide the dep.

**The other builder-flagged drift** (`makeClient`/`registerNetlayer`
API divergence surfacing in `netlayer-tcp-syrup.test.js`) is masked
by the unicorn failure — turbo aborts before reaching
`packages/ocapn`. It will likely surface as a separate CI failure
once the unicorn gap is closed.

**Shepherd's PR-#426 summary comment**:
<https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4637577349>

## Adjacent: PR #75 shepherd still in-flight (dispatch `58522c`)

Snapshot at this entry's time:
`head=c9af7e2 in_progress=2 success=15 failing=0`. The third fix
push appears to have addressed lint; convergence awaits the two in-
progress jobs.

## Steward action this entry

- Dispatch root `/home/kris/dispatches/shepherd--092a08` torn down.
- Shepherd `58522c` dispatch root for PR #75 still in place (the
  shepherd is self-paced via its own `ScheduleWakeup` and will write
  its final `result` on convergence; the steward does not tear down
  until that lands).
- Escalation surfaced to the user-in-the-loop in the same terminal
  turn that this entry was written; if the user is unreachable, this
  entry serves as the deferred record per the
  `Awaits maintainer decision` shape.

Self-improvement: nothing this time.
