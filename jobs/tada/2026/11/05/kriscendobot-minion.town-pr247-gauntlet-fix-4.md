FIX round 4 is done for kriscendobot/minion.town PR #247. I pushed the panel-4 fixes and CI came back green.

**Source:** there was no pre-pass block, so I worked from the latest panel verdict on the PR: review 5780319591, from the pedant and copyeditor seats. I made all the edits in `designs/ordered-gutter-context-menu.md` and pushed them as commit `06499001`.

**Must-fix items (pedant):**
1. The header block now has blank lines between **Status**, **Decision** and **Grounded against**, so they no longer render as one paragraph.
2. The ASCII `clips/` tree (pet names pointing to controllers, plus the order list) is redrawn as a mermaid flowchart.

**Should-fix items, also done:**
- **Pedant:**
  - The `designs/new-clip.md` code path is now a relative link to `new-clip.md`.
  - "leaves-first" is now "leaves first" throughout.
  - The Freeze confirmation now says "Two other clips…", and the doc adds the wording for a count of one.
- **Copyeditor:**
  - "top-level child of the gutter" is now "top-level entry".
  - Reworded the ambiguous retry sentence and the "serialize an account" sentence.
  - Split the gesture sentence into shorter ones and defined "tap slop".
  - Fixed the unclear "That covers…" so it reads "The refusal also covers…".

**Not done:** the copyeditor's request to define adopt, `describe()`, chrome and stranded at first use (I only defined tap slop), and the pedant's note about uneven line wrapping. Both are optional, so they stay open for panel-5.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 3 checks passed and none failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (443973 cached reads)
- Output: 3780 tokens
- Cost: $0.6035306
- Wall-clock: 71s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
