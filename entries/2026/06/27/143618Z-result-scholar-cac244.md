---
kind: result
role: scholar
host: endolinbot
at: 2026-06-27T14:36:20Z
---
# result: scholar — ingest MetaMask/ocap-kernel package READMEs (per-package cluster)

Job `scholar-ingest-ocap-kernel-packages` (promoted from a deferred plan). Eighth
ocap-kernel ingest; the **per-package-README cluster** from the cycle-161 overview
plan. Sibling-implementation genre (reference-not-substrate). Worked in an isolated
worktree off `origin/journal2`; library commit `8197654` pushed.

## Idempotency / survey note

On claim, the live `/home/kris/journal` worktree was stale. Surveying the actual
`origin/journal2`, the **six doc-level ingests are all already done** (glossary,
identity-backup-recovery, ken-protocol-assessment, kernel-guide, usage,
platform-specific) and the `[[ocap-kernel]]` concept page already exists and is
rich. The **package READMEs were genuinely missing** — this cycle fills them.

## Sources ingested (6 package READMEs → 8 sections)

| Source | File-sha | Sections |
|---|---|---|
| packages/ocap-kernel/README.md | `e335251` (2026-03-12) | 2 — package-purpose; **SES/lockdown `@chainsafe/libp2p-yamux` patch requirement** |
| packages/kernel-utils/README.md | `e335251` (2026-03-12) | 2 — package-purpose (home of `makeDefaultExo`); SES/lockdown auto-applied patches |
| packages/streams/README.md | `d5a703d` (2025-05-02) | 1 — **gtor + @endo/stream lineage** (the one high-value line) |
| packages/kernel-store/README.md | `d5a703d` (2025-05-02) | 1 — storage abstractions; savepoint substrate under crank-buffering |
| packages/remote-iterables/README.md | `903fe9d` (2025-08-19) | 1 — remotable iterators/generators; `@ocap/` private namespace |
| packages/kernel-rpc-methods/README.md | `d5a703d` (2025-05-02) | 1 — JSON-RPC host/kernel control plane (contrast with CapTP) |

**Curation judgment:** most of these READMEs are near-boilerplate stubs (install +
contributing). Recorded honestly as such; the genuine library value captured is
(a) the SES/lockdown patch facts on ocap-kernel + kernel-utils — concrete
cost-of-libp2p-under-SES evidence, (b) the streams lineage, and (c) each package's
cross-comparable identity. Honest external-lineage flags throughout.

## Indexes touched

- `concepts/ocap-kernel.md` — appended 8 package-README rows to its section table (page pre-existed).
- `sources/README.md` — 6 rows under "External code repositories (sibling implementations)".
- `sections/README.md` — 6 new `###` source blocks (alphabetical).
- `topics/` — daemon (+4), capability-security (+1), hardened-javascript (+3), tooling (+2), exo (+2), streams (+2), persistence (+1), captp (+1).
- `keywords.md` — 12 lines → `ocap-kernel` concept.

## Integrity gate

`library-link-check.sh --changed` → **OK** — every section-table target,
`sections/README.md` row, and cluster link resolves to a committed file. No
omitted `kind: index` parent (these stub sources use the flat shape; sections
listed directly on the source page).

## Deferred remainder

Posted deferred plan `scholar-ingest-ocap-kernel-comment-fragments`: the seven
kernel-internals comment-fragment files (`Kernel.ts`, `VatHandle.ts`,
`VatSupervisor.ts`, `KernelQueue.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`,
`BaseDuplexStream.ts`), one file per cycle per the comment-fragment pacing. With
this cycle the per-doc and per-package-README lines of the cycle-161 plan are
complete; only the comment-fragment (and optional test-file) lines remain.

Self-improvement: the claimed job and its source overview both framed this as the
"sixth ocap-kernel ingest" and referenced "existing kernel-guide" as if pending,
but `origin/journal2` had advanced well past that — kernel-guide/usage were ingested
and the concept page created by peer cycles while this plan sat deferred. The live
`/home/kris/journal` worktree was stale and would have misled a survey done there.
Lesson reinforced: a scholar must run the idempotency/coverage survey against
`origin/journal2` (via an isolated worktree or `git show`), never the shared live
worktree, before deciding what is missing.
