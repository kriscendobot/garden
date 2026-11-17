Fix round 2 for PR #1670 is pushed and CI is green: all 36 checks pass. Getting there took one rerun of the 22.x ubuntu test leg, because an unrelated test failed (details under CI).

**What I fixed.** There was no pre-pass block, so I worked from the latest panel review (5944623896). Two follow-up commits, `0cdaaa0885` and `0b8d55e80d`, were pushed with `safe-push-pr-head.sh` (head moved from `780bc28057` to `0b8d55e80d`):

- **One worker could resume another's transcript** (warden, saboteur, breaker, wire-watcher). Session ids now start with `w<hex of the UTF-8 worker name>--`. The lookup matches that key right after the timestamp, and only resumes a file whose header `endo:worker` is exactly that worker's name. This stops collisions like `a` vs `x_a`, or names that turned into the same slug before.
- **Clock and random source** (engine-realist). Lal is loaded through `makeUnconfined`, which runs in the start compartment, so `Date.now` and `crypto` are the real ones. Even so, `uuidv7` now throws on a NaN, negative, or over-48-bit clock, or a missing `crypto`, rather than producing a bad id. It also uses BigInt to split the timestamp, and the random filler can be passed in.
- **The agent wiring had no test** (prover). I moved it into `makeTranscriptRoundRunner` in `transcript.js`, and `agent.js` now calls that. New tests with a fake agent show that a failed round is still recorded, a restart appends only new messages, and a transcript write error is logged without stopping the worker.
- **A failed write marked the message as recorded anyway.** A message now counts as recorded only after its write succeeds, so the next round retries it in order. There's a test for this.
- **`messageId` type mismatch** (typist and others). The type in `inbox-loop.js` uses the real field name `messageId` again. The shared types `TranscriptMail`, `TranscriptMount` and `WorkerTranscript` are declared once, in `agent.types.d.ts`.
- **Other review points:**
  - The returned transcript object is hardened, and `seedMessages` hands out a copy.
  - The deleted `eslint-disable` comments stay deleted, since eslint reports them as unused. I removed the blank lines they left.
- **Docs:**
  - Rewrote "Session Management" in `LAL-ARCHITECTURE.md` and the README note.
  - Gave the design doc a Status section and updated its index row.
  - Fixed the "§ Writer" reference and trimmed the changeset.
- **No change needed** (packager):
  - The composite tsconfig check reports everything up to date.
  - `@endo/lal` and `@endo/jsonl-transcript` are both private, so the new dependency doesn't make anything uninstallable.

**Local checks:** the lal tests pass (210, 1 skipped). `tsc` for the package and the repo root, eslint, prettier and the composite tsconfig check are all clean. I posted what changed for each finding on the PR: https://github.com/endojs/endo-but-for-bots/pull/1670#issuecomment-6961822480

**CI:** the first run failed only in `@endo/sandbox`: the bwrap test "timeout and repeated cancellation reap process groups". This PR doesn't touch that package. I reran the failed leg and it passed. My first CI wait was cut off by the background time limit, so I finished waiting in roughly 10-minute foreground windows until the checks completed.

**Not done:**
- No test drives `runInboxLoop` end to end to check the mail fields it passes; it's only covered by the fixed type.
- The panel's other non-blocking points are untouched: splitting the hardened262 baseline commit out, squashing the earlier refactor commit, and shortening the PR body.

The PR stays draft; panel-3 is next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1670-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (8174473 cached reads)
- Output: 36648 tokens
- Cost: $3.4670226
- Wall-clock: 7935s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
