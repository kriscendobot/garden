---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §workspace-prepack scripts — §don't-rename-just-control-call-sites
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

The §Workspace `prepack` scripts subsection addresses an
obvious objection: *many packages have `prepack` scripts;
should those be removed?*

> *These are invoked deliberately by `yarn lerna run prepack`
> in the `viable-release` job and by humans running `yarn
> pack`. They are not invoked implicitly during `yarn install`
> because the repo is configured with `enableScripts: false`.
> This design does not require renaming them; it requires
> only that CI never calls them through a bare `yarn install`.*

The §don't-rename-don't-touch-existing-mechanisms-just-control-call-sites
discipline. The property the design wants is *invisibility at
install time*, not *non-existence*. The existing `prepack`
hooks remain (they're useful for type-def builds at pack
time); the design just ensures `yarn install` doesn't trigger
them.

§Design Decision 4 makes this explicit:

> *No attempt to forbid `prepack` in workspace `package.json`s.
> `prepack` is the correct hook for building typedefs before
> pack, and it runs under human control (via `yarn pack` or
> `yarn lerna run prepack`) as an explicit workflow step.*

The §control-the-call-not-the-callee distinction: the design
controls *when* lifecycle scripts run, not *which* lifecycle
scripts exist.
