CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 5 for endojs/endo-but-for-bots PR #695 (`designs/sturdy-refs-agent-surface.md`, a design document).

**What I did:** Applied the panel-5 request-changes verdict to the design doc, pushed as a follow-up commit (`5a22023e0`) to the endojs PR head branch `design/sturdy-refs-agent-surface`, and watched CI to terminal-green.

**Must-fix items addressed:**
- **skeptic 1 & 2 (value forgery):** Added an explicit confinement requirement that a worker cannot fabricate/enumerate a sturdyref value or wire token the daemon never issued (index key must be daemon-minted, unforgeable, non-enumerable — covering the local index branch, not just remote), plus a new forgery negative test in Acceptance Criteria and Phase 3.
- **critic 1 & skeptic 3 (handle identifier):** Pinned the `ref@` identifier's *generation* (cryptographically unguessable, unique-within-minting-map, entropy floor) as part of the shared handle-contract record, closing the enumeration oracle and the transcript-collision confused-deputy case.
- **critic 2 & skeptic 4 (redemption-position rule):** Scoped the misplaced/position failure to strings *equal to a live or recorded entry*; ordinary handle-shaped content (file lines, grep results, commit messages) now passes as data instead of hard-failing tool calls.
- **ergonomist 1 & skeptic 6 (dead-end):** Stated plainly the initial surface's only model-usable outcome is an inspection description (infrastructure milestone), and corrected the output-map deferral rationale re: turn-scoped handles.
- **copyeditor (Phase 4 restrictive-that):** Split the ambiguous "messages, that both agents place…" directive into clear sentences.
- **pedant 1 (em-dashes):** Removed all 29 em-dashes (verified 0 remain).
- **novice 1:** Reduced the Summary's six-term nested parenthetical to a pointer.

**Should-fix also addressed:** decomplector (named per-entry epoch stamp as the single window enforcer, map lifetime as defense-in-depth); critic 4 (Phase 1 now "settles" OQ1 and owns option-(4) vetting); ergonomist 2 & copyeditor (pinned `redeemSturdyRef` as the single model-visible verb, removed the `/acceptSturdyRef` slash everywhere); pedant 3/4/5/6 (-ly hyphens, Design N-of-N numbering, parenthetical comma, parallel construction); pedant 2 (quote punctuation → American style); copyeditor (Phase 4 tense; deduped the transport caveat); acceptance-criteria long sentence split into bullets.

**Not addressed (deferred, lower-value/speculative):** critic 5 & copyeditor (add a mermaid diagram — comment-only); decomplector's counter→per-activation-token simplification and share-the-operation points (larger design refactors); novice 2–5 clarity reorderings; decomplector's designs/AGENTS.md milestone/dependency-graph/estimates cross-doc note.

**Excluded from commit:** a warm-cache `yarn install` artifact touching `packages/floot/package.json` (restored, not mine).

**Result:** Fix pushed; CI terminal green (27 checks, 0 failed; the design-only change skipped the code matrix, lint/zizmor/changes all passed).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 178 tokens (11294854 cached reads)
- Output: 52478 tokens
- Cost: $8.537337
- Wall-clock: 1433s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
