---
source: designs/ci-no-npm-lifecycle.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 57c1e09746ab002f51fac844292562625ac59678
source_date: 2026-05-18
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-eighth-comment-style design ingest (cycle 153). 378-
  line *Complete* status CI-supply-chain-defense design by
  Kris Kowal *(prompted)*, shipped 2026-05-14 via PR #126
  commit `ddbc8ad7e`. Created 2026-04-23; design-phase
  commit `102a94bc9` 2026-04-29 in a *batch of seven
  proposals*; impl-phase squash-merge 2026-05-14. **16-day
  calendar window** of which most was queue/review wait, not
  active authoring (the §calendar-time-vs-active-time
  distinction).

  §Load-bearing-threat-model: GitHub Actions runners hold
  *write access to the workspace + read access to any secret
  the job mounted*. A malicious `postinstall` in any
  transitive dependency runs with all of those privileges
  *before any source is audited*. §the-runner-is-the-attack-
  surface. §Lifecycle-scripts-run-before-source-audit
  observation. §Supply-chain-attacks-cited: event-stream /
  ua-parser-js / node-ipc / 2024 XZ-style typosquatting.

  §Three-concerns enumeration: supply-chain risk /
  reproducibility / correctness. §Multiple-independent-
  justifications discipline — *even if security were zero,
  reproducibility and correctness alone justify the design*.

  §Existing-posture-at-rest audit names what's already in
  place: `.yarnrc.yml` `enableScripts: false` + legacy
  `.yarnrc` `ignore-scripts true` + `@lavamoat/preinstall-
  always-fail` + `@lavamoat/allow-scripts` with narrow
  allowlist (`@ipshipyard/node-datachannel`, `better-sqlite3`).
  §Pin-the-posture-don't-invent-it framing. §Light-migration
  property. Same shape as cycle 151's §verified-current-state
  methodology applied to *security policy*.

  Single most structurally interesting move: §three-layer-
  auditable defense (Design Decision 1). Three audit points:
  (1) **Config** (`.yarnrc.yml` `enableScripts: false`, repo-
  wide); (2) **Allowlist** (`@lavamoat/allow-scripts` + per-
  package `dependenciesMeta.built`); (3) **Named step**
  (`yarn allow-scripts run` in CI). §Each-layer-can-fail-
  without-catastrophic-loss + §defense-in-depth-against-three-
  different-mistakes.

  §Belt-and-suspenders mechanism (Design Decision 2): both
  `YARN_ENABLE_SCRIPTS=false` AND `npm_config_ignore_scripts=
  true` in job env blocks. Defends against three concrete
  failure modes: `.yarnrc.yml` deleted on branch / script
  invokes `npm` instead of `yarn` / reviewer needs to *see*
  the security posture inline (not buried in config).
  §Reviewer-visible-defense observation: defense-in-depth is
  also about *visibility to humans reading the code*.

  §Explicit-named-step-not-implicit-side-effect principle.
  Three observable consequences: workflow file enumerates;
  Actions log enumerates; failures point to the responsible
  step. §Observability-through-explicitness.

  §Native-addons exception via §`@lavamoat/allow-scripts` —
  §narrow-allowlist-for-legitimate-exceptions discipline.
  §Named-list-not-pattern-match — new malicious packages
  can't masquerade.

  §Comprehensive workflow audit tabulates **nine workflows**
  with install command + status. §Enumerate-every-workflow
  discipline (parallel to cycle 151). §Every-build-already-
  explicit observation — *No workflow currently relies on an
  implicit lifecycle script*.

  §Workspace-prepack scripts handling: §don't-rename-don't-
  touch-existing-mechanisms-just-control-call-sites. Existing
  `prepack` hooks remain (useful at pack time); design just
  ensures `yarn install` doesn't trigger them. §Control-the-
  call-not-the-callee distinction.

  §Two-layer enforcement: (1) repo-level lint
  `check-no-ci-lifecycle.mjs` scans workflows + fails on
  policy violations; runs as gated CI job (parallel to
  existing `check-action-pins`); (2) positive tripwire via
  `@lavamoat/preinstall-always-fail` — §canary-package-fails-
  loud discipline; catches the regression at install time
  even if lint missed. Both fail loud at *different* phases
  of the lifecycle.

  §Five Design Decisions codify the structural choices:
  three-layer auditability / belt-and-suspenders / `yarn
  install --immutable` for lockfile-immutability-as-supply-
  chain-defense / no attempt to forbid prepack / browser-test
  directory uses npm (don't fix what isn't broken).

  §16-day calendar window calibration via `git blame`:
  §design-burst-then-queue-wait — 2026-04-29 design + 2026-
  05-14 implementation; *14 days of waiting is the queue
  characteristic of the project*. §Batch-of-seven-proposals
  on the same day implies parallel design burst (smaller
  Aaron equivalent in cycles 143+151).

  §Self-contained-design property: §Dependencies: None — *no
  other design must land first*. §Self-contained-by-
  construction is rare.

  Cycle 153 was nominally papers-lane (cycle 152 was
  comments). Papers-lane has been blocked for 47+ consecutive
  cycles. Cycle 153 pivoted to designs-lane.
