---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Flaky `test (22.x, macos-15)` CI leg: daemon teardown race unrelated to the PRs that trip it

Repo: `endojs/endo-but-for-bots`. Seen at least twice this week on unrelated
PRs in the `ebfb-sturdyref-*` layer stack (layer 1, `#774`, and layer 2,
`#1391`) — neither touches `@endo/daemon`, both root-level changes
(`tsconfig.composite.json`, `yarn.lock`) put the whole monorepo in CI's
affected set, and both runs failed inside `@endo/daemon`'s test suite in
different ways:

- Layer 1 / `#774`: `daemon-teardown › an orphaned daemon shuts itself down
  instead of lingering` failed on one run, then a different
  `test/endo.test.js` non-zero exit on a re-run.
- Layer 2 / `#1391`: `test/endo.test.js` — unhandled `Error: Termination
  requested`, reading as a race during daemon shutdown.

## Task

Find and fix the actual race in `@endo/daemon`'s teardown path on the
`macos-15` / Node 22 CI leg (it may not reproduce on Linux legs, which is
consistent with a real timing race rather than a logic bug — check other CI
legs' pass history for this same suite to confirm it's macOS/Node-22-
specific before concluding that). This is costing real gauntlet cycles
across multiple unrelated PRs whose own diffs never touch this code. If the
fix isn't quickly findable, at minimum make the flake diagnosable (better
error capture around the shutdown path) and consider whether this specific
suite should be excluded from the "whole monorepo" affected-set trigger for
root-config-only changes, so an unrelated PR stops inheriting this flake's
risk.
