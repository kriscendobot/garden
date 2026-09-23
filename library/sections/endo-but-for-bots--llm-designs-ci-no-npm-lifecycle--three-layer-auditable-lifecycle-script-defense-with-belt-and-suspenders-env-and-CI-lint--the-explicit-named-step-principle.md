---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §explicit-named-step principle
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

§Principle:

> *Any work that a lifecycle script would do is moved into
> an explicit, named workflow step that a reviewer can see in
> the workflow file and in the Actions log.*

The §explicit-named-step-not-implicit-side-effect discipline.
Three observable consequences:

1. **The workflow file enumerates what runs**: read the YAML;
   you see every step.
2. **The Actions log enumerates what ran**: read the timeline;
   you see every step's runtime + output.
3. **Failures point to the responsible step**: a build break
   names the failing step, not "something during install".

The §observability-through-explicitness move. Implicit
side-effects (lifecycle scripts) are *invisible* in both
review and runtime; explicit steps are *visible* in both.

§Three things to notice about the example workflow (lines
122-134):

1. `yarn install --immutable` with scripts disabled by both
   config and env var.
2. Two allowlisted native addons rebuilt in a named step via
   `yarn allow-scripts run`.
3. Build artifacts come from explicit `yarn build` — never
   from implicit `prepack` side effect.
