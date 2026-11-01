**Gauntlet undraft stage: endojs/endo-but-for-bots#1622** ("docs(designs): ironhorse in-crank string garbage and the chunk ceiling")

PR #1622 is now ready for review at head `6dc4e56999fba89a95f0287996c8cfc9fa9e14fd`, the commit the panel passed.

- **Check before the change:** the PR was OPEN and still a draft, and its head matched the passing panel's commit exactly.
- **Un-draft:** ran `gh pr ready` and it succeeded.
- **Check after:** `isDraft=false` and the head is unchanged.

**Advisory appellate pass** (a light `claude -p` review of the diff only, not checked against the repo; it did not gate the un-draft). Things the panel may have missed:
- **Index order:** the new design's row is not in alphabetical order in the designs README index.
- **Unchecked references:**
  - The 2026-10-16 architecture review is cited with no link.
  - The quiescent-gc section headings it points to were not confirmed to exist.
  - Source files are given as partial paths only.
  - The counts (183 `Payload::String` sites, 38 direct reads, 13 files) are not backed by a source.
- **Loose claims:**
  - The quantifier-clamp section does not square its `ResourceLimit` halt threshold with `decimal` capping at `u32::MAX`.
  - "At most four collections per ceiling" is stated without working it out.
  - The test for a halt inside a `reduce` callback may conflict with the promise that the test262 rows pass.
- **Dangling reference:** sequencing step 4 points to a ropes design marked "(to be filed)" that doesn't exist yet.

These suit an optional follow-up fix. I did not post any follow-up job.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1622-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178269 cached reads)
- Output: 1362 tokens
- Cost: $0.42011780000000004
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
