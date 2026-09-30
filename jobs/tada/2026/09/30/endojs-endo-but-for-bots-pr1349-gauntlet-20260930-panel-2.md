Panel round 2 on PR #1349 came back **must-fix**. `panel.sh` exited 0 in single-round mode.

**Review:** I posted the verdict as review 5361062713: https://github.com/endojs/endo-but-for-bots/pull/1349. A request-changes review was refused because the bot can't request changes on its own PR, so it went up as a COMMENTED review. That is the same shape round 1 used. It starts with a round-2 must-fix header and then gives every seat's verdict in full.

**What was reviewed:** head `9b3f9a9bd9` against base `6ee3fda77b` (`master-6ee3fda`), in an isolated checkout. The run directory is `scratch/tmpexec/garden-panel-project-wt-endojs--309ea4cc52d8-3ef03ade-1349`, and the run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1349/1d27302a9836.md`.

**Results:** Of 32 seats, 3 asked for changes, 8 were comment-only and 21 approved. The round-1 must-fix (PR body not following the template) is fixed. The three requests:
- **prover:** the XS test checks that the `TextEncoder`/`TextDecoder` prototypes are frozen, but not the constructors themselves. The sibling Node test (`text-encoder-decoder.test.js`) checks both. The PR body also has no note saying the new assertions were seen to fail when the code was deliberately broken and pass again once it was restored.
- **engine-realist:** if the XS host has no codecs, the conditional checks are skipped and the test still prints `ok`. It should print which branch ran, or assert what the XS host is expected to have. Its premise that `xst` lacks the codecs contradicts the PR body, which says the current `xst` defines both. The fix loop should weigh that.
- **scribe:** no top-level summary comment followed the push that answered round 1 (`9b3f9a9bd9`).

**Non-blocking follow-up** (corner-prober and others): add a test that actually encodes and decodes text from inside the compartment, not just an identity check.

**Other:** the phase/evidence pre-pass couldn't find the PR body or its governing design. The panel reported this as non-fatal and the run completed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (661884 cached reads)
- Output: 4062 tokens
- Cost: $0.6934248000000001
- Wall-clock: 476s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
