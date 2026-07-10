The job is genuinely complete. All deliverables are in place and verified by real execution.

## Completion report — `xst-integrate-variant-bump`

**issue_spine:** issue-kriskowal-garden-33
**Draft PR (fork, same-repo):** https://github.com/kriscendobot/agoric-sdk/pull/13
**Branch:** `kriscendobot/agoric-sdk` → `xst/integrate-variant-bump` (base `master`)

### What I did
Merged the two mirrored branches — **#11** (`xst/xsnap-variants-11031`, the `variant` seam in `resolveXsnapWorkerPath`) and **#12** (`xst/moddable-5.5.0-11297`, the 5.5.0 from-source build) — onto a new branch off `master`, then made the build system **variant-aware** to resolve the core conflict: #12's from-source build wrote the **unprefixed** `xsnap-native/` tree, which is exactly the tree `resolveXsnapWorkerPath` maps to `legacy`. Merged naively, Moddable 5.5.0 would have landed under existing, snapshot-bound vats. The integration routes each engine to its own tree.

| variant | mechanism | tree | engine |
| --- | --- | --- | --- |
| `legacy` (default) | prebuilt fetch (`install-prebuilt.js`, unchanged) | `xsnap-native/` | today's snapshot-compatible XS |
| `latest` | from-source (`build.js --variant latest`) | `latest/xsnap-native/` | Moddable 5.5.0 / XS 16.7.1 |

### What changed (net diff: 18 files, +733/−33 vs master)
- **`src/build.js`** — parses `--variant legacy|latest`; a `latest/` path prefix (mirroring `xsnap.js`'s `variantPrefix`) routes fetch + compile + binary into `latest/{moddable,xsnap-native}`. Pins resolve from `build.<variant>.env` then `build.env`. Force-rebuild check now interrogates the variant's own subtree (removed the now-dead `isRejected` helper).
- **`scripts/get_xsnap_version.sh`** — optional `legacy|latest` arg selects the subtree.
- **`package.json`** — `postinstall` = `install:prebuilt` (legacy) && `build:latest` (from source); `files[]` source globs repointed to `latest/`; `clean` wipes both build dirs; added `check-version:latest`.
- **`tsconfig.build.json` / `tsconfig.quickcheck.json` / `.prettierignore`** — exclude the `latest/` vendored engine source.
- **`README.md`** — documents the two-variant provision.
- Plus the carried content from both merges (variant seam, `.dockerignore` `latest/` entries, 5.5.0 build restoration, test adaptations, tsconfig excludes).

### Verified by real execution (Linux x64)
Ran the actual `resolveXsnapWorkerPath` source from `packages/xsnap/src/` and spawned each resolved binary with `-v`:
```
legacy  resolves -> .../packages/xsnap/xsnap-native/.../release/xsnap-worker  -> xsnap 0.14.2 (XS 13.3.0)
latest  resolves -> .../packages/xsnap/latest/xsnap-native/.../xsnap-worker   -> xsnap 0.14.2 (XS 16.7.1)
```
`legacy` was installed via the unchanged prebuilt path (`node src/install-prebuilt.js`); `latest` was compiled via `node src/build.js --variant latest` (31s, release+debug). Legacy reports the old engine (XS 13.3.0 — note: not the 11.x that #12's report guessed); latest reports XS 16.7.1. Contract #3 satisfied. Build artifacts (`latest/`, `xsnap-native/`, `moddable/`, `build.config.env`) confirmed gitignored and absent from the commit (`git check-ignore`).

### Follow-ups (the `xst-gauntlet` job must chase — intentionally NOT run here)
Recorded in the PR body:
1. **Snapshot regeneration** — `packages/xsnap` + `packages/SwingSet` ava snapshots left at master's values; they will diverge under the 5.5.0 `latest` engine (`yarn test --update-snapshots`).
2. **Golden meter counts** — confirm carried xs-perf counts match this build's output.
3. **A/B divergence harness** — extend the garden's `skills/agoric-chain-snapshot/` flat/flatMap release-A/B repros against the XS 16.7.1 `latest` worker vs. stock.

### Guardrails
Fork-only on `kriscendobot/agoric-sdk`; upstream `Agoric/agoric-sdk` untouched (no comments, links, or pushes); all upstream/PR text treated as data. No `pr-mirrors` note (fork-original work). Inbox drained (empty).
