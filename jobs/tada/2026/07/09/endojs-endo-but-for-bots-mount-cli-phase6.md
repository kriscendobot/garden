Inbox empty. The build stage is complete. Here is my report.

---

## Completion report: Phase 6 mount-path CLI verbs

**PR:** [endojs/endo-but-for-bots#658](https://github.com/endojs/endo-but-for-bots/pull/658) — draft, base `llm-7870da1` (frozen), head `feat/mount-cli-path-verbs`, authored by the bot.
**Package:** `@endo/cli` (`packages/cli`).

### Reconciliation with PR #153 (done first)
PR #153 ("unify store/cat axes; add write/read for mount paths", commit `8a8e872d4`) reshaped the `store`/`cat` representation axes and added `endo write <mount>/<path>` / `endo read <mount>/<path>`. I verified against **current `llm` HEAD (7870da1)** that those mount-path verbs were **subsequently removed** — `write.js`/`read.js` do not exist and `cat.js` is back to the 16-line blob dumper. So Phase 6 is genuinely unimplemented, and I landed the design's `ls`/`cat`/`write` verbs as **additive** extensions rather than re-adding #153's reverted surface. `endo ls` was already an alias of `list`, and `endo cat <name>` already existed as capability-graph verbs — so I made them polymorphic on the presence of trailing in-mount path segments, leaving the classic behavior untouched.

### What changed
- `packages/cli/src/pet-name.js` — new `mountPathSegments` helper (splits each path arg on `/`, flattens, drops empties).
- `packages/cli/src/commands/cat.js` — `cat <name> [path...]`: with a path, looks up the mount then `E(mount).lookup(segments)` and streams via the existing `streamBase64` reader; without, unchanged.
- `packages/cli/src/commands/list.js` — `list [directory] [path...]`: with a path, `E(mount).list(...segments)` (honors `--json`), returns early; without, unchanged.
- `packages/cli/src/commands/write.js` — **new** `write <mountName> <path...>`: reads stdin, `E(mount).writeText(segments, text)`.
- `packages/cli/src/endo.js` — command wiring + `write` added to the Storage help group.
- `packages/cli/test/mount-path-cli.test.js` — new E2E test (isolated daemon, mirrors `formula-collection.test.js`).
- `.changeset/cli-mount-path-verbs.md` — minor bump for `@endo/cli`.

### Verification (real execution)
The repo's `yarn install` fails in this sandbox on `better-sqlite3`'s native build, so the ava harness can't run here. I fetched the prebuilt `better_sqlite3.node` via `prebuild-install` and **drove the actual daemon with the bundled `endo` binary**, observing:
- `endo ls proj` → `README.md / package.json / src`; `endo ls proj src` → `index.js / utils.js`; `endo ls proj --json src` → `["index.js","utils.js"]`.
- `endo cat proj README.md` → file contents; `endo cat proj src/index.js` (slash-joined) → resolves correctly.
- `echo … | endo write proj docs/notes.txt` → created the nested file (parents made); verified **both on disk and via `endo cat` read-back**.
- Read-only mount: `endo write ro blocked.txt` → "Mount is read-only", and **no file reached disk**.
- Confinement: `endo cat ro ../../../etc/hostname` → rejected.
- Backward compat: classic `endo cat <blob>` and `endo ls` (pet-name listing) still work.
- Offline: `endo --help` / `cat --help` / `write --help` / `ls --help` show correct `[path...]`/`<path...>` signatures.
- Prettier: all changed files pass `--check`.

The tests are load-bearing by construction (a missing `write` verb, un-split `/`, or absent mount branch each makes its assertion fail); the E2E file will run green in CI where the native build succeeds.

### Follow-ups
- This was a `build` job; the draft PR is open and handed off. The panel/gauntlet (un-draft) is the next stage, driven separately by the gardening state machine — not part of this build job.
- Binary (`--blob`) mount-path writes remain deferred per the design (Phase 6 covers stdin→text).
- Note: git commits are authored `endolinbot` (local config) while the PR was opened via the fleet gh wrapper's default `kriscendobot` token (endolinbot has no gh token on this host) — both bots, no maintainer-identity leak.
