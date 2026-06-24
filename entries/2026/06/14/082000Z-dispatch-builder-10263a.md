---
ts: 2026-06-14T08:20:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--10263a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4492612214
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/081724Z-result-researcher-23eb2a.md
---

# dispatch: builder — factor daemon-cas out of daemon on PR #403 per kriskowal directive

Maintainer directive (kriskowal on PR #403, review
`4492612214`):

> Now, to validate the premise, please append work that
> factors daemon-cas out of daemon. This should be a
> temporary, intermediate step on the way to migrating
> the daemon to use git-cas.

Researcher `055ce9` (result `23eb2a`) produced the
references — **read it verbatim** before starting:
`journal/entries/2026/06/14/081724Z-result-researcher-23eb2a.md`.

## Headline findings (per researcher)

- **CAS surface to extract**: single closure `makeContentStore`
  at `packages/daemon/src/daemon-persistence-powers.js:122-197`,
  plus `SnapshotStore` wrapper at
  `packages/platform/src/fs/snapshot-store.js` (decide
  whether SnapshotStore moves into the new package or stays
  in @endo/platform — designer call).
- **Types** (`ContentStore` / `SnapshotStore`) already live
  in `@endo/platform/fs/lite/types`; new package depends on
  @endo/platform for them rather than duplicate.
- **Single daemon-side consumer**: `packages/daemon/src/daemon.js`
  instantiates `contentStore` once (line 330) and uses it at
  lines 812, 903, 1480, 1493, 1502, 1510, 3571, 3770-3772.
  **No external consumers**.
- **Cross-supervisor wiring**: `bus-daemon-rust-xs.js` also
  instantiates `makeDaemonicPersistencePowers`; the XS path
  must keep working.
- **Package shape**: mirror `packages/registry-capability/`
  (already in this PR) and `packages/skel/` template:
  `index.js`, `src/`, `test/`, `types.d.ts`, `package.json`,
  tsconfig triple.
- **Four-method contract** to preserve per
  `designs/daemon-content-store-gc.md` (PR #99):
  `store` / `fetch` / `has` / `remove`. Sweep-time refcount
  discipline.

## Open questions (per researcher)

1. Does `makeSnapshotStore` stay in `@endo/platform/fs/lite`
   or move into `@endo/daemon-cas`?
2. Does `@endo/daemon-cas` export the raw `ContentStore`
   factory separately from the daemon-shaped variant, to
   leave room for a future `@endo/git-cas` reuse?
3. Does the `Sha256` type alias in `daemon/src/types.d.ts`
   move? (Researcher recommends keeping `string` in the
   new package's public types since git OIDs are not
   SHA-256.)

Designer addresses each in the implementation (or documents
in PR body's design-departures section).

## Task — extract daemon-cas

In your `project/` worktree on `feat/registry-capability`:

1. **Read** researcher result + the cited files.
2. **Create** `packages/daemon-cas/` package mirroring
   `packages/registry-capability/`'s shape:
   - `package.json` (name `@endo/daemon-cas`, workspace
     export `.`)
   - `index.js` (exports `makeContentStore`)
   - `src/content-store.js` (moved `makeContentStore`
     closure)
   - `types.d.ts` (reuse / re-export `ContentStore` from
     `@endo/platform/fs/lite/types`)
   - `tsconfig.json` / `tsconfig.composite.json`
3. **Move** `makeContentStore` from
   `packages/daemon/src/daemon-persistence-powers.js` to
   the new package's `src/content-store.js`.
4. **Update daemon imports** to use `@endo/daemon-cas`
   instead of local. The single consumer in `daemon.js`
   line 330 needs the import path swap.
5. **Update the XS supervisor** if its CAS wiring needs
   adjustment (`bus-daemon-rust-xs.js`).
6. **Move tests** (if any test exercises the CAS surface
   directly) to the new package's `test/`.
7. **Update `packages/skel/` uniformity** if needed.
8. **Run**:
   - `corepack yarn workspace @endo/daemon-cas test`
   - `corepack yarn workspace @endo/daemon test`
   - `corepack yarn build`
   - `corepack yarn lint`
9. **Run pre-push-gates** in `project/`.
10. **Commit** per logical step (one commit per extraction
    sub-step or a single coherent commit, designer's call):
    - Create skel: `chore(daemon-cas): bootstrap new
      package`
    - Move closure: `refactor(daemon-cas): factor
      makeContentStore out of daemon-persistence-powers`
    - Update consumer: `refactor(daemon): consume
      @endo/daemon-cas`
    - Yarn-lock: `chore: Update yarn.lock`
11. **Push** to `feat/registry-capability` (append push
    only).
12. **Reply on the review** (top-level comment on PR #403
    if review-replies unavailable) at-mentioning
    `@kriskowal`:
    - The 3 open-question decisions.
    - File-by-file change summary.
    - That this is the "temporary, intermediate step"
      en route to git-cas (per maintainer framing).
13. **Re-request review** from kriskowal.

## Authorizations

- **Push commits** to `feat/registry-capability` (append
  push only).
- **Top-level comment** on PR #403 at-mentioning kriskowal.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT pursue git-cas drop-in (that's the next step).
- Do NOT touch unrelated packages.
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/`
naming:

- Pre/post head SHAs.
- Per-commit summary.
- The 3 open-question decisions + rationale.
- File-by-file change summary.
- Test results per workspace.
- pre-push-gates result.
- The reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` for gamut
  re-run on the extended scope.

End your turn with a concise summary back to the orchestrator.
