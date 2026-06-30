---
created: 2026-06-30
updated: 2026-06-30
author: gardener
---

# Skill: agoric-chain-snapshot

Obtain a real Agoric mainnet swing-store and feed it to **inquisitor** to
reproduce, and verify a fix for, a contract-upgrade failure on real chain state.
This is the lever for kriskowal/garden#9: the ymax0 v320 incarnation 70->71
upgrade aborts when the contract bundle is installed, because building the
`@agoric/internal/src/hex.js` `decodings` table with a wide `.flatMap(...)`
materializes ~1,024 live reference slots and tips the XS value stack past its
fixed 4,096-slot budget. The fix replaces that `.flatMap(` with a
`new Map` + `for` + `.set()` loop. Prior work confirmed the fix against the
**stock prebuilt xsnap-worker** (synthetic); this skill is the **real-chain
cross-check** through inquisitor on a captured mainnet swing-store.

All of this stays on the `kriscendobot/agoric-sdk` fork and bot-owned forks.
Nothing here touches upstream `agoric/agoric-sdk`: no comments, no reviews, no
cross-references, no issue/PR opens or closes. See `roles/COMMON.md`
§ External-repo etiquette, *Project scope: agoric/agoric-sdk*.

## The two capture scripts

- `scripts/agoric/fetch-polkachu-snapshot.sh` — **bot-runnable, no credentials.**
  Pulls a public Polkachu Agoric snapshot (`agoric_<height>.tar.lz4`), extracts
  ONLY the `data/agoric` subtree (the Tendermint databases stream past
  unwritten), reads `host.height`, runs `PRAGMA integrity_check`, and with
  `--vacuum` writes a standalone WAL-free `swingstore.sqlite`. Prefer this.
- `scripts/agoric/fetch-chain-snapshot.sh` — pulls a `data/agoric` swing-store
  off a **follower over ssh**. Needs follower credentials the bot does not have,
  so it is the operator's path, not the bot's.

## Where the cached snapshot lives (check here first)

A snapshot is tens of gigabytes over the wire, so `fetch-polkachu-snapshot.sh`
defaults its output into a **per-host cache directory that is not checked into
git** and survives across jobs:

```
$GARDEN_SNAPSHOT_CACHE
  (default: ${GARDEN_STATE:-$HOME/.garden-state}/cache/agoric-snapshots)
```

laid out one directory per snapshot height: `<cache>/agoric-<height>/`. Inside
each is the extracted `data/agoric/swingstore.sqlite`, the optional vacuumed
`swingstore.sqlite`, and a `provenance.json` sidecar (next section).

This path is under `$GARDEN_STATE` (`$HOME/.garden-state`), which the garden's
`.gitignore` already excludes as a top-level dotfile, so the cache can never
enter tracked history or block a watchman fast-forward. **Before re-pulling from
Polkachu, look here**: if a valid `swingstore.sqlite` for the height is already
present the script reuses it (`--refresh` forces a re-download), and
`--use-cached` reuses the newest cached snapshot with no network resolution at
all. If the cache is empty, that is expected on a fresh host (each host keeps its
own cache); fetch once or socialize a copy from a peer (below).

## Provenance: the metadata sidecar

Beside the cached swing-store the script writes `provenance.json` recording
exactly what the artifact is and when it was acquired:

```json
{
  "schema": "agoric-snapshot-provenance/1",
  "source": "polkachu",
  "source_url": "https://snapshots.polkachu.com/snapshots/agoric/agoric_<height>.tar.lz4",
  "snapshot_height": "<height>",
  "host_height": "<host.height from kvStore>",
  "swingstore_sha256": "<sha256 of swingstore.sqlite>",
  "swingstore_bytes": "<size>",
  "acquired_at": "<UTC ISO timestamp>",
  "acquired_by_host": "<GARDEN identity>",
  "acquired_by_tool": "scripts/agoric/fetch-polkachu-snapshot.sh"
}
```

Read it to confirm a cached artifact's height and age before trusting it. A
chain-tip snapshot is fine for this reproduction (inquisitor injects the bundle
and runs the core-eval against whatever swing-store it is handed; the exact
historical upgrade height is not required), but the sha256 and `acquired_at`
let a later reader tell two captures apart and decide whether to refresh.

