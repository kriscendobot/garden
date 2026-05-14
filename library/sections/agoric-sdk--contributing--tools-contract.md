---
title: tools contract (repository scope boundaries)
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: Names a strong directional-import discipline (src/** must not import **/tools/**) that capability-conscious refactors must respect. Cross-cuts with agoric-sdk--agents--coding-style-and-naming-conventions's `@agoric/*` vs `@aglocal/*` rule — both are about boundary disciplines.
---

> Abstract: agoric-sdk's per-package directory contract. Four scopes: `scripts/` (executable entrypoints only), `src/` (production-safe library code), `tools/` (cross-package test harnesses, mocks, fixtures, helper interfaces), `test/` (local tests only, not imported by other packages). Decision rule for src vs tools: if consumers import it to exercise/simulate package behavior, prefer `tools/`; if they import it as part of real runtime behavior, prefer `src/`. Directional rules: `src/**` must not import `**/tools/**` (except temporary allowlisted legacy imports); `tools/**` may import `src/**` but not vice versa; non-test files must not import `**/test/**` from any package. Publishing rules: `tools/` may be deep-imported within the monorepo and across CI but is not enforced by CI for manifest/export policy and is not part of the semver contract.

## `tools` contract

Repository scope boundaries:

- `scripts/`: executable entrypoints only
- `src/`: production/runtime library code and production-safe helpers that are part of the package library surface
- `tools/`: supported cross-package support utilities (test harnesses, mocks, fixtures, typed helper interfaces)
- `test/`: local tests only; not imported by other packages

Choosing between `src/` and `tools/`:

- Put code in `src/` when it is production-safe and should be treated as part of the package runtime/library API, even if tests also use it.
- Put code in `tools/` when its main purpose is to help another package test, integrate with, or simulate this package, even if it is intentionally shared and supported.
- Short rule: if consumers import it to exercise or simulate package behavior, prefer `tools/`; if consumers import it as part of real runtime behavior, prefer `src/`.
- If another package imports it, it must not live in `test/`.
- Example: `setupOrchestrationTest` belongs in `tools/` because it is a reusable integration harness.
- Example: `makeTestAddress` belongs in `tools/` if it is only deterministic fake-address generation for tests; if it becomes a general runtime-safe address utility, move it to `src/`.

Direction rules:

- `src/**` must not import `**/tools/**` (except temporary allowlisted legacy imports during migration)
- `tools/**` may import `src/**`, but not vice versa
- Non-test files must not import `**/test/**` from local or other packages

Publishing rules:

- `tools/` may be published or deep-imported as needed within the monorepo.
- CI does not enforce `tools/` manifest or export policy.
- `tools/` is not part of the semver contract of the package.

Source: [CONTRIBUTING.md](https://github.com/Agoric/agoric-sdk/blob/de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22/CONTRIBUTING.md) at commit `de2c4cbc`.
