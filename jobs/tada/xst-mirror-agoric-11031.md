Job complete.

## Completion report — `xst-mirror-agoric-11031`

**Mirror PR (fork, Draft):** https://github.com/kriscendobot/agoric-sdk/pull/11
**Rebased branch:** `kriscendobot/agoric-sdk` → `xst/xsnap-variants-11031` (base its own `master`)
**Mapping recorded:** `Agoric/agoric-sdk#11031 → kriscendobot/agoric-sdk#11` (`pr-mirrors/Agoric-agoric-sdk-11031.md`)
**Guardrails honored:** fork-only; no comment/link/push to upstream; upstream text treated as untrusted data.

### What I did
1. Fetched upstream PR #11031's head (`refs/pull/11031/head`, 2 commits atop its base) into an isolated project worktree keyed by this job's base.
2. Created `xst/xsnap-variants-11031` and `git rebase --onto origin/master` onto the fork's current `master` (`37a4fa319`).
3. Resolved conflicts (see below), pushed, opened the Draft PR, recorded the mapping.

### The rebase was NON-trivial: submodule → pinned-archive foundation change
Upstream #11031 was written against the **git-submodule** xsnap build. Upstream **#12477 ("replace xsnap submodules with pinned archives") has since MERGED**, deleting that entire foundation on `master`: no `.gitmodules`, no `packages/xsnap/build.env`, no `src/build.js`, no `moddable`/`xsnap-native` submodules. xsnap now installs a **prebuilt binary** (`install-prebuilt.js` + `prebuilt-manifest-sha256.js`, verified against a SHA-256 manifest). Every file both commits touched hit a modify/delete or content conflict.

**Resolution** — kept master's pinned-archive layout; carried only what ports coherently:
- Deleted submodule machinery (`.gitmodules`, `build.env`, `src/build.js`, `latest/`+`legacy/` submodule gitlinks) → **kept deleted**.
- `packages/xsnap/src/xsnap.js` → added the `variant` option (`'legacy'|'latest'`, default `'legacy'`) and threaded it through `resolveXsnapWorkerPath`; `legacy` resolves the **unchanged** unprefixed `xsnap-native/…` path (byte-for-byte, so existing installs are unaffected), `latest` resolves a sibling `latest/xsnap-native/…` tree.
- `README.md` → carried the **# Compatibility** section and the `variant:'latest'` usage example; **dropped** the upstream "# Installation / C toolchain" note (contradicts master's already-documented prebuilt install).
- `.dockerignore` → added the `latest/` variant build tree.
- Docker/`docker.yml`/`Dockerfile.sdk`/`package.json`/`get_xsnap_version.sh` → took master's side (the `MODDABLE_*`/`XSNAP_NATIVE_*` build-args and submodule file entries are gone).
- The 2nd upstream commit ("Upgrade latest variant") only bumped now-deleted files, so it rebased **empty and was skipped** — its pins are preserved in the PR body.

Final diff vs master: 3 files, +38/-4. `node --check` on xsnap.js passes.

### What a follow-up validation/build job MUST re-check (the seam is wired, `latest` is NOT yet functional)
`xsnap({ variant:'latest' })` currently resolves a path with **no binary** — nothing populates `latest/xsnap-native/…`. The follow-up must, on the pinned-archive foundation:
1. Produce a prebuilt **`latest`** xsnap-worker binary from the pins the skipped commit carried — moddable `74aa31cbc464b79133afacbf36bfbb30d6acd2ef`, xsnap-pub `134c8a71c695d5c894718c4d95d0f45a4e4ed902` (legacy ref: moddable `f6c5951fc0…`, xsnap-pub `105bc68620…`).
2. Extend `install-prebuilt.js` + `prebuilt-manifest-sha256.js` to fetch/verify the `latest` binary into `latest/xsnap-native/…`.
3. Make `get_xsnap_version.sh` / `use-github-release-binary.sh` variant-aware.
4. Validate the actual XS snapshot-compatibility contract (legacy reads legacy snapshots; latest runs) — the #33 motivation.

No verification of runtime behavior was possible here (the `latest` binary does not exist yet); reported as **not verified** for that reason. Project worktree torn down on exit; no garden-`main2` changes were needed.
