# reproduce ymax0 v320 70->71 XS overflow on REAL chain state + verify the hex fix

Source: maintainer directive on kriskowal/garden#9
(https://github.com/kriskowal/garden/issues/9#issuecomment-4838594481):
"reproduce the issue on real chain state, but more importantly verify that
the hex fix addresses the issue. Please continue."

This is the REAL-CHAIN cross-check. Prior work already confirmed the fix
against the synthetic stock xsnap-worker (control overflows exit 12, patched
OK). This job runs the production-shaped reproduction through inquisitor on a
captured mainnet swing-store. Follow `skills/agoric-chain-snapshot/SKILL.md`
end to end; it is the canonical procedure.

## Scope (hard)
Bot fork `kriscendobot/agoric-sdk` and bot-owned forks only. NO upstream
`agoric/agoric-sdk` interaction (no comments, reviews, cross-references, or
issue/PR opens/closes), per roles/COMMON.md External-repo etiquette.

## Steps
1. Capture a swing-store: prefer `--use-cached`, else `--from-host` a peer,
   else a fresh Polkachu pull. Tools needed on a bare host:
   `sudo apt-get install -y lz4 sqlite3 rsync wget`.
       scripts/agoric/fetch-polkachu-snapshot.sh --vacuum
   The snapshot caches under $GARDEN_SNAPSHOT_CACHE with a provenance.json
   sidecar (gitignored, survives across jobs). This is a tens-of-GiB stream;
   budget for a long-running download and resume with --download if it drops.
2. Build inquisitor's host in a kriscendobot/agoric-sdk worktree:
   `node .yarn/releases/yarn-4.12.0.cjs install --immutable` (expect the
   non-fatal better-sqlite3 native warning + two standing chain-utils.js tsc
   errors; filter as sandbox artifacts).
3. Run inquisitor against the captured swingstore.sqlite; inject the real v320
   ymax0 contract bundle and run the core-eval (Agoric/agoric-sdk#11282 recipe
   in the skill).
   - Control (stock bundle-ymax0): expect `exited: stack overflow`.
   - Patched (hex.js flatMap->loop; bot fork PR #7 /
     debug/xs-stack-overflow-methodology): expect install + completion.
4. Report the real-chain result as a comment on kriskowal/garden#9 (the
   established reply channel for this issue), citing the captured host.height,
   the snapshot provenance, and the control-vs-patched outcomes. Leave the
   issue open for the maintainer to close.

## Notes
- The cache + provenance + socialization infra and this procedure landed on
  main2 in job `kriskowal-garden-pr9-469d82c6` (the attention-routing job that
  posted this one).
- This is a multi-hour, network- and build-heavy job. If a gardener claim is
  reaped mid-download, the resumable --download archive and the height-keyed
  cache make a re-claim cheap (it resumes / reuses, no full re-stream).
