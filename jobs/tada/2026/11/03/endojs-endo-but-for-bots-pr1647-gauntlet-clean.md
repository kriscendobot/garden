The clean stage is done for endojs/endo-but-for-bots#1647, and CI is green: all 36 checks finished with no failures.

- **Starting state:** the PR (`feat/ocapn-advertise-addr`, head `a8af366b`, base `llm-48d6f3e`) is a draft. When I claimed the job, CI was still running, so the stage couldn't be skipped.
- **Coverage:** I read the PR diff, which touches `daemon/src/networks/ocapn.js`, `ocapn-noise/src/transports/tcp.js` and the daemon tests. The new `ocapn-advertise-addr` handling is already tested:
  - one end-to-end test checks that the advertised host appears in the hints and the location, that the stored listen address is still the bound one, and that a peer can dial the advertised name and complete the handshake;
  - one test checks that a malformed address and a mismatched port are both rejected.
- **Dead code:** the change leaves nothing unused, so I pushed no commits.
- **CI:** my first wait with `ci-wait-merge.sh` was run in the background and was cut off at its 10-minute limit. I re-ran it in the foreground in roughly 10-minute slices. The first slice ended with CI still pending (rc 4); the second ended green (rc 0) once the four `test` jobs (22.x and 24.x, on ubuntu and macos) completed. That was well within the 3600-second limit.

Follow-ups (optional, not blocking):
- No test covers the bracket-stripping for an IPv6 advertised host (`[::1]`).
- `ocapn-noise`'s `makeTcpTransport({advertiseHost})` is only tested through the daemon tests, not by a test of its own.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1647-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (432610 cached reads)
- Output: 2418 tokens
- Cost: $0.547314
- Wall-clock: 2298s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
