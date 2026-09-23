The deliverable is complete. Let me write my completion report.

The design doc is landed on a branch, the review PR #1151 is open against `llm` with the two-file diff, and the follow-up is linked back on the #897 review thread.

---

## Completion report

**Job:** `design-endo-but-for-bots-eliminate-single-segment-petname-paths` — design (not code) to eliminate single-segment string petname paths in endojs/endo-but-for-bots, per kriskowal's PR #897 review comment 3916282675.

**What I did**
- Traced the actual path surface (via an Explore agent + direct reads) and found a key nuance the raw ask didn't state: **slash-bearing strings already error today** — `assertValidSegment` (`mount.js:248`) and `isValidName` (`pet-name.js:15`) both reject `/`. The real residue is the **non-slash single string** (`readText("foo")` → `["foo"]`), which still silently works. The design therefore targets *all* string paths, not just slash strings, so array-of-segments becomes the sole spelling.
- Wrote `designs/eliminate-single-segment-string-paths.md` (house conventions: metadata table, Source, problem statement, decisions, migration, open questions, captured prompt), covering all six requested points: current surface + the three coercion choke points (`segmentsFromPathArg` mount.js:638, `namePathFrom` pet-name.js:149, the readable-tree wrapper); the array-only rule with the exact guard/body error; the glob/grep/glorp DSL aberration and the three help-text call-out sites; the `entry()`/`EndoMountEntry` reconciliation (keep it as an array-taking lineage-verified minter for `@endo/exo-git` vs. the maintainer's larger "retire the capability" fork); migration (CLI keeps translating human slash strings — no human regression; ~60 `entry()` tests migrate); and 5 open questions.
- Synced `designs/README.md` (summary-table row + "Recently added" note).
- Committed to branch `design/eliminate-single-segment-string-paths`, pushed to endojs, opened **draft review PR endojs/endo-but-for-bots#1151** against `llm` via `ensure-pr.sh` (carries the `<!-- garden-job: … -->` marker).
- Posted a threaded reply on the #897 review comment linking the follow-up PR.

**What changed**
- New file `designs/eliminate-single-segment-string-paths.md` (Status: Proposed).
- `designs/README.md` updated.
- PR #1151 (draft) is the maintainer answer-surface; it holds real forks so it is deliberately a review PR, not settled docs.

**Follow-ups (for kriskowal to decide, in the PR's Open Questions)**
1. Hard array-only vs. one named string escape hatch (and where it lives).
2. Keep `entry()` as an array minter vs. retire `EndoMountEntry`/`PathEntry` (Git → strings-only, ~60-test change).
3. Glob-DSL help banner vs. renaming/namespacing the pattern methods.
4. Eliminate string paths in the pet-name registry in lockstep vs. scope to EndoMount first.
5. Immediate hard error vs. a warn-then-error deprecation window.

No code elimination was implemented (design deliverable only), and I did not undraft the PR — a draft is the correct shape for a design decision surface, avoiding a spurious code-panel gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-but-for-bots-eliminate-single-segment-petname-paths.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3568433 cached reads)
- Output: 33690 tokens
- Cost: $4.403553499999999
- Wall-clock: 567s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
