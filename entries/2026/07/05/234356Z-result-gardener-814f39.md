---
kind: result
role: gardener
host: endolinbot
at: 2026-07-05T23:43:58Z
---
# result: scholar — VatSupervisor.ts ingest (twelfth ocap-kernel, fourth kernel-internals comment-fragment)

Job: `scholar-ingest-ocap-kernel-comment-fragments-3`. Wore the **scholar** role;
read-only library scholarship over the public `MetaMask/ocap-kernel` bare clone
(`worktrees/metamask-ocap-kernel.git`, `main` HEAD `a3eff0efb`).
Sibling-implementation / reference-not-substrate genre.

## Ingested (1 source, 4 sections)

**`packages/ocap-kernel/src/vats/VatSupervisor.ts`** — the in-vat supervisor, the
**mirror image of the kernel-side `VatHandle`** (the eleventh ingest), so this
completes the kernel↔vat endpoint pair: the two files describe the two ends of one
JSON-RPC-over-duplex-stream link. Idempotency anchor `source_commit` =
`175b7c0663ce37c2626d33e08134346d4cdd17bf` (file-path-specific sha, #942
2026-04-24; verified against upstream before ingest — no prior VatSupervisor
source page existed, so this was a fresh ingest). 481 lines, ~113 comment-lines,
4 sections:

1. `--in-vat-endpoint-and-mirrored-dual-rpc-wiring` (lines 73-206; topics: capability-security, eventual-send) — the class + constructor; the `RpcClient` sends the vat's syscalls OUT (opposite of VatHandle's client), the `RpcService` handles the kernel's `initVat`/`handleDelivery` IN; the two defense-in-depth endowment asserts (`VatEndowmentsStruct` + explicit `harden`); the fire-and-forget drain that self-terminates with `StreamReadError`.
2. `--optimistic-syscall-execution` (lines 280-300; topics: eventual-send, capability-security) — the `executeSyscall` IMPORTANT comment: fire-and-forget `notify` + immediate `['ok', null]` to satisfy liveslots' synchronous interface, made safe because failures are caught crank-side in `VatHandle` (terminate + rollback).
3. `--idempotent-teardown-first-termination` (lines 116-129 + 208-248; topics: daemon, capability-security) — the shared `#terminationPromise` (concurrent callers await one completion); `#doTerminate` releases endowment resources before closing the stream, logs each `AggregateError` sub-error, never blocks stream closure so the original death reason reaches the kernel.
4. `--initvat-endowment-filtering-and-caveated-fetch` (lines 327-480; topics: capability-security, bundles) — once-only load; intersect kernel-supplied `allowedGlobalNames` against the full allowlist; reject unknown requested globals; wrap a requested `fetch` in a per-vat host-allowlist caveat with **no implicit-allow-all pathway**; disjoint endowment merge (collisions → `DuplicateEndowmentError`); build liveslots and deliver `startVat`.

Plus the parent `kind: index` section file
(`sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md`)
and the source-index page
(`sources/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md`).

## Indexes touched

- **Concept** `concepts/ocap-kernel.md`: added the VatSupervisor index row + 4 section rows to "Sections that touch this concept"; extended `aliases` with VatSupervisor / optimistic execution / executeSyscall / initVat / makeCaveatedFetch / DuplicateEndowmentError / allowedGlobalNames / makeAllowedGlobals / endowment teardown.
- **Topics** (Section rows via `insert-sections-table-row.sh` on the producer clone): `capability-security` (all 4 sections), `eventual-send` (sections 1-2), `daemon` (section 3), `bundles` (section 4).
- **Keywords** `keywords.md`: 13 new lines routing VatSupervisor terms → `ocap-kernel`.
- **Sources README**: new VatSupervisor row.
- **Regenerated (final landing step)**: `sections/README.md` (`regenerate-sections-index.sh`) and `topics/README.md` Sections-count column (`regenerate-topics-counts.sh`) — both landed current.

No new topics introduced (all four topic pages pre-existed); `topics/README.md`
Index rows needed no hand-edit beyond the regenerated count column.

## Drift check

**No comment-versus-code drift** in any of the four clusters (each section carries
its own Notice / drift check). One recorded **non-drift observation**: the
constructor's `Promise.all([this.#kernelStream.drain(...)])` wraps a *single*
promise in an array — harmless dead structure (likely a leftover from a
multi-stream drain), not a comment/code contradiction, so no drift finding.
ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman
missive is available regardless.

## Integrity gate

`library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts --wikilinks`
→ **OK — every checked link resolves to a committed file.** (exit 0)

## Follow-on

Posted deferred plan `scholar-ingest-ocap-kernel-comment-fragments-4`
(gate=deferred, priority=low, role=scholar) naming the four remaining
kernel-internals files: `KernelRouter.ts` (natural next pick — the demultiplexer),
`KernelServiceManager.ts`, `packages/streams/src/BaseDuplexStream.ts`, and
`kernel-utils/src/exo.ts` (`makeDefaultExo`). Carried forward the still-open
KernelQueue-leaf-sections-missing-from-topic-pages backfill note.

Self-improvement: The library lives at `library/` in the `journal2` branch, not
`journal/library/` — my first coverage survey (`git ls-tree ... journal/library/`)
returned zero ocap-kernel hits and briefly looked like the plan's claimed prior
cycles had never landed. The correct read-only survey path is
`origin/journal2:library/...` (or `git show origin/journal2:library/concepts/ocap-kernel.md`);
the `journal/` prefix is only how the deployed root mounts the worktree, not how
the branch stores it. A future scholar surveying "what's already ingested" should
grep `origin/journal2 -- library/`, not `journal/library/`, to avoid the same
false-negative.
