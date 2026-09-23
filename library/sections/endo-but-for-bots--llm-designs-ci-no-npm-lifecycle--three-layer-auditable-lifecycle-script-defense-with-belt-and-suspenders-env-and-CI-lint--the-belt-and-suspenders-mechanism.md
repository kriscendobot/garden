---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §belt-and-suspenders mechanism
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

§Design Decision 2:

> *`.yarnrc.yml` already sets `enableScripts: false`, so in
> principle the env var is redundant. CI sets it anyway
> because the env var survives deletions of `.yarnrc.yml` on
> branches, survives invocations of `npm` from a script that
> expected `yarn`, and shows up in the workflow file where a
> reviewer will read it.*

The §belt-and-suspenders-against-package-manager-confusion
discipline. Three concrete failure modes the env var defends
against:

1. **`.yarnrc.yml` deleted on a feature branch** — config
   missing, env var still wins.
2. **A script invokes `npm` when the workflow author expected
   `yarn`** — the env var name covers both (`YARN_ENABLE_SCRIPTS`
   *and* `npm_config_ignore_scripts`).
3. **Reviewer-visible** — the env var appears in the workflow
   YAML; the config file's setting does not. A code reviewer
   reading a PR diff to the workflow *sees* the security
   posture inline.

The §reviewer-visible-defense observation: defense-in-depth is
not just about resilience to attacks; it's also about *making
the defense visible to humans reading the code*. A config
buried in `.yarnrc.yml` is invisible at the workflow file's
diff-review moment; the inline env block is visible.
