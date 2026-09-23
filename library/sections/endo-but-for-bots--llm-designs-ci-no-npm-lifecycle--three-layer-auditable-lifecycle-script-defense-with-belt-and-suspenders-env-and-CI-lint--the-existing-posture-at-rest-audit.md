---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §existing-posture-at-rest audit
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

The most structurally interesting *audit* move:

> *The repository already takes the right position at rest.
> `.yarnrc.yml` sets `enableScripts: false` globally; the
> legacy `.yarnrc` sets `ignore-scripts true`; the root
> `package.json` pins `@lavamoat/preinstall-always-fail` and
> `@lavamoat/allow-scripts` with a narrow allowlist
> (`@ipshipyard/node-datachannel`, `better-sqlite3`) for the
> two native addons that genuinely need to build during
> install. This design pins that posture down in CI and adds
> enforcement so the posture cannot regress silently.*

The §pin-the-posture-don't-invent-it framing: the repo's
local-development setup *already* has the right policy. The
design's job is to *extend that policy to CI* (where it
matters most) and to *add enforcement* (so a future
maintainer can't accidentally regress).

The §light-migration property: most workflows already do the
right thing; the design adds a thin enforcement layer. Same
shape as cycle 151's §verified-current-state methodology
(audit-before-spec) applied to *security policy* rather than
*feature coverage*.