## Socializing a copy across hosts (gentler than Polkachu)

The garden runs on multiple hosts and any one host may not hold a given
snapshot. Pulling a copy from a **peer host's cache** is far gentler on Polkachu
than re-streaming tens of gigabytes:

```
scripts/agoric/fetch-polkachu-snapshot.sh --from-host kriscendobot@<peer-host> --vacuum
```

`--from-host` rsyncs the peer's `$GARDEN_SNAPSHOT_CACHE` into this host's cache
(`--ignore-existing`, so a snapshot already held is not reclobbered), then takes
the `--use-cached` path with no Polkachu request. It needs `rsync` and ssh
reachability to the peer (the same path `fetch-chain-snapshot.sh` already
assumes between hosts). If the peer's cache path differs, point at it through
the peer's `$GARDEN_SNAPSHOT_CACHE`. Re-pull from Polkachu only when no peer
holds the snapshot.

## Procedure

1. **Try the cache / a peer first.** `--use-cached` if this host has one;
   `--from-host <peer>` to socialize; only then a fresh Polkachu pull.
2. **Prerequisites for a fresh pull:** `curl`, `lz4`, `tar`, and (for `--vacuum`
   / inspection) `sqlite3`; `rsync` for `--from-host`; `wget` for `--download`.
   On a bare host: `sudo apt-get install -y lz4 sqlite3 rsync wget`.
3. **Capture:**
   ```
   scripts/agoric/fetch-polkachu-snapshot.sh --vacuum
   ```
   The full ~tens-of-GiB stream is downloaded (tar cannot seek a single
   compressed stream); only `data/agoric` lands on disk. `--download` saves a
   resumable archive first so extraction can be retried without re-streaming.
4. **Build inquisitor's host** in a `kriscendobot/agoric-sdk` worktree (vendored
   yarn, immutable install): `node .yarn/releases/yarn-4.12.0.cjs install
   --immutable`. Expect a non-fatal `better-sqlite3` native-build warning and two
   standing `chain-utils.js` cosmic-proto `tsc` errors (sandbox artifacts, not
   regressions) per the `build-agoric-internal-hex` notes.
5. **Reproduce + verify the hex fix** against the captured swing-store:
   ```
   node packages/cosmic-swingset/tools/inquisitor.mjs <cache>/agoric-<height>/swingstore.sqlite
   ```
   then in the REPL load the bundle and run the core-eval (Agoric/agoric-sdk
   #11282):
   ```
   void( fs = await import('fs') );
   Object.keys( bundle = JSON.parse(fs.readFileSync("/tmp/ymax0-bundle.json","utf-8")) );
   await swingStore.kernelStorage.bundleStore.addBundle($bundleID, bundle);
   await runCoreEval(fs.readFileSync("/tmp/ymax0-core-eval.js","utf-8"));
   ```
   - **Control** (stock real v320 `bundle-ymax0`) should abort with the XS
     value-stack overflow (`exited: stack overflow`).
   - **Patched** (the `flatMap`->loop `hex.js`, bot fork PR #7 / the
     `debug/xs-stack-overflow-methodology` branch) should install and complete.
   The patched/control delta is exactly one `.flatMap(` removed (10->9) in the
   flattened `portfolio.contract.bundle.js`.

## Notes

- **Wire vs disk:** the `data/agoric` filter saves disk, not bandwidth. The
  whole archive still streams over the wire because tar cannot seek a single
  `.tar.lz4`.
- **Residual caveat on the fix:** the loop rewrite drops ~1,024 reference slots
  but leaves the ~2,000-closure flat-functor baseline, so a future module-scope
  widening could re-trip the stock stack. The durable remedy is the
  `bundle-source`/esbuild sub-module-functor lever, not this patch. Recorded on
  the methodology doc (`kriscendobot/agoric-sdk#6`).
- **Scope:** read-only analysis plus on-host runs of the open-source XS worker
  and the public bundle, on bot forks only. No upstream `agoric/agoric-sdk`
  interaction.
