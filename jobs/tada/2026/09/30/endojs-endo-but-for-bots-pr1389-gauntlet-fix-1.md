# Gauntlet FIX round 1: endojs/endo-but-for-bots#1389 (layer-1 SturdyRef shim contract design)

The panel's round-1 fixes are pushed to the PR head. CI is green: `ci-wait-merge.sh --no-merge` returned 0 with 28 checks and 0 failures. The panel's verdict was posted as a COMMENTED review (5361971406) with disposition **must-fix**. I applied the must-fix and request-changes items from the pedant, critic, skeptic, ergonomist and novice seats, the decomplector's should-fix, and the pruner's PR-body cuts. I also took most of the copyeditor's and novice's comment-level points.

**Commit `ee8de1a1cf`** was pushed with `safe-push-pr-head.sh` and moved the head forward from `9ed5707c96`.

Changes to `designs/sturdyref-shim-contract.md`:
- **Settled vs. open (critic, skeptic):** four choices in the Surface section are now marked *provisional* and linked to Open questions 1, 2, 3 and 5. These are when the hook runs, what argument it gets, reading `enliven` once, and the prototype. A preamble says no higher layer may rely on them until they are settled.
- **Repeated enlivening (skeptic):** the text now says the shim caches nothing and each `enliven` call runs the hook again. The new-tests row includes a test that enlivening one ref twice runs the hook twice.
- **API behavior (ergonomist):**
  - It now explains why the constructor throws synchronously while `enliven` rejects.
  - It explains why `isSturdyRef` does not use `instanceof`, and adds a test for a forged prototype.
  - It names the overlap with `@endo/ocapn`'s own `isSturdyRef`/`enlivenSturdyRef` functions until layer 5 removes them.
- **Forward sketch (decomplector):** it no longer claims that the handler contract alone is enough. It now names the minting CapTP's side table and states that only the minting CapTP can serialize a ref. Whether the contract is enough for layer 5 now depends on Open question 7, which was widened to match.
- **Wording:** "identity" is clarified to mean object identity only. Novice's "llm's" became `@endo/ocapn`'s.
- **Missing context (novice):**
  - I added the nine-layer list, taken from the PR's stack table.
  - I added a lead-in explaining the withdrawn `endo-sturdyref-enliven-design` job.
  - I explained how `repairIntrinsics` keeps the global out of child compartments.
  - I added short definitions of "ponyfill" and "eval twins".
- **Copyeditor:** "wrong shape" became "lacks either static", "spackle" became "stopgap", and the "Arc:" sentence fragment was rewritten.
- **Pedant:** the code paths are now relative links, and `sturdyref-shim.js` is attributed to #774.

In `designs/README.md` (pedant's must-fix), the em-dash placeholder in the date column is replaced with 2026-09-30. The only em-dash left in the design doc is inside the verbatim quoted prompt, so I left it alone. The Botese and British-spelling greps both found 0 candidates in the diff.

The PR body was edited in place, and its `garden-job` marker is still there (pruner):
- The nine-row stack table is replaced with one sentence.
- The Scaling, Documentation and Upgrade sections are removed.
- "spackle" became "stopgap" and "llm's" became `@endo/ocapn`'s.

**Follow-ups:** none from this stage; the gauntlet driver posts panel-2. Open questions 1–7 still need the maintainer's decisions before any layer depends on the provisional defaults.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1163773 cached reads)
- Output: 10725 tokens
- Cost: $1.0117906
- Wall-clock: 1341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
