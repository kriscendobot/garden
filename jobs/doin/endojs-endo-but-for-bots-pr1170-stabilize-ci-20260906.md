---
role: fixer
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=urgent at=2026-09-06T22:04:03Z cleared=none -->

---
role: fixer
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Stabilize PR #1170's unrelated cold-CI failures

Repository: `endojs/endo-but-for-bots`
PR: https://github.com/endojs/endo-but-for-bots/pull/1170
Head branch: `dependabot/npm_and_yarn/all-minor-patch-c170e989f4`
Expected reviewed head on entry: `4b1fd86209490fc0e11f4509d93911efb117dc26`

This is the first stage of the serial orchestration
`endojs-endo-but-for-bots-pr1170-ci-disposition`. Diagnose and, if justified,
repair the reproducible CI failures that block this already-reviewed Dependabot
PR. Use an isolated project worktree keyed by this child job. Preserve the
reviewed dependency versions and do not widen any semver range or lockfile
resolution beyond PR #1170's reviewed target set.

Observed evidence on the correct rebased head:

- CI run https://github.com/endojs/endo-but-for-bots/actions/runs/34059902282
  repeatedly fails Ubuntu 22/24 in
  `packages/space-nixos-admin/test/deploy-performer.test.js`, especially the
  wall-clock `watch inherits deadline` assertion (about 2.2s elapsed against a
  1.3s upper bound), followed by cleanup/lock timeouts. This package consumes no
  moved dependency from PR #1170. The broad grouped lockfile change causes a
  cold affected set and unusually high runner load.
- The same run intermittently stalls/fails macOS in timing-sensitive
  `packages/codex-sandbox/test/codex-client.test.js`; that package likewise
  consumes no moved dependency. macOS 24 passed on the latest attempt.
- Guile run https://github.com/endojs/endo-but-for-bots/actions/runs/34059902254
  exhausts six retries on `ftpmirror.gnu.org` HTTP 502 or timeout while fetching
  Guix, before any project test runs.
- All other checks are green. Multiple failed-job reruns reproduced these
  environmental/timing failures.

Determine the smallest maintainable fix (test deadline/load robustness and/or
mirror download resilience), test it proportionately, commit it explicitly,
and push it to the PR head with a compare-and-swap/force-with-lease discipline.
If the failures cannot responsibly be fixed in this PR, document the exact
blocker and finish with the orchestration-failure signal so the campaign halts
instead of advancing under false confidence.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-06T22:04:18Z
