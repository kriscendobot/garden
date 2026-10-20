Clean stage for endojs/endo-but-for-bots PR #1513 ("feat(ocapn-noise): add tcp+cbor transport framing with @endo/cbor-frame") is done with no changes. Nothing was pushed: CI is green at the current head and the new code is already covered.

- **PR state:** open, draft, head `21b45842aa`. All 35 checks reached a final state with no failures (the non-success ones were skipped). `ci-wait-merge.sh --no-merge` returned rc=0 (CI GREEN).
- **Coverage pass (from the PR diff):** I did not run the coverage tooling locally. The tests the PR adds in `packages/ocapn-noise/test/network-tcp.test.js` exercise every new path in `src/transports/tcp.js`:
  - the `'cbor'` framing branch and the `tcp+cbor` scheme selection;
  - the `makeTcpCborTransport` wrapper;
  - CBOR frames split across socket writes;
  - rejection of a declared length above the frame cap;
  - netstring `tcp` and `tcp+cbor` running side by side, and a `tcp+cbor` peer refusing netstring-only hints;
  - the updated framing-validation error.

  The connect-hint error messages that now include the scheme are older code; only their message text changed.
- **Dead code:** the change orphaned nothing.
- **Follow-ups:** none. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1513-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158120 cached reads)
- Output: 1584 tokens
- Cost: $0.41247200000000006
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
