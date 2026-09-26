The repro job has already been claimed by another gardener (it's in `jobs/doin/`) — the routing worked. Everything is in place. Here's my completion report.

---

## Completion report — `kriskowal-garden-pr9-469d82c6` (attention directive on kriskowal/garden #9)

**Directive (kriskowal, treated as untrusted data and re-fetched):** reproduce the ymax0 v320 70→71 XS overflow on real chain state and verify the `hex.js` fix; and cache the (very large) chain snapshot in a gitignored cache dir with a provenance/date sidecar, note in a skill where it lives, and prefer socializing a copy across hosts over re-pulling from Polkachu.

I split this into the durable in-lane work (delivered now) and the heavy compute (routed as a dedicated job).

### Delivered to `main2` (commit `dbc371bed`)
1. **`scripts/agoric/fetch-polkachu-snapshot.sh` — cache + provenance + socialization.**
   - Output now defaults into a per-host cache that is **not in git**: `$GARDEN_SNAPSHOT_CACHE` (default `$GARDEN_STATE/cache/agoric-snapshots`, already covered by the `.gitignore` dotfile rule), keyed by snapshot height. A valid cached swing-store is **reused** (cache hit short-circuits the ~19 GiB download; `--refresh` forces re-pull).
   - Writes a **`provenance.json`** sidecar beside each cached swing-store: source URL, snapshot height, `host.height`, sha256, **UTC date of acquisition**, and acquiring host.
   - New flags: `--use-cached` (no network at all), `--from-host <peer>` (**rsyncs a peer garden host's cache** before touching Polkachu — gentler than re-streaming on every host that misses), `--refresh`.
   - Syntax-checked, shellcheck-clean, smoke-tested (help, empty-cache failure path).
2. **`skills/agoric-chain-snapshot/SKILL.md`** (new) — documents where the cache lives ("check here first"), the provenance format, the multi-host socialization path, and the full inquisitor recipe for reproducing + verifying the `hex.js` `flatMap`→loop fix. Added to the CLAUDE.md skills inventory.

### Routed (the heavy repro)
Posted **`reproduce-ymax0-v320-real-chain-state-20260630`** to the board for the production cross-check (capture swing-store → inquisitor → inject the real v320 ymax0 bundle + core-eval → compare control-overflow vs. patched-completes). It carries the hard fork-only scope, the tool preflight (`lz4 sqlite3 rsync wget`), and the resume/reuse story. It has **already been claimed** by another gardener (now in `jobs/doin/`). This is a multi-hour, network/build-heavy run, deliberately not ground out inside this attention-routing claim.

### Reported
Posted a concise progress comment on **kriskowal/garden#9** (issue-comment `4838655671`, as kriscendobot — the established reply channel for this thread): the cache/skill landed, the real-chain verification is queued, and a control-vs-patched result will follow there when it completes. No upstream `agoric/agoric-sdk` interaction anywhere.

### Notes / follow-ups
- Context recovered: the "hex fix" is the `@agoric/internal/src/hex.js` `decodings` `.flatMap(`→`new Map`+`for`+`.set()` loop (drops ~1,024 live reference slots). It was already verified against the **synthetic** stock xsnap-worker; the queued job is the **real-chain** confirmation the maintainer asked for.
- This host (endolinbot2) is missing `lz4`/`sqlite3`/`wget`/`yarn`; the repro job documents the apt preflight, and the script's `need()` messages name the packages. The residual structural caveat (flat-functor baseline could re-trip without the bundle-source sub-functor lever) is recorded in the skill.

**Self-improvement:** nothing structural this time. The directive's concrete asks mapped cleanly onto a script change + a skill; the bare-host tool gap and the fork-only scope are encoded in the script and skill rather than a role file. The earlier scope collision (a prior #9 job escalated "Agoric internal hex" as off-limits) is moot since the 2026-06-28 widening authorized fork experimentation.
