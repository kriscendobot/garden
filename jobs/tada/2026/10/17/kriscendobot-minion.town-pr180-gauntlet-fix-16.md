# Gauntlet FIX round 16 — kriscendobot/minion.town#180: two fixes pushed, CI green

I fixed both of the round-16 panel's blocking findings, which came from the breaker seat. CI passed on the new head `d9b9dd09778`.

**What changed** (two follow-up commits on `design/git-remote-endo-binding`, pushed with `safe-push-pr-head.sh` in advance mode, `d7e92d8..d9b9dd0`):

1. **`292a6e5` fix(git-remote): give each attenuation its own live-URL budget.**
   - **Problem:** a holder of only the read-only facet could mint 256 read URLs and fill the shared per-partition cap. The readwrite holder could then no longer mint, and could not revoke those URLs either, because only the minter gets each URL's `tokenHash`.
   - **Fix:** `partition-store.ts` `mint` now counts the cap separately for read and readwrite URLs, and the error message names which one is full.
   - **Test:** the cap test in `test/git-remote/capability.test.ts` now checks that a full read budget leaves readwrite minting open.
2. **`d9b9dd0` fix(git-remote): bind the /hello proof to the listener's port.**
   - **Problem:** the proof the listener returns covered only the caplet's random nonce. A process on another port could forward `/hello` to the real listener and pass the genuine proof back to the caplet.
   - **Fix:** `serverProofFor` now also covers the port the listener accepted the request on (`request.socket.localPort`). The caplet checks the proof against the port it dialed, so a forwarded proof no longer matches.
   - **Docs:** the comment on `serverProofFor` in `control-keys.ts` describes this and states the remaining limit: a relay on the caplet's own port is out of scope.
   - **Tests:** the expected proofs in `control.test.ts` are updated. A new test in `git-caplet.test.ts` puts a forwarding server in front of the real listener and checks that the caplet refuses it and sends no credential.

**Verification:**
- `tsc --noEmit` is clean.
- `vitest test/git-remote`: 123 of 124 pass. The one failure ("propagates a git failure…", which expects git to exit with code 128) also fails on the unmodified head `d7e92d8`, so it comes from this machine's environment, not this change.
- The daemon integration suite is skipped locally.
- `ci-wait-merge.sh` returned rc 0. All three checks passed (test, Claude harness amd64 and arm64).

**Follow-ups:**
- I left the comment-only and should-fix items from other seats alone. They include:
  - the hand-rolled hex codec (purist)
  - the duplicated owner-header constant name (stylist)
  - the stricter `portFrom` decimal parsing
  - the `/hello` JSON error page
  - the `control.ts` header wording for `create`
- The round-14 decomplector seat asked for maintainer confirmation of the bespoke HTTP control plane before more fix rounds. That question is still open, and these fixes add to that mechanism.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-16.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1710832 cached reads)
- Output: 12678 tokens
- Cost: $1.9190064000000002
- Wall-clock: 928s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
