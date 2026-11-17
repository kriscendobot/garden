I built phase 2 of the endopi JSONL transcript design (the Lal wiring) and opened it as draft **endojs/endo-but-for-bots#1670**. The full Lal test suite passes locally. On CI the only failure so far is `test-xs`, which is unrelated to this change, and seven longer test/cover legs had not finished when I stopped.

**What it does**
- **The mount:** Lal's `setup.js` now creates a host scratch mount named `transcripts-for-lal`. The daemon's `provideScratchMount` makes a brand-new mount every time it's called, so the code reuses the existing name rather than overwriting it.
- **The writer:** a new file, `packages/lal/transcript.js`, connects the existing transcript library to that mount without changing the library. It writes each completed `user`, `assistant` or `toolResult` message as one linked line, plus a line recording the ids of the mail message that started the turn. Entry ids are UUIDv7.
- **Restart:** when a worker starts, it picks up its newest session file, repairs a half-written last line, and seeds its conversation from the recorded messages. After that it appends only new messages. A `fresh: true` option starts a new file instead.
- **Isolation:** the Lal manager keeps the writable mount to itself. The model's tools run on per-worker sub-guests, and none of them is ever given the mount, so a model cannot rewrite its own history. A failed transcript write is logged and does not stop the worker.
- **One mount per agent:** the worker's name is part of each session file's name, so one mount holds every worker's sessions without mixing them. This follows the design's suggested answer to its open question 3.
- **Smaller wiring:** `inbox-loop.js` now passes the mail ids into each round. `@endo/jsonl-transcript` is a new dependency of `@endo/lal`, with a separate `chore: Update yarn.lock` commit and a minor changeset.

**Testing**
- I added `packages/lal/test/transcript.test.js`, with 6 tests against an in-memory mount. They cover:
  - a fresh session
  - restart and resume
  - torn-tail repair
  - workers sharing a mount
  - `fresh` starting a new file
  - name reuse
  - UUIDv7 shape
- Locally the whole `@endo/lal` suite passes (203 passed, 1 skipped), with no type, eslint or prettier errors.
- **CI:** lint passed, and so did the other checks that had finished.
  - The `test-xs` failure is the known hardened262 / Node 26 LTS baseline drift: `sesNode/module` `ThrowTypeError/intrinsic-metadata.js` flips from pass to fail. `llm` doesn't have the fix yet.
  - The seven pending legs are the gauntlet's to follow up.

**Follow-ups**
- **Isolation test:** nothing yet runs a real daemon to prove a worker sub-guest cannot look up the writable mount. Today that holds only because the sub-guests are created without the name.
- **Design review:** the design PR #1669 is still going through its gauntlet. If its review changes how transcripts are exposed, #1670 should follow it.
- **Later phases:** the `endo session` CLI (3), Fae and the Familiar (4), the Chat viewer (5) and compaction (6) each need their own build job.
- **Budget estimate:** the designer asked for one for the multi-job build, and I didn't file it.
- **#692:** the design records it as superseded, and it is still open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-jsonl-transcript-format.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5007225 cached reads)
- Output: 31883 tokens
- Cost: $2.559505
- Wall-clock: 1982s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
