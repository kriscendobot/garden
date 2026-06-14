---
ts: 2026-06-14T08:17:24Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/researcher--055ce9
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: predecessor
refs:
  - entries/2026/06/14/080500Z-dispatch-researcher-85cd98.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4492612214
---

# result: researcher — references for factoring daemon-cas out of daemon (#403 follow-on)

Re-dispatched after researcher 85cd98 was rate-limited.
Proposed prompt: a builder that extracts the daemon's CAS surface
(currently `makeContentStore` inside `packages/daemon/src/daemon-persistence-powers.js`,
plus the SnapshotStore wrapper from `@endo/platform/fs/lite`) into a new
intermediate `packages/daemon-cas/` workspace.
Maintainer framing on PR #403 (review `4492612214`): "a temporary,
intermediate step on the way to migrating the daemon to use git-cas."
The refinement below grounds the extraction in the existing library
material on `daemon-cas-management` and `daemon-content-store-gc`, names
the registry-capability PR #403 itself as the package-shape precedent, and
points at the design dependencies that constrain what the extracted package
must continue to expose (the SnapshotStore the daemon currently consumes;
the Rust-side `cas-*` envelope verbs Phase 5 of `daemon-cas-management`
will eventually plug in).

```markdown
## Library and project references

### Library concepts and sections

- [journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md](../../../../library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md)
  — full §five-phase plan for the CAS subsystem; Phase 5 is exactly "JS
  manager integration replacing `makeContentStore()`". The current
  extraction is the intermediate hop *before* that Rust-supervisor swap.
- [journal/library/sources/endo-but-for-bots--llm-designs-daemon-cas-management.md](../../../../library/sources/endo-but-for-bots--llm-designs-daemon-cas-management.md)
  — source-page abstract naming the four CAS surface concerns: typed
  content, envelope verbs, retain/release, off-thread GC. The extracted
  package's API shape should leave room for these to attach later.
- [journal/library/sources/endo-but-for-bots--llm-designs-daemon-content-store-gc.md](../../../../library/sources/endo-but-for-bots--llm-designs-daemon-content-store-gc.md)
  — the design that added `remove()` to `makeContentStore` for sweep-time
  refcount GC. Critical: the daemon's GC pass in `daemon.js` (around lines
  800-905) calls `contentStore.remove(hash)` inside the formula GC sweep.
  Any extracted package must preserve `remove` semantics (idempotent,
  reference-counting-at-collection-time, not a persistent counter).
- [journal/library/concepts/formula-persistence-thesis.md](../../../../library/concepts/formula-persistence-thesis.md)
  — situates the CAS as one of the daemon's two persistence substrates
  (alongside the SQLite-backed formula store). Extracting the CAS does
  not factor formulas out; the persistence-powers object retains the
  formula-store half and continues to *expose* `makeContentStore` as a
  factory method even after the implementation moves to `@endo/daemon-cas`.

### Project context

- [journal/projects/endo-but-for-bots/README.md](../../../../projects/endo-but-for-bots/README.md)
  § *Rules of engagement* — base-branch inference from package
  availability: a brand-new `packages/daemon-cas/` directory exists on
  neither `llm` nor `master`, so the builder must add it on whichever
  branch the precursor packages already live on. The PR #403 precedent
  ([`packages/registry-capability/`](../../../../../dispatches/researcher--055ce9/project/packages/registry-capability/))
  is on `feat/registry-capability` against the `llm` lane; the
  daemon-cas extraction PR rides on top of #403 and inherits the same
  base.
- [journal/projects/endo-but-for-bots/README.md](../../../../projects/endo-but-for-bots/README.md)
  § *Standing authorizations* — bot is generally authorized to post
  freely on this repo; no per-action authorization needed for the
  builder PR description, comments, or reactjis.

#### Related designs on the `llm` branch

- `designs/daemon-cas-management.md` (In Progress; Phases 1-4 done in
  Rust supervisor) — the destination architecture. Phase 5 explicitly
  *replaces* `makeContentStore()` with Rust CAS verbs (`cas-store`,
  `cas-fetch`, `cas-has`, `cas-retain`, `cas-release`, `cas-store-tree`,
  `cas-gc`). The intermediate `@endo/daemon-cas` package's API surface
  should remain narrow enough that Phase 5 can later replace its
  implementation without touching the daemon's call sites.
- `designs/daemon-content-store-gc.md` (Complete; PR #99) — names the
  current `store`/`fetch`/`has`/`remove` contract and the sweep-time
  refcount discipline that the daemon's GC path depends on. The
  extracted package must expose `remove` even though it is a relatively
  recent addition.
- `designs/daemon-git-capability.md` (Proposed; doc 2 of 3) — the `Git`
  capability whose authority is derived from an `EndoMount`. The eventual
  `git-cas` would target this cap as the storage backend (git
  object-database as content-addressed store, replacing the
  `store-sha256/` flat directory). The intermediate package shape should
  make a future `makeGitContentStore(git)` swap mechanical.
- `designs/endo-fs-from-git.md` (In Progress) — `Git.filesystemAt(ref)`
  exposes a git tree as an `@endo/endo-fs` Filesystem; the same daemon
  GitBackend that powers this is the natural source for the future
  `git-cas` (blob OIDs are SHA-1, so the `ContentStore` interface as it
  stands assumes SHA-256; this is a real risk the design phase after the
  extraction must address).
- `designs/registry-capability.md` (Proposed; PR #403 implements layer
  1) — the package extraction precedent on this PR: `@endo/registry-capability`
  was carved out as a brand-new workspace with its own `index.js`,
  `src/`, `test/`, `types.d.ts`, `package.json`, three tsconfigs, and a
  separate `chore: Update yarn.lock` commit. The daemon-cas extraction
  follows the same shape exactly.

### Code-side reference points

The builder will rediscover these by grep, but naming them up front
avoids spending tokens on the search.

- The CAS implementation: `packages/daemon/src/daemon-persistence-powers.js`
  lines 122-197 (`makeContentStore` closure: filesystem-backed
  `store`/`fetch`/`has`/`remove` over `{statePath}/store-sha256/`, then
  wrapped with `makeSnapshotStore` from `@endo/platform/fs/lite`).
  The CAS impl is *one closure* inside a larger persistence-powers
  factory; everything else in the file (`provideRootNonce`,
  `provideRootKeypair`, formula/agent-key/retention CRUD) is *not* CAS
  and stays in the daemon.
- The CAS type: `packages/daemon/src/types.d.ts` line 1748 declares
  `makeContentStore: () => import('@endo/platform/fs/lite/types').SnapshotStore`
  as the persistence-powers contract. The extraction can keep this
  declaration but move the implementation; the daemon still calls
  `persistencePowers.makeContentStore()`.
- The CAS contract: `packages/platform/src/fs/types.js` defines
  `ContentStore` (raw `store`/`fetch`/`has`/`remove` by sha256) and
  `SnapshotStore = ContentStore & { loadBlob, loadTree }`. The contract
  *lives in the platform package*; the daemon's `makeContentStore`
  produces a `SnapshotStore`. The new package can re-export the types
  or depend on `@endo/platform` for them.
- Daemon consumers of the SnapshotStore: `packages/daemon/src/daemon.js`
  line 330 (`const contentStore = persistencePowers.makeContentStore()`)
  is the single instantiation site. From there `contentStore` is used at
  lines 812, 903, 1480, 1493, 1502, 1510, 3571, 3770-3772 (formula GC's
  `remove`, blob/tree formula fetch, `formulateReadableBlob`'s `store`,
  `checkinTree`'s `platformCheckinTree(remoteTree, contentStore)`). No
  consumer outside `daemon.js` touches the CAS directly.
- Cross-supervisor wiring: `packages/daemon/src/bus-daemon-rust-xs.js`
  line 51 also imports `makeDaemonicPersistencePowers`; the XS-on-Rust
  supervisor path goes through the same factory. The extraction must
  not break the XS variant.
- Test fixtures depending on the SnapshotStore shape:
  - `packages/daemon/test/_mount-test-helpers.js` — `makeMemoryStore`
    implements `ContentStore` in-memory and wraps with `makeSnapshotStore`.
    This is the template the new package's tests should reuse.
  - `packages/daemon/test/content-store-gc-invariants.test.js` and
    `packages/daemon/test/content-store-gc.test.js` — integration tests
    that fork a full daemon to exercise the CAS GC path. These stay
    where they are (they test daemon integration, not the CAS unit).
- Package-shape precedents:
  - `packages/registry-capability/` (PR #403) — the most recent and
    most relevant new-package precedent in this repo. Same shape exactly:
    `index.js`, `src/`, `test/`, `types.d.ts`, `package.json` with the
    full publishConfig + exports map + ava + tsconfig triple
    (`tsconfig.json`, `tsconfig.build.json`, `tsconfig.composite.json`,
    the last auto-generated).
  - `packages/skel/` — the canonical empty-package template; consult
    for any shape the registry-capability precedent doesn't cover (the
    `prepack`/`postpack` scripts, the `eslintConfig`/`ava` blocks, the
    `files` glob list).
  - `packages/hex/`, `packages/git/`, `packages/platform/` — three
    examples of small, single-concern packages that the daemon already
    depends on. `@endo/git` in particular is a useful shape comparator
    because it carries `types.d.ts` at the package root (not `src/`)
    and exposes both the default and a deep `./src/native-git-backend.js`
    export — relevant if the new package wants to expose the raw
    `ContentStore` factory separately from the `SnapshotStore` wrapper.

### Why each reference is relevant

- **daemon-cas-management Phase 5** sets the destination: the extracted
  package is the *intermediate seam* whose implementation will later be
  replaced by a thin shim over Rust CAS verbs. The seam must be narrow
  enough to make that swap mechanical.
- **daemon-content-store-gc** names the four-method contract
  (`store`/`fetch`/`has`/`remove`) the daemon's GC sweep depends on; the
  extracted package must keep them.
- **daemon-git-capability + endo-fs-from-git** describe the `git-cas`
  target shape; the extracted package's interface should not bake in
  SHA-256-specific assumptions if avoidable (git OIDs are SHA-1, soon
  SHA-256 upstream but with different semantics).
- **registry-capability + PR #403** is the canonical recent-PR precedent
  for new-package shape on this repo and lane.
- **Code-side reference points** name every site the builder will touch
  to move the CAS without breaking GC, the XS variant, or the
  cross-supervisor tests.

### Open questions for the downstream builder

- **Where does `@endo/platform/fs/lite`'s `makeSnapshotStore` live after
  the extraction?** Options: (a) leave it in `@endo/platform` and have
  `@endo/daemon-cas` depend on it (smallest change; current shape);
  (b) move it into `@endo/daemon-cas` and have `@endo/platform` re-export
  for back-compat (probably wrong; `makeSnapshotStore` is generic). The
  extraction note in the maintainer's prompt does not pin this.
- **Does `@endo/daemon-cas` export the `ContentStore` *interface* (the
  raw filesystem-backed factory) separately from the daemon-shaped
  `makeContentStore` (which receives `filePowers`, `cryptoPowers`,
  `config`)?** A separate export would let a future `@endo/git-cas`
  reuse the SnapshotStore wrapper around its own `ContentStore` impl.
- **Should the `Sha256` type alias in `packages/daemon/src/types.d.ts`
  move to the new package?** The whole point of the eventual `git-cas`
  migration is that the daemon stops assuming SHA-256; leaving the type
  alias in daemon is fine, but the new package's public types should
  probably use `string` (the platform `ContentStore` type already does).
```

