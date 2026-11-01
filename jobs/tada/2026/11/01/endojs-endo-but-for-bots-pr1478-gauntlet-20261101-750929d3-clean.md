**Clean stage for endojs/endo-but-for-bots#1478: nothing to change, CI green**

PR #1478 ("feat(ocapn-noise): session outbound queue and stall fault injector", a draft on the head `endojs:build/ocapn-noise-session-queue` at commit `750929d3`) was already in the right shape, so this stage made no changes.

- **CI:** all 35 checks are done: 17 passed, 18 skipped, none failed. `ci-wait-merge.sh --no-merge` returned rc 0 ("CI GREEN").
- **Coverage:** I read the diff instead of running a local coverage tool, so the coverage judgment rests on that reading. The PR already adds `test/session-queue.test.js` and a `test/_stall-injector.js` helper. Between them they test every new code path in `network.js`:
  - writes made while the transport is stalled are queued and sent in order once it recovers;
  - a stalled write that outlasts the session timeout ends the session, even while the peer is still heard;
  - `writer.next` waits when 64 frames are queued, and those waiting writers return `done` if the session ends;
  - a frame queued just as a drain finishes is sent without waiting for a heartbeat;
  - `writer.return` sends the queued frames before closing;
  - a frame that is not a `Uint8Array` or is too long rejects its own write and leaves the session open;
  - closing while a write is held, a transport write that rejects, a queued Node `Buffer` being copied rather than shared, `writer.throw` teardown, and sessions without heartbeats.
- **Dead code:** none left behind. The old `sendFrame` helper and the inline error-and-close code were replaced or moved into `fail`, `enqueue` and `drain`, and nothing unused is left.

I made no commits or pushes, and there are no follow-ups. The gauntlet can go on to the panel review stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (250995 cached reads)
- Output: 1869 tokens
- Cost: $0.520083
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
