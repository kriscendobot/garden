---
job: 55a3e8
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-20T04:31:17Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 301
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs: []
preconditions: []
---

# Summary-fix bundle for endojs/endo-but-for-bots#301

Posted after the 2026-05-20 panel review on PR #301 (`feat(daemon,cli): error tracing aggregator and 'endo trace' verb`) terminated with no must-fix-loop dispositions.
The fixer claiming this job addresses each item below in a single dispatch and pushes one or more commits to the PR branch (`kriskowal-error-trace`).
Citations name the standing rule each item enforces; proposed-rule items are also recorded in the parallel `message: panel -> gardener` from this round.

## Items

- [ ] **No changeset for PR #301.**
  Add `.changeset/<slug>.md` enumerating the user-visible deltas: `@endo/marshal` gains the `marshalLoadError` option (minor), `@endo/captp` forwards both `marshalSaveError` / `marshalLoadError` hooks (minor), `@endo/daemon` adds `EndoHost.traces()` plus the `EndoTraces` and `EndoDaemonFacetForWorker.reportTrace` interfaces (minor).
  Bump level: minor across the three packages.
  Body: a one-paragraph description of the trace facility plus a pointer to `docs/error-tracing-design.md`.
  Land the changeset in its own commit per `skills/changeset-discipline/SKILL.md`.
  [rule: `skills/changeset-discipline/SKILL.md`]

- [ ] **Deduplicate `recordInboundErrorId` / `extractErrorId` / `ERROR_ID_PATTERN`.**
  Three near-identical copies exist today: `packages/cli/src/error-trace.js`, `packages/chat/error-trace.js`, and `extractInboundErrorId` in `packages/daemon/src/daemon.js`.
  They will drift; the daemon variant already has a different fallback shape (`err.errorId` property check).
  Recommended landing: one shared module the consumers import.
  Either a new tiny package (`@endo/error-trace-helpers`) or co-located in `packages/marshal/src/error-id.js` since the helpers are about the wire-format errorId.
  Update `cli/src/client.js`, `cli/src/error-trace.js`, `chat/connection.js`, `chat/error-trace.js`, and `daemon.js` to import from the new module.
  [rule: `skills/rename-discipline/SKILL.md` § identifier-pinning and single-source-of-truth]

- [ ] **Define a `DAEMON_WORKER_ID` constant** for the synthetic worker-id sentinel `'@daemon'`.
  Currently three string literals: `packages/daemon/src/daemon.js` line ~466 (the stub-record path), `packages/cli/src/error-trace.js` line ~121 / ~147 (fallback in formatted output), `packages/chat/error-trace.js` line ~100 / ~159 / ~182 (same fallbacks).
  Export from `packages/daemon/src/trace-aggregator.js` (or a sibling `trace-constants.js`).
  The same treatment is recommended for the `@network:${hostId}` prefix used in `host.js`: expose as a single helper (`networkWorkerId(hostId)`) imported by `host.js` and any test exercising the network code path.
  [proposed-rule: synthetic worker-id sentinels should be defined once and imported]

- [ ] **Replace the `-- emitted from --` separator in `worker.js`** with a plain "from emission site:" label so the joined string lands legibly in the trace's `stack` field at runtime.
  Same for the Unicode arrow inside the surrounding comment ("compartment → marshal → CapTP → daemon"): rewrite as "compartment to marshal to CapTP to daemon" so the prose-style rule applies uniformly.
  [rule: `skills/em-dash-style/SKILL.md`]

## Branch / push instructions

The fixer claims this job, opens a project worktree at `kriskowal-error-trace` (per `journal/projects/endo-but-for-bots/README.md`), addresses each item with one or two commits per concern (the changeset and the dedup belong in separate commits per `skills/changeset-discipline/SKILL.md`), and pushes with `git push origin HEAD:kriskowal-error-trace`.
After CI converges green, the fixer optionally posts a top-level summary comment listing the addressing SHAs; that comment is per-action-authorized in the dispatch fire prompt.

## Refs

- Panel review: https://github.com/endojs/endo-but-for-bots/pull/301#pullrequestreview submission at 2026-05-20T04:29:45Z (judge's `gh pr review --comment` from this round)
- Cleaner result: `entries/2026/05/20/040700Z-result-cleaner-a509cb.md`
- Design doc the PR implements: `docs/error-tracing-design.md`

completed_at: 2026-05-20T04:53:42Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commits: 29eddc179,97801b2cd,bbe8f2821,f0109e20d,7be08f41b
