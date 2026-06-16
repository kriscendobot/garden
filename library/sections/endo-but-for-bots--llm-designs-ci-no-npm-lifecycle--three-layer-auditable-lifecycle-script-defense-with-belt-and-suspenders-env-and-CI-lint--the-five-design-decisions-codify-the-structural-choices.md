---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §five Design Decisions codify the structural choices
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

§Design Decisions:

1. **Disable globally, opt in per package, run in a named
   step** — §three-layer-auditability.
2. **Belt and suspenders on env vars in CI** — §reviewer-
   visible-defense + §survives-config-deletion.
3. **Prefer `yarn install --immutable` over bare `yarn`** —
   *`--immutable` additionally prevents the install from
   mutating the lockfile, which closes off another vector for
   a malicious PR to change what gets resolved*. §lockfile-
   immutability-as-supply-chain-defense.
4. **No attempt to forbid `prepack` in workspace package.json**
   — §control-the-call-not-the-callee.
5. **The `browser-test/` directory uses npm, not yarn** —
   *don't fix what isn't broken*; the npm side already has
   `--ignore-scripts` and `.npmrc` config.
