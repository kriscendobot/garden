FIX round 2 for endojs/endo-but-for-bots#1409 is done: I applied the panel's must-fix items, pushed, and CI came back green (31 checks, 0 failed, `ci-wait-merge` rc 0).

I couldn't run the package tests (`ava`) locally because this checkout has no `node_modules`. The changes are comments, docs and the changeset only. I checked them with `node --check` and an 80-column check; CI is the real test run.

**Fixes, by seat:**
- **changeset-auditor:** the bump on the unpublished `@endo/agent-mcp-stdio` is now `minor`, not `major`. I removed the "Breaking:" framing and the `error.data.reason` detail. This seat's reading overrides integrator's `!`/major suggestion, so neither the commit nor the title has `!`.
- **breaker:** I took the "narrow the claim" option, not scrubbing. The README and the `confined.js` comment now say:
  - The withheld identifier and locator tools are the ones that *take or mint* a designation.
  - Served results are not scrubbed: `listMessages`, `followMessages` and `followNameChanges` still show locators and identifiers. Seeing them grants nothing, because the tools that would turn them into authority are withheld.
  - The content-locator wording now says "no *designation* authority" and notes that `loadContent` makes the daemon fetch from the locator's source hints.
  - I added no scrub test, since the breaker asked for one only under the scrub option.
- **pruner:** I cut the `confined.js` module comment down to the design reference, the note on what is and isn't withheld, and the content-locator caveat. It points to the README for everything else. I also added integrator's point 4: `@endo/claude`'s `CODE_EVAL_NAMES` deny-list is a separate check, the two lists are not kept in sync, and this allow-list is the boundary.
- **integrator:**
  - I folded the round-1 fix-up commit into a single `feat(agent-mcp-stdio):` commit (`25d401813b`) on top of `llm-d4124e6`. Its body now states that `allowedToolNames` replaces the default list rather than narrowing it, and that served results are not scrubbed. I pushed with `safe-push-pr-head.sh --mode rewrite` (`526964f492` → `25d401813b`).
  - I rewrote the PR description:
    - The *Change* section now describes behavior instead of listing file paths.
    - It says `allowedToolNames` replaces the default list and can widen the served set.
    - It adds the paragraph on served results not being scrubbed.
    - It corrects the content-locator authority wording.
    - The bump level reads `minor`, which now matches the changeset.

**Follow-ups:** I left integrator's comment-only point 3 alone: renaming `selectConfinedTools`, or making `allowedToolNames` narrow-only. Panel-3 or the maintainer may raise it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1046506 cached reads)
- Output: 8181 tokens
- Cost: $0.9012172000000002
- Wall-clock: 859s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
