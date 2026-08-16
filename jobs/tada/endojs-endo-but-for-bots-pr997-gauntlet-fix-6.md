CI GREEN (rc 0). The fix round is complete.

## Completion report

Applied the panel round-6 must-fix items to PR #997 (`kriscendobot/endo-but-for-bots`, branch `design/worker-retention-and-revocation`, a design-docs-only PR) and pushed as follow-up commit `e0c55f082`. CI is green across all 5 checks (build, lint, test, browser-tests, zizmor).

**Changes** (`designs/worker-retention-and-revocation.md`, `designs/README.md`):

- **Admission cap "own contribution" (critic, skeptic).** Defined the term as a precise formula — `own(e) := |reach(e, t_mint) \ named(t_mint)|` (minted-time closure size minus name-reachable formulas), a live quantity frozen at mint, neither a flat per-edge `1` nor the live merged-group size. Introduced the per-session running sum `C(session)` checked against the cap **at each mint**, and added a proof-sketch + worked example (cap 10, two disjoint closures of 6) showing the N-roots-then-union attack is refused at admission and that `C(session)` is a sound upper bound on real footprint (union over-counts, never under-counts). Updated Test Plan item 4 to test single-heavy-fanout capping by formula count and the `pinnedClosureSize ≤ C ≤ cap` union property.
- **README load-bearing detail (critic, skeptic).** Synced both `designs/README.md` rows (M4 summary + estimate table) from `question:<answer-pos>` to `question:<session>:<answer-pos>`.
- **`makeRetainedValue` sibling return shape (ergonomist).** Guest arm now returns `{ release }` (same object envelope as host's `{ id, release }`, minus the confinement-forbidden `id`) rather than a bare capability; documented that the divergence is statically enforced via distinct facet types so a `.id` read off the guest result fails to compile.
- **Typist-hostile glyphs (copyeditor, pedant).** Replaced the Unicode arrow (:1188) and ellipses (:839, :1493) with ASCII `->`/`...`; expanded TOCTOU at first use. Also converted the math glyphs I introduced (`≤`, `Σ`, subscripts) to ASCII to avoid re-tripping the same finding.
- **Prose comprehension (novice).** Glossed union-find's merge-only / non-decreasing property at its first mention, which the later Q2 monotonic-growth argument leans on.

**Follow-ups / notes:** The pre-existing `→` arrows in `designs/README.md` are untouched historical content (not in this PR's diff; the pedant confirmed the PR's own README edits use ASCII). The novice's larger paragraph-split request was addressed at the load-bearing point (the union-find gloss); the remaining density is stylistic and left as-is to avoid altering the dense argument's coherence in a fix round. Per stage instructions I did not re-run the panel — the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 125 tokens (5320857 cached reads)
- Output: 25377 tokens
- Cost: $4.2191255
- Wall-clock: 672s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
