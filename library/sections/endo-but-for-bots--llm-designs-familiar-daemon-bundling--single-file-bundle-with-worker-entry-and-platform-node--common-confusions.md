---
title: Common confusions
source: designs/familiar-daemon-bundling.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-05
source_authors: [Kris Kowal (prompted)]
source_lines: "1-162 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-ninth endo-but-for-bots design ingest. **Status:
  Complete**. The 161-line design documents the *daemon-bundling*
  for the Familiar Electron application — *self-contained artifact
  that can be spawned with a bundled Node.js executable on the
  user's platform*. Cycle 113 ingests this as the **second** of
  cycle 109's three named dependencies (cycle 111 was the first,
  familiar-gateway-migration; cycle 109's third dependency,
  familiar-unified-weblet-server, remains queued).
  
  Three structurally interesting moves: (1) the *two-option-
  exploration-with-preferred-choice* shape — Option A (single-file
  bundle via esbuild) vs Option B (packaged directory); the design
  explicitly names both and picks A with rationale; (2) the
  *three-challenges-with-three-mitigations* discipline — dynamic
  `import()` for runtime-loaded user code + SES `lockdown()` global
  side effects + OCapN-Noise WASM co-location — each challenge
  has a named mitigation; (3) the *worker-resolve-relative-to-
  bundle-location* discipline via `new URL('./endo-worker.cjs',
  import.meta.url).pathname` — the daemon doesn't search PATH or
  use cwd-relative paths; the worker entry point sits next to the
  daemon bundle. The §compatibility-invariant — *the bundled
  daemon must produce the same Unix socket protocol, CapTP
  messages, and persistence format ... It's the same code, just
  packaged differently* — and the §state-directory-shared
  discipline (`~/.local/state/endo/` is the same for both bundled
  and development daemons) means the *bundled daemon is
  interchangeable with the development daemon*, supporting the
  cycle 109 Familiar's *play well with existing daemons* discipline.
  
  Single-section cohesion-honest ingest.
parent: endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node
---

- **"Option A is just esbuild; that's obvious."** It's *one of two valid options*. The §design names Option B (packaged directory) explicitly with its trade-off (larger artifact). The §discipline: don't assume the maintainer who picks up this file knows the obvious choice; document the alternative + rationale.
- **"The three challenges are over-engineered."** They're *the actual issues with single-file bundling*. Dynamic `import()` *literally cannot* be statically bundled; SES `lockdown()` *literally must* run; WASM *literally must* be co-located. The §discipline is *enumerate the gotchas before they bite*.
- **"`new URL('./endo-worker.cjs', import.meta.url).pathname` is just a Node.js idiom."** It is — *and the design uses it for a specific structural purpose*. The worker entry must be resolvable *without configuration*. Hard-coding a path would fail if the user installs the Familiar in a non-default location; PATH-based resolution would fail in restricted environments. The relative-URL math works *anywhere the bundle is placed*.
- **"The 50MB size target is fixed."** It's *a target, not a hard limit*. The design names it explicitly so size-regressions are detectable. Future versions might revise it as Node.js or the daemon grow.
- **"`packages/familiar-build` vs `packages/daemon` placement is bikeshedding."** It's *honest acknowledgment of an open choice*. The design says *(or a new `packages/familiar-build` package)*; the maintainer makes the call at implementation time. The §discipline: *name the choice without forcing it premature commitment*.
- **"The bundle includes ses-shim.cjs only `if separate` — that's hedging."** It is — and *for good reason*. SES might inline into the daemon bundle if the bundler preserves the side effect correctly; if it doesn't, a separate ses-shim.cjs is required. The §design acknowledges both possibilities.
- **"The state-directory-shared discipline forces bundled and development daemons to be ABI-compatible."** It does — *and that's the point*. The §discipline ensures *interchangeable daemons*: a user running development daemon today, Familiar daemon tomorrow, CLI daemon next week — all share the same state. The §invariant is *user-state-survives-daemon-choice*.
- **"`None (can proceed independently)`" dependencies is just saying nothing depends on this."** It's saying *the design has no upstream dependencies*. Other designs depend on this; this depends on nothing in the family. The §foundational-no-upstream observation is structurally significant — it can be implemented and shipped *independently of all other Familiar work*.
- **"The Compatibility invariant `It's the same code, just packaged differently` is tautological."** It's *the structural invariant the bundle must satisfy*. A naive bundle might strip imports, inline polyfills, or otherwise modify behavior. The §discipline says: *don't*. The bundle is *exactly the same code* at the wire-protocol level.
- **"Trusted Node.js source + checksums is paranoid."** It's *supply-chain-attack mitigation*. Compromised Node.js binaries have been used in real attacks. The §discipline names the threat and the mitigation explicitly.
