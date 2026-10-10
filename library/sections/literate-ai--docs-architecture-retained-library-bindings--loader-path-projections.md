---
title: "Retained library bindings: macOS and Linux loader-path projections"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [capability-security, testing]
status: current
---

> Abstract: `MacOsLoaderPaths` models the four dyld library/framework override and fallback controls (rejecting other `DYLD_*`), and `LinuxLoaderPaths` models `LD_LIBRARY_PATH` between inherited `RPATH` and direct `RUNPATH` with corrected ELF slash-import, `$ORIGIN`, and `RUNPATH`-suppresses-`RPATH` semantics; both freeze into the retained native guard, while interposition, secure execution, and other loader policy stay open; the read-only commands issue no receipts, and `admit` composes everything ADR 0040 requires.

Explicit macOS loader-path observation uses `MacOsLoaderPaths` for library and
framework override/fallback directories. It preserves ordering, keeps framework
version suffixes, and rejects relative/noncanonical roots, implicit current-directory
entries, more than 128 total directories and unmodeled `DYLD_*` controls. Application
seed context propagates through transitive imports; inspector/toolchain traversal
retains its sanitized context even when it shares image bytes with the application.
Override candidates precede the original lookup, and fallback candidates follow a
missing original. The retained native guard freezes this projection for every
re-observation; callers that omit it retain the previous selection identity.
This models the four path controls, not all dyld policy: embedded load-command
settings, inserted/versioned images, process security and other platform-specific
loader behavior remain separate qualification requirements. The live fixtures
exercise an absolute library override and a versioned framework override.

ELF imports containing a slash select that path directly, without loader-cache or
explicit-library-root fallback. `$ORIGIN` and `${ORIGIN}` expand against the
importing image's directory. Relative path imports and other dynamic tokens refuse
because their execution context is not yet modeled. This corrects direct import
selection. A `RUNPATH` tag suppresses `RPATH`, including when its value is empty;
nonempty path strings containing empty directory entries refuse. Traversal retains
`RUNPATH` presence separately from its effective directories. An image without
`RUNPATH` searches its own `RPATH` before inherited ancestor paths; an image with
`RUNPATH` suppresses inherited paths for its direct imports. Only `RPATH` passes
to children, with `$ORIGIN` expanded at the declaring image. Each executable seed
keeps its own first-visit traversal context, even when application and inspector
share image bytes; interpreter dependencies start without application inheritance.
Explicit `LinuxLoaderPaths` applies `LD_LIBRARY_PATH` after inherited `RPATH` and
before direct `RUNPATH`. It accepts at most 128 canonical absolute POSIX paths,
preserves colon/semicolon-delimited order, ignores a wholly empty variable and
refuses empty directory entries, dynamic tokens, other `LD_*` controls and
`GLIBC_TUNABLES`. Runtime context follows application imports; build/inspector
contexts remain sanitized even when the same seed has both roles. With an explicit
projection, arbitrary supplied library roots are not appended as fallback loader
directories. Omitting the projection preserves legacy observation behavior.
The retained native guard freezes and reconstructs this projection on every check.
Retained-Cargo test observation supplies its composed Linux process environment,
including measured compiler library directories and package overlays. Loaded-object
aliases and symbol interposition, secure
execution, cache/hardware-capability fidelity and native Linux qualification remain
required before claiming complete consumer loader authority.

The read-only and provisioning commands do not execute consumer gates or issue
importer-admission receipts. `admit` composes complete source/external-dependency
custody, attributable positive consumer results, durable admission and acknowledged
source retirement as required by ADR 0040. Endpoint provisioning belongs to the
operator.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 670–715).
