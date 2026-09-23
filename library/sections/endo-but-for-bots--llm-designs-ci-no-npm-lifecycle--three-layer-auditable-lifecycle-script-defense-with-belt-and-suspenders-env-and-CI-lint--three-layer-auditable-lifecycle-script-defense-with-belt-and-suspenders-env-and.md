---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: Three-layer auditable lifecycle-script defense with belt-and-suspenders env and CI lint
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

> *CI workflows must treat lifecycle scripts as untrusted
> code. Any work that a lifecycle script would do is moved
> into an explicit, named workflow step that a reviewer can
> see in the workflow file and in the Actions log.*
>
> — `designs/ci-no-npm-lifecycle.md` §Principle

`ci-no-npm-lifecycle.md` (378 lines, *Complete* status,
shipped 2026-05-14 via PR #126 commit `ddbc8ad7e`) is a
**CI-supply-chain-defense design** by Kris Kowal *(prompted)*.
Created 2026-04-23; design-phase commit `102a94bc9` 2026-04-29
in a *batch of seven proposals*; implementation-phase squash-
merge 2026-05-14. **16-day calendar window** of which most
was queue/review wait, not active authoring.
