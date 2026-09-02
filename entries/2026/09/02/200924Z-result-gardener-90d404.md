---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-02T20:09:26Z
---
---
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
pr: 1117
---

Jury seat `purist`, code panel on `endojs/endo-but-for-bots` PR
[#1117](https://github.com/endojs/endo-but-for-bots/pull/1117)
(`feat(registry): expose npm registries as directory trees`), head `5d2fb0a46`,
base `upstream/llm` (merge base `1956e545d`; the worktree's `origin/llm` ref is a
stale 2026-07-22 snapshot and yields a 4,602-file diff — the real diff is 44
files).

### purist

**Verdict:** request-changes

**Findings:**

- `packages/exo-npm/src/errors.js:26-40` — `annotateRegistryFailure` defines own
  `errorName` and `registryErrorName` properties on the error. `@endo/pass-style`
  rejects *any* own property outside `message`/`stack`/`cause`/`errors`,
  regardless of enumerability (`Passable Error has extra unpassed property`).
  Verified under `@endo/init`: `passStyleOf` throws for `RegistryNotFoundError`,
  `RegistryPathSyntaxError` and `RegistryOfflineError`, while the untouched
  `RegistryMissingPackageError` still passes — so `RegistryOfflineError` is a
  passability *regression*. These errors cross the `@registry` boundary; a
  root-position rejection survives marshal's error-like special case, but the
  same error nested as a `cause`, in an `errors` array, or inside a returned
  record fails to encode. The comment at :28-33 reasons only about enumerability,
  one rule short of the check it cites. **must-fix**
  [rule: roles/jurors/purist/AGENT.md § Passability]

- `packages/exo-npm/src/errors.js:44-70,168-175` — the fix is to stop hand-rolling
  a primitive `@endo/errors` already provides: `makeError(details, errConstructor,
  { errorName })` takes both the constructor and the tag. `new
  RangeError(makeError(X`…${path}`).message)` keeps only the *redacted* message and
  discards `makeError`'s log-args registration, so under production `lockdown` the
  error reads `Package registry has no entry at (a string)` and the path is
  unrecoverable from the message *and* the console note. Measured side by side:
  `makeError(X`…`, RangeError, { errorName: 'RegistryNotFoundError' })` prints the
  real path, tags `name`, and is passable. **must-fix**
  [rule: roles/jurors/purist/AGENT.md § Reuse over re-implementation of `@endo/*` primitives]

- `packages/exo-npm/src/errors.js:25,36-37` — `errorName` now means two different
  things inside one error family: the discriminant `PackageRegistryError` on the
  three tree errors (concrete name displaced to `registryErrorName`) and the
  concrete class on `TAMPERED`/`MISSING`/`NETWORK`. Pick one meaning for the
  family or document the split. Relatedly the exported function
  `registryErrorName` (:214) and the error property `registryErrorName` share a
  name while the function does not merely read it. **should-fix**
  [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols; § Type-vs-value namespace separation]

- `packages/exo-npm/src/registry-tree-resolver.js:83-91,334` — `fallbackHash` is a
  hand-rolled base-257 polynomial mod 2^256, zero-padded to 64 hex chars, and it
  is the **default** for `resolutionHash` (no caller injects `options.sha256`
  today). `@endo/sha256` is a workspace package. The `nohash-` prefix limits the
  confusion but not the duplication. **should-fix**
  [rule: roles/jurors/purist/AGENT.md § Reuse over re-implementation of `@endo/*` primitives]

- `packages/exo-npm/src/registry-tree.js:64-110` — `comparePublishedVersions` is
  this package's *third* semver comparator (`src/mvs-resolver.js:78`,
  `src/reference-backend.js:43`) and disagrees with the MVS one, which drops
  prerelease entirely. `greatestSatisfying`
  (`registry-tree-resolver.js:45-50`) sorts candidates with the new
  prerelease-aware order while filtering them with `satisfiesRange`'s
  prerelease-blind parse, so one selection runs two version semantics. Unify on
  one comparator. **should-fix**
  [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

- `packages/exo-npm/src/registry-tree.js:383-390` — `makeEndorNpmRegistryTree`
  documents itself as "the same narrow adapter with a distinct constructor name",
  but neither half holds: `packages/daemon/src/registry-tree.js:189` (the Endor
  adapter) calls `makeNpmRegistryTree` directly, so the wrapper is unreached
  outside `test/registry-tree-conformance.test.js`; and `label` only alters `help`
  text — the exo tag stays `'npm package registry'` on both lanes. `rust/endo/src/
  registry_tree.rs:56` repeats the false claim in a doc comment. Wire it or drop
  it. **should-fix**
  [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

**Notes (out of scope but worth flagging):**

- `packages/exo-npm/src/registry-tree.js:140-155` — the re-attenuating wrapper
  synthesizes `getInfo: () => harden({ temporal })` and inherits the caller's
  `temporal`, so an immutable package snapshot reached through a `'live'` view
  reports `temporal: 'live'` and silently loses `integrity` and `sha256`.
  Attenuation should withhold enumeration, not restate an immutable node as live.
  **comment-only**
  [proposed-rule: an attenuating view's `getInfo` forwards the underlying node's claims minus the withheld authority; it never fabricates a claim the wrapped node contradicts.]

- `packages/exo-npm/src/registry-tree.js:127,130-134` — `view.has()` with an empty
  path forwards to `tree.has()` and answers `true`, while `view.lookup([])` throws
  `RegistryPathSyntaxError`. The `has ⇒ lookup` agreement the `npmHub.lookup`
  comment (:311-318) explicitly defends is not upheld by the view itself.
  **comment-only**
  [rule: roles/jurors/purist/AGENT.md § Edge-case enumeration on values]

Self-improvement: the seat's brief should say that when the dispatch names
`origin/llm` as the diff base, the seat must confirm the ref is not stale
(`git log -1 origin/llm` against the PR's real base via `gh pr view --json
baseRefName`) before reading a diff — here `origin/llm` was six weeks behind and
`git diff origin/llm...HEAD` returned 4,602 files and 409k insertions instead of
the PR's 44 files, which would have drowned the review. A message to `liaison`
proposing that check for `skills/panel-review/SKILL.md` § Per-juror block shape
(or `skills/worktree-per-pr/SKILL.md`) is warranted.
