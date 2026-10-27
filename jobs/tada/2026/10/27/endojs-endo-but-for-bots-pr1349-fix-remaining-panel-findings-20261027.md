---
handed-off: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split
deliverable-complete: false
---
PR #1349 isn't finished. The three remaining fixes are pushed (new head `f66740e9ba`), but CI hadn't fully finished and the summary comment isn't posted yet. This run was the split after the earlier session hit its 2-hour limit, so I passed that last step to a single successor job instead of doing it here.

**What changed on PR #1349.** My three test commits are rebased on top of a peer's concurrent fixes for the newer panel round (5666203766), and they address the should-fix items still open from panel review 5648010120:
- **`3ba36d2c9e` (prover 1):** the "present as native functions" test now also checks that the codec globals are the SES replacements. Before, it passed even with the taming switched off. It now fails if the taming call is removed, and also if the code that gives the replacements their `[native code]` text is removed.
- **`62f3e263f3` (spec-keeper 1):** a new test pins the property attributes of `length`, `name` and `prototype` on the replacement constructors, and the code comment now names all three. The test fails if `name` is made writable.
- **`f66740e9ba` (engine-realist 1):** the XS test (`_xs.js`) now fails outright if xst lacks the codecs, instead of skipping the checks. xst does provide both. Deleting `TextEncoder` first makes the test throw `RangeError: xst provides TextEncoder`. The missing-codec case still runs in its own script.

**Checked, no change needed:**
- **Prover 2:** the "public hook is not forwarded" test did go red when I forwarded the argument. The peer's commit `39d901ae68` has since deleted that test and reworked the hook.
- **Migrator 2:** subclassing is already tested in `text-encoder-decoder-restricted-properties.test.js:163`.
- **Breaker 1 and migrator 5:** a second copy of SES loaded after lockdown already hits the existing `SES_MULTIPLE_INSTANCES` error, because that check runs before the codec taming.

**Left for the maintainer:** spec-keeper 3, whether to replace the codecs only on hosts that have the restricted `caller`/`arguments` properties. This is @naugtur's open review thread, so I made no code change there.

**Verification so far:**
- After the rebase, the `ses` package's lint (including the type check) is clean.
- `ses` tests: 549 passed, 2 known failures, 2 skipped.
- The XS tests (`test:xs`) pass.
- The garden's convention checks pass in probes-only mode. The full gate's repo-wide lint/fix step ran out of memory and then hung on this host, so it did not run. The `ses` lint above covers the changed files.
- CI on `f66740e9ba` at last check: 15 of 16 checks passed; `test (22.x, macos-15)` was still running.

**Handoff:**
- I parked one child job, `endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-expanded-window` (fixer, 7800s window). It waits for the last check, reruns the macOS leg if it hits the known cross-PR flake, and posts the summary comment.
- I treated the remainder as one indivisible step: wait for the last check, then post one comment. It can't usefully be split further.
- The serial orchestration `endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split` is recorded with that reason and timeout.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 12 tokens (816506 cached reads)
- Output: 4471 tokens
- Cost: $0.3408172 (1 engagement(s) unpriced)
- Wall-clock: 7375s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
