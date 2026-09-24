**Panel round 4 for endojs/endo-but-for-bots#1100 (gauntlet ebfb-exo-stream-pr1100-gauntlet-20260923b): must-fix**

- **Setup:** I checked out the PR head `4c016bcaca` (branch `kriscendobot-exo-stream-drop-base64` on `endojs/endo-but-for-bots`) in an isolated worktree for this job. The panel used the PR's pinned base commit `f9cbcfc426` (`llm-f9cbcfc`), not the stale `origin/<baseRef>`.
- **Run:** I ran `panel.sh` in single-round mode. All 32 seats returned `ok`, and it exited 0. Its last line was `code-panel single-round — must-fix`.
- **Verdict posted:** comment review [5299229592](https://github.com/endojs/endo-but-for-bots/pull/1100#pullrequestreview-5299229592), 63.5K characters. GitHub does not let an author request changes on their own PR, so it is a comment, as in rounds 1–3. It has a numbered fix list, the full blocks for the seats that asked for changes and the comment-only seats, and a list of the approving seats' blocks that were cut to fit GitHub's size limit.
- **Seats asking for changes, and what they want:**
  - **breaker:** stopping a write from the writing side still saves the partial data (`iterate-bytes-writer.js` `fail()` sends the same signal as a normal close). The seat reproduced this against the in-memory backend.
  - **migrator:** the changeset leaves `@endo/sandbox` out of the major-version bumps. As a should-fix, it asks for a check of other packages that use the byte reader/writer.
  - **integrator:** the PR title and description no longer match what the branch contains.
  - **pruner:** boilerplate and repeated sections in the READMEs and in `MIGRATION.md`.
  - **benchmarker:** `BENCH.md:61` points to a figure in `DESIGN.md` that the head commit removed.
  - **purist:** should-fixes only: the reader and writer default size limits differ, `looksLikeReadableBlob` relies on a method being absent, `browser-tree.js` builds its own reader pump, and a comment contradicts itself.
- **Changes:** none to the garden repo. I deleted the panel's scratch run directory afterwards.
- **Follow-ups:** the next stage is the gauntlet's fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1075850 cached reads)
- Output: 7988 tokens
- Cost: $0.8686259999999999
- Wall-clock: 675s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
