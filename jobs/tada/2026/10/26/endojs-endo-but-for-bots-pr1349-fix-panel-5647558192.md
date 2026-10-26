I fixed PR #1349 against panel review 5647558192. The new head is `b3fecfbfa1` on `build/hardened-text-codecs-shim`, and CI passed 16/16 on it, including `browser-tests`, `test-xs` and `test-hermes`.

Only the pruner seat requested changes; the other seats were comment-only or approve with some should-fix items. I made five commits in an isolated project worktree:
- **`aba159e8ca` (naming and errors):**
  - `SharedCodec` is now `EncapsulatedCodec`.
  - The three typedefs are now one module-private `HostConstructorShape`, so the type no longer has the same name as its parameter.
  - The JSDoc links the WebIDL interface-object section.
  - The repoint error now carries the original error as `cause`.
  - The comment for missing codecs now names Hermes.
- **`00054d8d32` (comments):** The Chromium endojs/endo#3369 explanation now lives only in `tame-text-codecs.js`, and the other four places point to it. I shortened the `onIntrinsics` JSDoc, removed the narration in `_xs.js`, and made the XS lockdown-shim comment name both Compartment constructors.
- **`8c96be35fd` (tests):** New tests cover:
  - a codec global whose `prototype` is primitive;
  - the public `repairIntrinsics` ignoring a second argument;
  - the codecs printing as `[native code]` and keeping the host `length`.

  I checked that the first two fail when the code they guard is reverted.
- **`7e88fc411c` (docs):** I reverted the unrelated curly-to-straight quote edits in both guides and `reference.md`. I also replaced the link to the bot-fork design PR endojs/endo-but-for-bots#1431 with a one-line reason for the change.
- **`b3fecfbfa1` (changeset):** It now opens with the breaking change, mentions `prototype.constructor` and `instanceof`, covers hosts without the codecs, and describes the XS effect in terms users can see.

I also shortened the PR body as the pruner asked and added a line explaining why Browser Tests now runs on PRs against any base branch. Then I posted the required summary comment: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6408758105

Locally, the full `ses` suite passed (548 tests), as did `yarn lint` (tsc and eslint), prettier, and the pre-push probes. The repo-wide `yarn lint:fix` step in the pre-push gates ran out of memory, so I ran lint per package instead.

**Declined, with reasons given in the PR comment:**
- **Marking the codecs as native functions:** not needed; they already print as `[native code]`, and a test now checks that.
- **Guarding against wrapping twice when lockdown is retried:** the maintainer already called that kind of guard overkill (comment r4214703715).
- **A named error for a non-configurable codec global:** no known host has that shape.
- **Dropping the duplicate paragraph from one of the two guides:** the guides are kept in parallel.
- **Splitting out the CI changes or squashing the `fixup!` commits:** I didn't rewrite reviewed history; the conductor squashes the fixups at merge.
- **Optional extra tests (fast-check, `TextDecoder` label edge cases) and the purist's refactor of the hook:** not taken this round.

I didn't re-request maintainer review, since the next step is the panel re-running on the new head. No garden (`main2`) changes.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `4f8e35f768309d9444a3a8e1951e9ce7771499e2`; this job presented `b3fecfbfa1d5c722578a000591f263a0e5cedc0d`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-panel-5647558192.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (4396736 cached reads)
- Output: 22079 tokens
- Cost: $2.4206472000000008
- Wall-clock: 748s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
