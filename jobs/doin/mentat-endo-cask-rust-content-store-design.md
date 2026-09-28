---
tier: mentat
dispatch: manual
---
role: designer
handler-timeout: 14000

# Design: CASK in Rust as Endo's content store (and substrate for Endo's virtual filesystem)

Repo: `endojs/endo-but-for-bots` (design lands under `designs/` against the `llm` line, per that repo's
conventions and the garden designer norms in `roles/designer/AGENT.md`, including the open-questions carve-out).
This is a **design** job: no implementation.

## Maintainer direction (kriskowal, 2026-09-28)
- Port **CASK to Rust, inside Endo**. **Every design detail is flexible**: CASK has not materially shipped anywhere and
  can be **redefined to serve Endo's needs**. Shape CASK's data model to fit Endo's, and shape Endo to surface CASK's
  specialized content capabilities (e.g. **attenuations on content stores**, and possibly CASK's fancier
  content-stored data structures).
- The most interesting virtue: CASK can model **exactly what Endo needs from a content-addressed store, including
  embedded capabilities**, and be a **better substrate for Endo's virtual filesystem**.
- **Do not limit ambition to current needs.** In particular, Endo should be able to **meter storage classes
  separately**, for example:
  - **block storage**: pay to grow an allocation; pay compute prices for writes within the allocation;
  - **content storage**: pay for writes; pay compute prices for garbage collection; **rebates for released storage**;
  - **append-only storage**: pay for writes; bulk collection; or tiered automated roll-up or archive;
  - …and other classes the design finds natural.
- **Somewhat orthogonal but related:** Endo needs **better compare-and-swap facilities for writing values into
  storage**, and CAS semantics may differ across filesystem and storage platforms (local FS, SQLite, S3 conditional
  writes, DynamoDB conditional expressions, Cloudflare Durable Objects / D1 / R2, etc.). Design a portable CAS
  capability and its per-platform realizations. It can be a section of this design or a companion design file,
  whichever reads better.

## Read first
- **CASK prior art in the garden library** (`journal/library/`): 237 entries, including `sources/cask--architecture`,
  `cask--allocator-design`, `cask--blob-design`, `cask--array-design`, `cask--bigint-design`,
  `cask--caskroot-design`, `cask--cell-capabilities`, `cask--cask-go`, and concepts such as `cask-cell-bank`,
  `cask-cell-facets`, `cask-three-gate-access`, `cask-entry-type-capability`, `cask-named-typed-pointer`,
  `cask-block-backbones`, `cask-nursery`, `cask-reducer-pattern`, `cask-operational-transform`, `cask-verb-catalog`,
  `caskdir-directory-format`, `casknet-wire-protocol`, `casksock-local-protocol`, and `cask-protocol-v2-abandoned`.
  Also the GEFS / Bεtree material (`betree`, the GEFS ingest from 2026-09-18, which cross-referenced CASK and the Endo
  VFS). Use the librarian conventions (`skills/library-lookup`) to find more.
- **Endo designs** (branch `llm`): `daemon-cas-management`, `daemon-content-store-gc`, `daemon-endo-rust-sqlite`,
  `daemon-mount`, `daemon-mount-capabilities`, `agent-tools-mount-fs-tools`, `mount-stream-glob-grep`,
  `daemon-worker-import-from-mount`, `readableblob-range-attenuation`, `endo-content-locators-magnet-urn`,
  `ironhorse-snapshot-store-seam`, `daemon-xs-worker-metering`, `ironhorse-meter-opcode-cost-instrumentation`,
  `daemon-rust-xs-performance`, and the current content-store and formula-persistence code in `packages/daemon`.
- The concurrent minion.town platform designs (mentat jobs posted 2026-09-28): `aws-distributed-persistence`,
  `cloudflare-backend`, `alt-hosts-backend`, `process-snapshot-persistence-by-platform`, `per-principal-sharding`.
  Read whichever have landed. The per-principal content store and the per-platform CAS realizations should line up
  with them.

## The design must cover
1. **Data model**: what CASK becomes for Endo. Content addressing (hash choice, chunking, dedup), typed nodes,
   **embedded capabilities** (how a content object can carry or reference capabilities without leaking authority
   through content-addressing), directories and the VFS mapping, large blobs and range reads (compatible with
   readable-blob range attenuation), and which CASK data structures (cells, arrays, bigints, …) Endo should surface.
2. **Capability surface**: content-store capabilities and **attenuations** (read-only, prefix/subtree, range, quota-bounded,
   append-only, …), how they compose with Endo's existing mount/blob capabilities, and how they cross OCapN.
3. **Storage classes and metering**: the classes above (and others), the accounting model for each (allocation growth,
   write, GC compute, rebates on release, roll-up and archive), how it plugs into Endo metering
   (`daemon-xs-worker-metering`), and how it maps to per-principal quotas.
4. **GC and lifetime**: reachability from capabilities and formulas, rebates, and interaction with snapshots
   (Iron Horse process snapshots stored as content).
5. **Compare-and-swap**: the portable CAS capability (semantics, failure modes, linearizability), its use for
   formula/value writes, and its per-platform realization and guarantees across local FS, SQLite, and the cloud stores.
6. **Rust architecture**: crate layout inside Endo, the boundary with the JS daemon (FFI, sidecar, or wasm, weighing
   the existing `daemon-endo-rust-sqlite` direction), on-disk and on-wire formats, and pluggable backends (local,
   S3/R2, DynamoDB/D1/DO…).
7. **Migration and interop**: from the current Endo content store, and what of CASK's original design to drop, keep, or
   redefine (be explicit; this is a redefinition, not a faithful port).
8. **Phased plan**: milestones and suggested job basenames (not posted), with the first milestone small enough to build.

Put genuine maintainer decisions in `## Open questions` (and use the review-PR carve-out). Settle everything else.
Complete via the normal completion path. Report the design file(s), the PR if any, the open questions, and the
proposed phases.


<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T07:36:14Z -->

<!-- garden-transient-elapsed: kind=signature through=1 values=3,7 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-28T07:40:48Z
