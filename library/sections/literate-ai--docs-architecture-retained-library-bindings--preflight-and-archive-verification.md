---
title: "Retained library bindings: input preflight and archive verification"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: `verify_retained_cargo_inputs` composes plan reopening with a read-only qualified-promotion check against independently derived current values (never copied from the candidate binding), returning a plan not a receipt; `verify_retained_cargo_archive` adds exact archive/product reopening under a mandatory custody guard and byte-limited store reader, re-resolving current inputs and rechecking the guard before returning, and writes nothing.

`verify_retained_cargo_inputs` composes this plan reopening with a read-only
qualified-promotion check. It requires the importing project's independently
reviewed binding identity and configured store name, the current provider lock and
reopened promotion evidence, explicit current generation/verifier/policy values,
current Cargo/rustc identities and the exact existing gate commands. A different
project, binding, store, qualification/run, provider revision, tool or gate command
refuses. The promotion service shares its existing lock/lifecycle consistency
checks with this read-only path and does not append another transition.

Callers must derive current values independently rather than copying fields from
the candidate binding or historical evidence. The preflight returns a plan, not a
consumption receipt: it neither reads the qualification archive nor proves its
export membership. The integration boundary must still reopen the complete archive
against current authority and preserve/recheck filesystem custody across artifact
reads, materialization and consumer gates.

`verify_retained_cargo_archive` now composes the preflight with exact archive and
product reopening. The caller supplies a current-input resolver with a mandatory
custody guard and an explicit named-store reader with a byte limit. Invalid review
or an oversized archive reference refuses before transport. All qualification runs,
the selected export set and package bytes pass the existing composed verifier before
any products return. The operation checks its original custody guard again,
resolves current inputs a second time, repeats preflight, requires equal current
values and checks the original guard once more. A changed policy, recipe set or
filesystem input prevents return. Recipe and command maps are copied into immutable
snapshots so mutation of a caller's map does not rewrite the first observation.

This operation writes no files and emits no persistent admission receipt. The
concrete filesystem resolver still must independently read and guard all importer,
provider, tool and retained-gate inputs; callbacks are trusted adapter boundaries,
not supplied evidence. Transactional publication and native consumer execution must
retain that custody and verify the actual manifest/lock bytes and full gate results.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 69–100).
