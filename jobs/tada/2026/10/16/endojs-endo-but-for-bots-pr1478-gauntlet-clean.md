The clean stage for endojs/endo-but-for-bots PR #1478 is done: I added one missing test, pushed it to the PR head, and CI is green at the new head (`11664d0e4`).

- **Coverage pass:** I ran c8 over the `ocapn-noise` test suite (91 tests passing) with coverage on `src/network.js`. Most of the PR's new code was already tested. The one real gap was the session queue's handling of a transport write that fails: nothing tested that it surfaces the error to the reader and closes the session.
- **Test added:** in `packages/ocapn-noise/test/session-queue.test.js`, "a transport write that rejects ends the session with its error". It makes the transport's writes fail once the session is up, then checks that the reader throws that error and later writes come back `done`. A second coverage run shows that path is now exercised. eslint, `tsc` and prettier all pass.
- **Still untested, left as is:** the empty default functions for `resolveClosed` and `enqueueFrame`, and the `if (closed) return` guards in `fail` and `enqueue`. These are defensive checks that ordinary operation doesn't reach, so I didn't write tests for them.
- **Dead code:** none. The change already replaced the old `sendFrame` rather than leaving it behind.
- **Push and CI:** pushed with `safe-push-pr-head.sh`, moving the head from `2a16357ea` to `11664d0e4`. `ci-wait-merge.sh --no-merge` returned 0 (35 checks, 0 failed). The first background run of that script hit its time limit and was stopped; I polled CI in the foreground instead and confirmed with a final run.

No follow-ups. The PR is still a draft, and un-drafting is a later gauntlet stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1297602 cached reads)
- Output: 7861 tokens
- Cost: $0.9268124
- Wall-clock: 2267s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
