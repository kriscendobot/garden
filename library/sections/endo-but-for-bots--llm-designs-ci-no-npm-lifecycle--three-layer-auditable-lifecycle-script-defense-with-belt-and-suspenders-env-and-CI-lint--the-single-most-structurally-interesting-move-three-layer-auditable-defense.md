---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §single most structurally interesting move — §three-layer auditable defense
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

§Design Decision 1 names the architecture:

> *Disable globally, opt in per package, run in a named step.*
> *The combination of `enableScripts: false` (repo-wide), an
> explicit `@lavamoat/allow-scripts` allowlist (per package),
> and a named `yarn allow-scripts run` step (per workflow)
> means any native-addon build is auditable at three layers:
> the config, the allowlist, and the Actions log line.*

The §three-layer-auditability discipline:

| Layer | Mechanism | Audit point |
|-------|-----------|-------------|
| **Config** | `.yarnrc.yml` `enableScripts: false` | Repo-wide default — no script runs unless explicitly invoked |
| **Allowlist** | `@lavamoat/allow-scripts` + `dependenciesMeta.built` | Per-package whitelist — only listed packages can build |
| **Named step** | `yarn allow-scripts run` in CI | Per-workflow visibility — the build step is a *named line* in the Actions log |

The §each-layer-can-fail-without-catastrophic-loss property:
if the config is mistakenly removed, the allowlist still
gates which packages can run scripts; if the allowlist is
mistakenly widened, the named-step is still required to
trigger the build (and reviewers see the step in the
workflow file).

The §defense-in-depth-against-three-different-mistakes
shape: each layer protects against a *different* class of
error (accidental config deletion / accidental allowlist
expansion / accidental implicit-script-invocation). One
mistake doesn't compromise the whole posture.