---

> Abstract: `ci-no-npm-lifecycle.md` (378 lines, *Complete*;
> shipped 2026-05-14 via PR #126) is a CI-supply-chain-defense
> design by Kris Kowal *(prompted)*. Created 2026-04-23;
> design-phase 2026-04-29 in a *batch of seven proposals*;
> impl 2026-05-14. **16-day calendar window** mostly queue-
> wait.
>
> §Load-bearing-threat-model: GitHub Actions runner holds
> write access + secret access; malicious postinstall in any
> transitive dep runs *before any source is audited*. Supply-
> chain attacks cited: event-stream / ua-parser-js / node-ipc
> / 2024 XZ typosquatting.
>
> §Three-concerns: supply-chain risk + reproducibility +
> correctness. §Multiple-independent-justifications.
>
> §Existing-posture-at-rest audit: `.yarnrc.yml` `enableScripts:
> false` + lavamoat allowlist already in place. §Pin-the-
> posture-don't-invent-it framing.
>
> **Single most structurally interesting move**: §three-layer-
> auditable defense (Design Decision 1) — Config + Allowlist
> + Named-step. §Each-layer-can-fail-without-catastrophic-
> loss; §defense-in-depth-against-three-different-mistakes.
>
> §Belt-and-suspenders env mechanism (`YARN_ENABLE_SCRIPTS`
> *and* `npm_config_ignore_scripts`). §Reviewer-visible-
> defense — defense-in-depth is also about *visibility to
> humans*.
>
> §Explicit-named-step principle. §Observability-through-
> explicitness.
>
> §Two-layer enforcement: repo-level lint + positive tripwire
> via `@lavamoat/preinstall-always-fail`. §Canary-package-
> fails-loud discipline.
>
> §Workspace-prepack: §don't-rename-don't-touch-existing-
> mechanisms-just-control-call-sites. §Control-the-call-not-
> the-callee.
>
> §Five Design Decisions codify choices. §Self-contained-by-
> construction (Dependencies: None).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint](../sections/endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint.md) | tooling, repository-governance, security-disclosure | current |

Tight 378-line *Complete* design. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  57c1e0974` (branch `origin/llm`) via the local bare-clone.
- Created 2026-04-23 / updated 2026-05-18 / status *Complete*.
  Author Kris Kowal *(prompted)*.
- Shipped 2026-05-14 via PR
  [#126](https://github.com/endojs/endo-but-for-bots/pull/126)
  commit `ddbc8ad7e`. A master-base mirror staged upstream as
  PR #250.
- Last touch commit `57c1e0974` 2026-05-20 by endolinbot:
  `docs(designs): ci-no-npm-lifecycle roadmap calibration
  (16-day calendar; 1 design + 1 impl burst)`.
- **Thirty-eighth-comment-style design ingest.**
- Cycle 153 was nominally **papers-lane** (cycle 152 was
  comments). Papers-lane has been blocked for **47+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure. Cycle 153 pivoted to designs-lane.
- One cohesion-honest section.
