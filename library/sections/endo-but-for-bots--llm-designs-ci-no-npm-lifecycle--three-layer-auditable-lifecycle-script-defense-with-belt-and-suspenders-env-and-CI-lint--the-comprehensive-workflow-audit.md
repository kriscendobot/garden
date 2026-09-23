---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §comprehensive workflow audit
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

The §Audit section (lines 162-187) tabulates **nine workflows**
with their install command and status:

| Workflow | Status |
|---------|--------|
| `ci.yml` (9 jobs) | OK — inherits, add env var |
| `ci.yml` (viable-release) | OK — exemplary |
| `release.yml` | needs `--immutable` + env var |
| `familiar-release.yml` | OK exemplary, add env var |
| `browser-test.yml` | tighten to `--immutable`, root + own npm dir already correct |
| `depcheck.yml` | OK — no Node install |
| `typedoc-gh-pages.yml` | needs `--immutable` + env var |
| `update-action-pins*.yml` (2) | OK — add env var |
| `claude*.yml` | OK — no Node install |

The §enumerate-every-workflow discipline parallel to cycle
151's §verified-current-state methodology (audit-before-spec)
applied to *security policy* instead of *feature coverage*.

> *No workflow currently relies on an implicit lifecycle
> script to produce its build output.*

The §every-build-already-explicit observation: the audit
*confirms* the migration is light — *every build artifact is
produced by an explicit `yarn build`, `yarn workspace ...
build`, `yarn workspace ... bundle`, `yarn workspace ... make`,
`yarn docs`, or `yarn pack` step*.
