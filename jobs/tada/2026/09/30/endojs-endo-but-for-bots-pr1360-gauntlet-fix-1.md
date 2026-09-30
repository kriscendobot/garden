## Fix round 1 done: endojs/endo-but-for-bots PR #1360

The panel's one binding must-fix is fixed and pushed, along with most of its should-fix findings. CI is green: `ci-wait-merge` returned rc=0 with 28 checks and 0 failed.

**The must-fix:** I rewrote the PR body to follow the repo's `.github/PULL_REQUEST_TEMPLATE.md`. It now has Refs, `## Description` and all six `### … Considerations` sections, and keeps the `garden-job` marker and attribution.

**Design doc changes** (commit `f52acf6609` on `design/capability-url-locators`, pushed with `safe-push-pr-head.sh` from `fb5bc7ae31`, no rewind):
- **Recognition (critic):** the doc now says exactly when a URL is "not a locator" and when it is an error. Zero capability keys means not a locator; one or more means it claims to be one, so any defect is an error. A table of boundary cases (`v=1` alone, `label` alone, `node` alone, `view` alone, unknown key, both families, duplicate key, envelope) backs this up and matches the sibling implementation on `build/guest-locator-adoption`.
- **Envelope links (skeptic):** the API now says `parseCapabilityUrl` throws "not a self-contained locator" for a well-formed minion.town `#v=1&invitation=` link, and `isCapabilityUrl` returns false for it. The registry prose explains why, and the test list includes this case.
- **`view` (critic, skeptic):** the body no longer calls it settled. It is marked as needing the maintainer's sign-off (open question 6), with a note that stage 1 already implements it and would be reverted if the answer is no.
- **Naming (ergonomist):**
  - The doc now explains that the parsed fields are `number`/`formulaType` because they match `parseLocator`'s existing return shape.
  - `--locator -` vs `--locator-stdin` is added as open question 7.
  - `formatCapabilityUrl` vs `formatHttpsLocator` is open question 8.
  - I left the names themselves unchanged to match the stage-1 code.
- **Readability (novice):** a short glossary at the top defines pet name, locator, bearer, `EndoHost`/`EndoDirectory`, and #1333's helpers. `storeIdentifier` is explained where it first appears.
- **Trust split (decomplector):** a note says the split between `storeLocator` and `adoptFromLocator` rests only on which method the caller picks, and suggests a branded "verified locator" type as a follow-up.
- **Cross-PR references (integrator, skeptic):**
  - #150/#152 are now described as related in-flight work rather than settled prior art (#152 has an open changes-requested review).
  - The `resolveLocator` rationale is corrected.
  - The #684 mention now names the OCapN refactor it is waiting on.
- **Typing (copyeditor, pedant, orthographer):** all `…` became `...`, `⇅` became `<->`, and "analogue" became "analog".

**Not done:** the pedant's comment-only note on heading capitalization, and the ergonomist's CLI flag and function renames, which went into open questions instead because they would diverge from the stage-1 code on #1333's branch. I did not re-run the panel; the driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1490469 cached reads)
- Output: 13351 tokens
- Cost: $1.2199778000000001
- Wall-clock: 1551s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
