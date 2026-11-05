---
posted_at: 2026-11-05T05:18:30Z
role: designer
handler-timeout: 5400
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: designer.** **Design a unified, standardized virtual file (and other capabilities) system for Endo, consolidating the pet name system designs** (maintainer request, kriskowal, 2026-11-05). Repo: `endojs/endo-but-for-bots` @ `llm` (the preferred fork), design at `designs/virtual-filesystem.md` (or a better name if the corpus suggests one), delivered the way that repo delivers designs (draft design PR, then the gauntlet). Consult `designs/README.md` (the live roadmap) and place the design in it.

**What it is.** The Endo pet name system is a virtual file system without the dogged emphasis on files. This design is both (a) the **consolidated, normative description** of it, which doubles as the **first draft of user documentation** for the pet name system, and (b) the **basis for finding inconsistencies and gaps** between the existing designs. Much of the content already exists; consolidate it, cite each source design, and list explicitly where they disagree, overlap or leave holes (a short "Inconsistencies and gaps" section with a table: topic, sources, what differs, recommended resolution).

**Sources to consolidate (read all; this is a starting list, search for more):** `designs/namehub-interface-unification.md`, `daemon-capability-filesystem.md`, `daemon-mount.md`, `daemon-mount-capabilities.md`, `daemon-mount-visible-roots.md`, `mount-stream-glob-grep.md`, `agent-tools-mount-fs-tools.md`, `daemon-checkin-checkout.md`, `daemon-cas-management.md`, `daemon-content-store-gc.md`, `store-write-file.md`, `cli-store-verb-text-modes.md`, `cli-edit-verb.md`, `endopi-edit-tool.md`, `chat-view-edit-commands.md`, `readableblob-range-attenuation.md`, `platform-range-and-tree-reads.md`, `endo-bytes.md`, `snapshot-mapper.md`, `npm-registry-as-directory-tree.md`, `endo-fs-from-git.md`, `daemon-git-capability.md`, `filesystem-watchers.md`, `formula-inspector.md`, `runtime-container-fs-mount.md`, `daemon-make-archive.md`, plus the existing `@endo/daemon`, `@endo/platform` and `@endo/exo-*` sources for what is actually implemented. Distinguish **implemented**, **designed**, and **proposed** throughout.

**Views and conversions to cover (the heart of the design).** A taxonomy of views over one underlying structure, and the conversions between them, stated as a small algebra:
- traditional mutable tree; snapshot view (immutable, content-addressed); read-only view of an underlying mutable tree (live but attenuated); and a view through a **mutability controller**, where a separate controller capability makes branches read-only or writable dynamically (revocable/flippable, at the controller's discretion).
- Beyond files: **block storage** (snapshottable to a blob), **append-only storage**, **data storage**, and generic capability slots; how each composes with directories and with pet names.
- Naming, paths, and the non-file entries (capability references) a pet-name directory can hold; the relation to NameHub.
- **Compare-and-swap**: how CAS is used and should be used (write preconditions on a snapshot identity, tree-level CAS, content-addressed expected values, the `identity()`/`snapshot()` direction of 2026-11-03 that hides the hash and uses content-equivalence semantics with the hash as a private fast path), and how CAS composes with the mutability controller.

**The interface (specify method sets, errors, and attenuation points).** The standard operations: read/write, **hashline editing**, **grep**, **glob**, **glorp** (define it precisely from the corpus or flag the gap if no existing design defines it; do not invent silently), **diff**, **patch**, and **merge**, plus ranged reads (`readTextRange`, `readByteRange`) and directory/tree operations. Say which belong on which view (a read-only view has no write methods; a snapshot has `diff` against another snapshot, etc.).

**Novel attenuation: an AI-agent-pathology guard.** Introduce a **maximum size for `readText` and `readBytes`** as an attenuation (a size-limited reader facet, composable with the other attenuations in this corpus, alongside range attenuation). Any method that would produce an oversize result returns an **error designed to teach the consumer**: it names the limit, the actual size, and tells the caller to retry by using **grep, glob, or glorp** to locate interesting ranges and then **`readTextRange` / `readByteRange`** to read just those and propose changes. Specify the error shape (machine-readable fields plus a human/agent-readable message), where the limit is set and who can change it (attenuation chain; a holder cannot raise it), and how this interacts with streams, directory listings, diffs and merges (those can be oversize too).

**Splicing without reading into context.** Specify how an agent can assemble content from **multiple sources without reading them into its context**: hashline edits and **operational transforms** over references (copy range A of source X into position P of target Y, atomically, with CAS preconditions), `patch`/`merge` between snapshots, and what verifies the result (hash/identity checks instead of re-reading). Give two or three worked examples (splice a function between files; apply a three-way merge of two edited snapshots; build a file from ranges of several blobs).

**Serialization of virtual file systems (a proposal to evaluate and specify).** Represent each "file" that is really a **capability reference** as a file whose bytes are a **magic number**, then a **hash of the string `"ocap:"` concatenated with the locator**, then the **locator in plain text**; plain text files lack that prefix, so restore can quickly tell "restore as text" from "restore as a reference to another capability". Specify the exact byte layout (magic value, hash algorithm and length, delimiter, encoding, versioning), how collisions and forgery are handled (what happens when ordinary text happens to start with the magic number; whether the hash binds the locator so tampering is detectable; whether the locator is secret-bearing and so must be protected like a bearer capability, cf. the https locator-fragment work), round-trip rules for snapshot/restore and for `make-archive`/checkin-checkout, and what restore does when the locator is unreachable. Evaluate at least one alternative (sidecar manifest, extended attribute, directory-level index) and recommend.

**Deliver:** the design document; a table of inconsistencies and gaps with recommended resolutions; a documentation-shaped overview section a newcomer could read ("the pet name system for people who know file systems"); a build ladder of small increments, smallest first; and a `## Open questions` section only for questions that truly need the maintainer. Score any new interface REST-vs-CapTP with `skills/api-transport-rubric` (default CapTP). State the ownership map (who owns durable state, commit/discard, restart/replay at each boundary). Keep it as short as completeness allows; link rather than restate the source designs.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T05:19:00Z
