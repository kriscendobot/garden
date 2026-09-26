CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1102 gauntlet — FIX stage, round 5. Design-only PR (`designs/introduced-special-names.md` + `designs/README.md` roadmap edits).

**What I did:** Read the panel-5 request-changes verdict and applied every must-fix item once, pushed one review-feedback follow-up commit to the PR head (`kriscendobot/endo-but-for-bots:design/claude-agents-capability`, `84eb3ca6c → 255f50f41`), and watched CI to green.

**Must-fix items addressed:**
- **critic:** (1) Added a paragraph in § Provisioning against an existing agent stating *why* the reject-on-difference rule excludes monotonic growth — a scoping choice, not a security one, and a forward-compatible relaxation a later design can make. (2) Fixed the § Indelibility citation to name the genuine write-path call sites (`pet-store.js:98` storeIdentifier, `:166` remove, `:183-184` rename) instead of the wrong read/signature lines.
- **skeptic:** Rewrote § "The introduced sub-namespace…" to specify the prefix-reservation assertion runs over the **fully assembled** special-name set at agent construction, so it covers both the hardcoded daemon-owned literals and the embedder-supplied `specials` half; updated the Phase 1 test list to test both sub-sides.
- **decomplector:** Pinned the reachability label as a shared named helper `introducedSpecialNameLabel(destination)` both tables call, replacing the illustrative example string.
- **copyeditor:** All six prose fixes (README seam sentence split; plural/singular consistency at :31; two appositive-pile recasts; the "discover a divergence" verb phrase; the extractLabeledDeps bullet's internal semicolon; parallel structure at :467).
- **novice:** Fixed the reversed roadmap edge (`isn --> eclaude`); dropped the two forward-reference `(Design decision N)` parentheticals; added prose distinguishing the two motivating cases (scoped-account-facet driver vs #982's `@main`).
- **pedant (comment-only, applied):** Spelled out "garbage collector (GC)" at first use.

Kept the doc's no-em-dash / typist-friendly style throughout (verified my edits introduced none).

**CI:** GREEN — `total=5 failed=0` (rc 0).

**Follow-ups:** None. Per gauntlet protocol I did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (3636389 cached reads)
- Output: 27043 tokens
- Cost: $3.3569325000000005
- Wall-clock: 916s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
