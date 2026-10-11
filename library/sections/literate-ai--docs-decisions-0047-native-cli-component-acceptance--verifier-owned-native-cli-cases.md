---
title: "ADR 0047: Verifier-owned native CLI cases"
source: docs/decisions/0047-native-cli-component-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: A distinct native CLI kind binds packaged entrypoints to portable exact acceptance cases, complete filesystem projections, fresh bounded execution, compatible-worker evidence, and receipt invalidation.

### Add a distinct kind without changing the portable ABI

Add `native-cli-application` to `ComponentKind` and `native-cli` to entrypoint kinds.
The kind requires at least one native CLI entrypoint and never inherits the JSON argv,
test-mode or smoke-mode protocol of `portable-application`.

ADR 0026 still governs multiple entrypoints and deployment units. A Component may have
multiple native CLI entrypoints, and each receives an independently named acceptance
binding. Mixing native CLI, portable CLI, persistent service or web entrypoints is
allowed only when the existing kind-set rules resolve the combination unambiguously;
otherwise validation refuses it with a diagnostic naming the conflicting kinds. This
ADR does not change kind priority to make one entrypoint silently dominate another.

The Component lock, package plan and receipt bind every native CLI entrypoint's name,
deployment unit, package-relative executable path, selected native build/platform
Flavors and command projection. Absolute host paths and executable environment
variables are not authored Component authority.

### Use a portable, exact verifier-owned case contract

Each native CLI deployment unit requires a versioned acceptance document in the
existing verifier-owned acceptance directory. Its identity binds the Component and
entrypoint identities, accepted specification-set identity, target tuple, fixed
environment policy, resource bounds and a canonical nonempty case list.

A case declares:

- an exact argument vector, with only typed verifier workspace/file placeholders;
- optional bounded standard-input bytes;
- an exact exit code or the explicit `nonzero` predicate;
- bounded stdout and stderr expectations, using exact bytes or declared UTF-8
  contains/does-not-contain predicates;
- immutable input fixtures with relative paths, modes, sizes and content identities;
- the complete allowed post-execution filesystem projection, including path, type,
  mode, size bound and content expectation for each retained output; and
- case-specific timeout, output and filesystem byte limits within project maxima.

Paths are normalized portable relative paths. Case identifiers, paths and expectation
sets are unique and canonical. Placeholders cannot select arbitrary host paths. Binary
fixtures and outputs are supported as identity-bound bytes; text predicates require
valid UTF-8 explicitly. Undeclared created, removed or changed filesystem entries,
links, devices, sockets and path escapes fail acceptance.

The acceptance schema is published in the installed schema catalog. Its loader rejects
unknown fields, empty case sets, conflicting expectations, prefix/path collisions,
unbounded data and a specification or entrypoint identity that is no longer current.

### Execute the packaged product in lifecycle custody

Normal packaged execution records that native CLI invocation is deferred to independent
acceptance. The independent verifier resolves the selected entrypoint only through the
accepted package plan/result and rechecks its executable identity and package-tree
custody before and after every case. It never substitutes a source-tree executable or
an ambient executable named by an environment variable.

Each case runs in a fresh directory below the lifecycle object root with a minimal,
fixed target-appropriate environment, locale, timezone and umask. Only explicitly
declared non-secret environment values may be added. The process receives an argv list
directly without shell parsing. Tree-wide termination, deadlines and bounded capture
apply on every supported platform. The verifier snapshots the complete case tree before
and after execution and compares the result with the declared projection before
recording evidence.

Acceptance runs on the selected compatible lifecycle worker that owns the packaged
artifact and target toolchain. Controller-local execution is valid only when the
controller is that selected worker. Returned evidence binds worker observation, target,
package plan/result, executable, acceptance contract, per-case argv and input/output
identities, exit status and stream identities. The finalized project receipt binds that
evidence, so changed cases, specifications, Flavors, executable bytes, target or worker
execution invalidate it.

Host tools needed to build the native CLI remain governed by resolved lifecycle tool
bindings. If a case needs an additional executable as part of the product contract, it
must be an accepted runtime dependency in package custody; ambient `PATH` or arbitrary
environment-variable executable injection is refused.

Source: [docs/decisions/0047-native-cli-component-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0047-native-cli-component-acceptance.md) at commit `fcc40bc6`.
