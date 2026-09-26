The work is complete and verified. Container stable (Up 5 minutes, 0 restarts), both transports published, inbox empty.

## Completion report

**Job:** Dead-lettered issue comment on kriscendobot/garden #58 — maintainer (kriskowal) asked: *"open up port 3469 (pluribus) to listen for TCP CBOR-framed CBOR-encoded Noise Protocol OCapN. Defer `ws://`."*

**What I did (all applied live on the minion.town box `i-0380cd68b90020fad`, us-west-1):**

1. **Diagnosed** that the real Pet-Daemon (`endo-pet-daemon` container) already carries both `@endo/ocapn-noise/transport/{ws,tcp}` in `src/networks/ocapn.js`, each gated on a stored pet-name listen address. It shipped with only `ws-listen-addr` set → WS-only. Enabling TCP was a **config act, not code**.
2. **Stored** `ocapn-listen-addr=0.0.0.0:3469` in the daemon's persisted `/data` pet store (via a small `set-ocapn-listen.mjs` mirroring the boot script's `ws-listen-addr` path).
3. **Recreated** the container to publish `0.0.0.0:3469:3469` (Docker can't hot-add a port); the restart-idempotent boot re-bound `@nets/ocapn` and read the new TCP address. Same volume/env — all daemon state preserved.
4. **Opened** AWS ingress `tcp/3469` on `sg-0f2cf8d86744b7293` (`0.0.0.0/0`), described and authorized per the issue comment (mirrors the existing `tcp/8929` rule).
5. **Verified** round-trip both ways: loopback (`127.0.0.1:3469`) and public path (`minion.town:3469` → public EIP `13.56.17.18` → SG → daemon) both complete the Noise-IK handshake and enliven the `endo-bootstrap` swissnum (`getNodeId = a6cd6e…`, greeter present). WS lanes stay healthy (`/.well-known/ocapn-cbor-np` → 426); `ws://` deferred, not removed.

**What changed / artifacts:**
- Live: TCP+CBOR+Noise netlayer on `minion.town:3469`; SG rule `sgr-031686b0b37f6c0e1`; daemon session `designator` re-minted (`fe55035f…`).
- minion.town **PR #59** (draft): documents the pluribus listener, exact reproducer, SG rule, and dial recipe in `deploy/aws/daemon/README.md`.
- Reply posted on issue #58: https://github.com/kriscendobot/garden/issues/58#issuecomment-5447433329

**Follow-ups (noted, not owned by this job):**
- The listener is not yet CD-provisioned (`ocapn-listen-addr` lives in the `/data` volume; a fresh box needs the steps re-applied — tracked in the README's reproduction gap).
- A genuinely off-box (garden-host) dial needs a built `@endo/ocapn-noise` closure, absent on the garden host; the public-EIP hairpin proof stands in.
- The maintainer's separate comment 5447329184 (driving a guest from the `endo` CLI remotely) is its own thread/job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5447308724.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5000907 cached reads)
- Output: 56499 tokens
- Cost: $5.2486915000000005
- Wall-clock: 955s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
