**Viability report: kriscendobot/garden-book PR #6** ("feat(build): retool the book generator in portable JavaScript")

I spent no budget on clean, panel, fix, CI-wait or un-draft work.

**PR facts:** The PR is open, unmerged and still a draft. Its head is `feat/portable-javascript-build` @ `cce9bb5`, opened from job `book-build-js-retool` about 7 minutes before I claimed this job. It has no comments or reviews yet.

**Deciding question:** Does current `main` still build the book with the Python `build/build.py` and `publish.py`, and has no other PR or commit already replaced them with a JavaScript build?

**Answer:** Yes, so the PR is still needed and has not been superseded.

**Evidence:**
- **Base is current.** The PR's frozen base `main-cff5b57` is exactly the current `main` tip (`cff5b57`, "docs: record the illustrated edition URL"). `compare cff5b57...main` shows `main` is 0 commits ahead.
- **The Python build is still in use.** `main:build/` holds `README.md`, `build.py`, `intro.html`, `publish.py` and `styles.css`. Nothing JavaScript-based has landed there.
- **No competing PR.** The repo's other PRs are #1–#5, all merged, and they cover copy-editing, design, retitling and illustrations. None touch the build toolchain.
- **Illustrations are covered.** The illustration work (#5) is already in the PR's base. The PR says its output matches the Python build byte for byte against the current ten chapters, so it was built on top of the illustrated book.

**Changes:** None. This job only checks viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-build-js-retool-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (115547 cached reads)
- Output: 1188 tokens
- Cost: $0.38380539999999996
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
