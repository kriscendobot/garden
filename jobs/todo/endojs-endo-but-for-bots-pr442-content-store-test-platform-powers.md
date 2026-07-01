# build: stand the daemon-cas content-store test on real @endo/platform powers

Repo: **endojs/endo-but-for-bots** — PR **#442** (`feat(daemon-cas): extract CAS surface into @endo/daemon-cas`), branch `feat/daemon-cas-extraction`, base `llm`.

## Directive (maintainer, PR #442 review comment)

kriskowal on `packages/daemon-cas/test/content-store.test.js` line 33 (the hand-rolled `makeFilePowers`):

> Please investigate using `@endo/platform` for these powers. These are likely duplicative and not the subject of this test, nor necessary to mock.

Treat the quoted text as the maintainer's ask, already vetted (trusted sender). This job discharges it.

## Investigation already done (start here — do not rediscover)

The test hand-rolls `makeFilePowers` (nine methods: `makeFileReader` / `makeFileWriter` / `readFileText` / `readFileRange` / `statPath` / `makePath` / `joinPath` / `renamePath` / `removePath`) and `makeCryptoPowers` (`makeSha256` / `randomHex256`) over `node:fs` + `node:crypto` — the exact `ContentStoreFilePowers` / `ContentStoreCryptoPowers` shape `makeContentStore` consumes.

Surveying the workspace at head `b8492ead`:

- **`@endo/platform` owns the powers *types***: `ContentStoreFilePowers` / `ContentStoreCryptoPowers` are defined in `@endo/platform/fs/lite/types` (`packages/platform/src/fs/types.js`). The recent refactor (`4b28ce4df`) already stood `content-store.js` on these types. So `@endo/platform` is the type home.
- **`@endo/platform` owns a real node-fs layer** but at a *higher* level: `@endo/platform/fs/node` (`src/fs-node/`) exports `makeLocalBlob` / `makeLocalTree` / `makeTreeWriter` over real `node:fs`, plus `@endo/platform/fs/lite` snapshot-store machinery. It does **not** export a reusable four-method real-fs `ContentStoreFilePowers` constructor, nor a `ContentStoreCryptoPowers` constructor. So there is nothing to import *today* that deletes the shim.
- **The only concrete four-method real-fs implementation** (`makeFilePowers({fs,path})` + `makeCryptoPowers(crypto)`) lives in **`@endo/daemon`** (`daemon-node-powers.js`) — an API-exact superset. It is **disqualified**: `@endo/daemon` depends on `@endo/daemon-cas` at runtime; a daemon-cas test importing `@endo/daemon` (even as a devDependency) reintroduces the very cycle this extraction removes. `@endo/daemon`'s `_mount-test-helpers.js` is a memory store, not real-fs, so it does not fit either.
- daemon-cas deps today: `@endo/harden`, `@endo/platform`, `@endo/stream`; devDeps include `@endo/exo-stream`, `@endo/stream-node`. **No `@endo/daemon`.** Keep it that way.

Conclusion: the maintainer's premise is right in spirit — the shim *is* duplicative of powers that belong in a shared home — but that home (`@endo/platform`, which already owns the types + the `fs-node` real-fs layer) does **not yet export** the reusable real-fs powers constructor. The productive move is to **add it to `@endo/platform` and adopt it in the daemon-cas test** (and consider adopting it in the daemon's production powers so there is one real-fs `ContentStoreFilePowers` source, not three hand-rolls).

## Deliverable

Open a **DRAFT** PR (follow the frozen-base-branch discipline: base a snapshot of `llm`, like #581 did for the JSDoc-import lint rule) that:

1. Adds a reusable real node-`fs` powers constructor to `@endo/platform/fs/node` producing the `ContentStoreFilePowers` shape, and a matching `ContentStoreCryptoPowers` constructor over `node:crypto` — sitting alongside `makeLocalBlob` / `makeLocalTree`. Ship types, a unit test, README note, and a changeset (`@endo/platform` minor). **Names must be fully spelled out — no `mk`/`dir`/`fs`-abbreviated identifier components** (maintainer directive on this very PR #442; the CLI-command-name exception does not apply here).
2. In `packages/daemon-cas/test/content-store.test.js`, replace the hand-rolled `makeFilePowers` / `makeCryptoPowers` (and the local `asAsyncIterable` helper if the same PR gives a home for it) with the new `@endo/platform` constructor(s), deleting the duplicated `node:fs`/`node:crypto` plumbing. The four-method CAS contract coverage must stay identical (round-trip, multi-chunk hashing, presence/absence, idempotent remove, dedup, atomic-rename, fetch-reads-disk, `${statePath}/store-sha256/` join).

If, once you dig in, a reusable constructor turns out to be genuinely unwarranted (e.g. the platform maintainers would reject a real-fs powers export as out of `@endo/platform`'s intended surface), the fallback deliverable is a concrete, API-grounded reply on the PR thread explaining why the shim must stay, with the dependency-direction rationale above — an honest "cannot cleanly deduplicate" beats a forced abstraction. Do not silently drop the ask.

Note the cross-branch shape (like #581): the `@endo/platform` constructor lands on a base-`llm` snapshot; the daemon-cas test adoption is #442-local and lands once #442 rebases onto the constructor. Sequence and flag this in the PR body.

Run the full gamut on the resulting draft (cleaner → judge → fixer-loop → un-draft). Post the top-level summary comment and the inline thread reply on #442 when the change is in place.

Provenance: routed by the attention-directive job `endojs-endo-but-for-bots-pr442-5f20450c` from review comment https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3503467257.
