---
source: packages/kernel-utils/src/exo.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/kernel-utils/src/exo.ts
source_line_range: "1-30"
source_branch: main
source_commit: fa464ca40c63a1e37504fdfb16e70ccdac9021df
comment_subject: makeDefaultExo (and its helper makeDefaultInterface) is the passable-guards wrapper over @endo/exo's makeExo that ocap-kernel's AGENTS.md mandates in place of Far() from @endo/far, so every remotable is an interface-guarded exo by construction.
source_date: 2025-09-04
source_authors: [Erik Marks]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
notes: |
  Sixteenth ocap-kernel ingest, and the second file of this cycle (paired with
  packages/streams/src/BaseDuplexStream.ts). exo.ts is the makeDefaultExo home
  the kernel-utils README ingest flagged and the kernel guide's
  exos-remotable-objects section describes host-side. A small 30-line file
  yielding a single section: the makeDefaultInterface + makeDefaultExo pair. The
  divergence is a POLICY one, not a mechanism one — every primitive (makeExo,
  Methods, M.interface, InterfaceGuard) is imported from @endo/exo / @endo/patterns;
  ocap-kernel adds only the house rule "always makeDefaultExo, never Far" and the
  shorthand that bakes it in (passable default guards + a deliberate
  @ts-expect-error where the permissive interface does not match makeExo's
  method-guard types). Idempotency anchor is source_commit (file-path-specific
  sha fa464ca). No comment-versus-code drift found. With BaseDuplexStream.ts and
  exo.ts both ingested, the ocap-kernel kernel-internals + streams
  comment-fragment backlog from the cycle-161 plan is DRAINED.
---

> Abstract: `packages/kernel-utils/src/exo.ts` is the 30-line source of ocap-kernel's
> **`makeDefaultExo`** — the wrapper the repo's `AGENTS.md` mandates be used
> *instead of* `Far` from `@endo/far`. It exports two shorthands:
> `makeDefaultInterface(name)` builds a named `@endo/patterns` `InterfaceGuard`
> with `defaultGuards: 'passable'` (any passable argument admitted, no per-method
> guard required), and `makeDefaultExo(name, methods, interfaceGuard?)` wraps
> `@endo/exo`'s `makeExo` with that permissive interface (defaulting the guard to
> `makeDefaultInterface(name)`). The divergence from Endo is **policy, not
> mechanism**: ocap-kernel forbids the guardless `Far()` remotable so every
> cross-vat object is an interface-guarded, introspectable exo by construction —
> permissive by default, uniform in shape. A deliberate `@ts-expect-error` marks
> the one type mismatch ("intentionally not specifying method-specific interface
> guards").

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [makeDefaultExo-and-makeDefaultInterface](../sections/metamask-ocap-kernel--packages-kernel-utils-src-exo-ts--makeDefaultExo-and-makeDefaultInterface.md) | exo, capability-security | current |

## Provenance

- Fetched 2026-07-06 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `fa464ca40c63a1e37504fdfb16e70ccdac9021df` (last touched 2025-09-04 by Erik Marks).
- Authors over the file's history: Erik Marks (`git log` over the path).
- 30 lines; a single section covering both exported functions.
- **Sixteenth ocap-kernel ingest.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]]. The `makeDefaultExo` home flagged by the kernel-utils README ingest and described host-side by the kernel guide's exos-remotable-objects section.
- License: dual Apache-2.0 + MIT.
- No comment-versus-code drift found. The `Far()`-forbidden mandate lives in `AGENTS.md`, not this file's comments; this wrapper is its enactment. ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