## Library writeback

Added keyword shortcuts to `library/keywords.md` for terms the proposed
builder prompt and this refinement load-bear on, pointing at the existing
section on `daemon-cas-management`:

- `` `makeContentStore` ``
- `` `makeDaemonicPersistencePowers` ``
- `` `daemon-persistence-powers.js` ``
- `` `makeSnapshotStore` ``
- `` `@endo/platform/fs/lite` ContentStore SnapshotStore ``
- `` `store-sha256` filesystem CAS layout ``
- `git-cas drop-in target` (points at the project design pending ingest)
- `Phase 5 JS manager integration replacing makeContentStore`

No new concept page was drafted: the existing source page and section
page on `daemon-cas-management` carry the full surface a future researcher
or builder will need; further structure is premature until the extraction
itself lands and the package's API stabilizes.

## Open questions for the librarian

- **`designs/daemon-git-capability.md` is not yet ingested.** The
  Proposed-status design names the `Git` cap that the future `git-cas`
  would target. When the librarian next picks up an endo-but-for-bots
  ingest, this design is the highest-leverage gap for any researcher
  refining a builder prompt on the CAS/git lane.
- **`designs/endo-fs-from-git.md` is not yet ingested.** Same lane;
  documents the existing `Git.filesystemAt(ref)` adapter that the
  `git-cas` work would build on.

Self-improvement: nothing this time. The researcher's procedure handled
this engagement cleanly: identify domain terms in the proposed prompt,
walk the library's existing section files (the on-disk source map made
the CAS surface immediately findable), add keyword shortcuts pointing at
already-indexed material, surface the unindexed adjacent designs as open
questions for the librarian. No structural gap surfaced that warrants a
`message: researcher → liaison`.
