---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--15d368
ts: 2026-06-03T11:56:49Z
ref_id: 15d368
---

# Cycle 153 result — ci-no-npm-lifecycle.md (thirty-eighth-comment-style design ingest)

Cycle 153 of the librarian arc. Nominally papers-lane (cycle 152 was
comments); papers-lane has been blocked for **47+ consecutive
cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/ci-no-npm-lifecycle.md` — 378-line
*Complete* status CI-supply-chain-defense design by Kris Kowal
*(prompted)*. Shipped 2026-05-14 via PR #126 commit `ddbc8ad7e`.
Master-base mirror staged upstream as PR #250. **16-day calendar
window** (2026-04-29 → 2026-05-14) of which most was queue/review
wait, not active authoring.

## Structural moves captured

- **§Load-bearing-threat-model**: GitHub Actions runner holds *write
  access to the workspace + read access to any secret the job
  mounted*. A malicious `postinstall` in any transitive dependency
  runs with all of those privileges *before any source is audited*.
  §the-runner-is-the-attack-surface + §lifecycle-scripts-run-before-
  source-audit observation. §Supply-chain-attacks-cited: event-
  stream / ua-parser-js / node-ipc / 2024 XZ-style typosquatting.

- **§Three-concerns** enumeration: supply-chain risk + reproducibility
  + correctness. §multiple-independent-justifications discipline.

- **§Existing-posture-at-rest audit**: `.yarnrc.yml` `enableScripts:
  false` + `@lavamoat/allow-scripts` allowlist (`@ipshipyard/node-
  datachannel`, `better-sqlite3`) already in place. §pin-the-posture-
  don't-invent-it framing.

- **Single most structurally interesting move**: §three-layer-
  auditable defense (Design Decision 1) — (1) Config (`.yarnrc.yml`);
  (2) Allowlist (`@lavamoat/allow-scripts`); (3) Named step (`yarn
  allow-scripts run` in CI). §each-layer-can-fail-without-
  catastrophic-loss + §defense-in-depth-against-three-different-
  mistakes.

- **§Belt-and-suspenders mechanism**: `YARN_ENABLE_SCRIPTS=false` +
  `npm_config_ignore_scripts=true` in job env. §reviewer-visible-
  defense observation — *defense-in-depth is also about visibility
  to humans reading the code*.

- **§Explicit-named-step principle**: §observability-through-
  explicitness via workflow-file enumerate + Actions-log enumerate
  + step-named-failure-pointer.

- **§Two-layer enforcement**: (1) repo-level lint
  `check-no-ci-lifecycle.mjs`; (2) positive tripwire via
  `@lavamoat/preinstall-always-fail`. §canary-package-fails-loud.

- **§Workspace-prepack handling**: §don't-rename-don't-touch-
  existing-mechanisms-just-control-call-sites. §control-the-call-
  not-the-callee distinction.

- **§Five Design Decisions** codify choices: three-layer auditability
  / belt-and-suspenders / `yarn install --immutable` for §lockfile-
  immutability-as-supply-chain-defense / no forbid-prepack / browser-
  test uses npm correctly.

- **§16-day calendar window** calibration via `git blame`:
  §design-burst-then-queue-wait (1 design commit + 1 impl squash-
  merge). §calendar-time-vs-active-time distinction. §batch-of-
  seven-proposals on same day implies parallel design burst.

- **§Self-contained-design property**: *Dependencies: None* +
  §self-contained-by-construction.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-ci-no-npm-lifecycle`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint.md`
- **Topics**: tooling, repository-governance, security-disclosure
- **Library totals**: 657 sections from 198 source documents
- **Lane rotation**: nominally papers-lane (47+ consecutive blocks);
  pivoted to designs-lane

Cycle 153 closes. Schedule next wake 1500s for cycle 154.
