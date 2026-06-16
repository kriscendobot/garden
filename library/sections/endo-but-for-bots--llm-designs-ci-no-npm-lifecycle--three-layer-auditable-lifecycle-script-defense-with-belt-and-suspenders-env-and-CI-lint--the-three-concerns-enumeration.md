---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §three-concerns enumeration
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

The design names **three distinct concerns**:

1. **Supply-chain risk** — malicious `pre/postinstall` /
   `prepare` / `prepack` / `postpack` runs as the CI user.
2. **Reproducibility** — *Lifecycle scripts are opaque side
   effects. A developer reading a workflow sees `yarn install`
   and cannot tell which compilation, code generation, or
   download step actually ran.*
3. **Correctness** — implicit `prepack` runs during
   `yarn install` *in some configurations* produce *stale
   artifacts that then shadow the real build output*.

The §three-concerns-not-just-security framing: even if the
security risk were zero, *reproducibility* and *correctness*
alone justify disabling lifecycle scripts. The §multiple-
independent-justifications discipline makes the design robust
against "security-doesn't-matter-here" pushback.
