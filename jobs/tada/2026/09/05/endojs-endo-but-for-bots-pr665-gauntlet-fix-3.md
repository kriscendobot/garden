CI is green (rc 0). The round-3 fix stage is complete.

## Completion report

This was a **re-run** of the round-3 FIX stage for endojs/endo-but-for-bots PR #665 (the "release-automation major-bump exports-key cleanup notice" design). I re-derived state from committed history: the PR head (`70d7d6c38f`, "apply panel round-2 must-fix items") predated the round-3 panel verdict, so no prior attempt had applied round-3 — a clean start.

**What I did:** applied the round-3 panel's must-fix and should-fix items to `designs/release-automation-major-bump-exports-trigger.md` (and one `designs/README.md` prose fix), pushed as follow-up commit `5d0b5e178b`, and watched CI to green.

**Changes (panel items addressed):**
- **Manifest is a real artifact** (critic/skeptic/novice must-fix): specified the pass-1 provenance manifest concretely as a committed repo-root `.exports-migration-manifest.json` with a documented shape, recorded emitting it as a **required amendment to PR #663's scope**, and named the changeset-note fallback if #663 lands first. Added a Dependencies-table note and a test-plan prerequisite forbidding a silent fallback to bare deep-equality.
- **De-complected provenance from policy** (decomplector): manifest is now immutable provenance only; opt-out moved to a separate mutable `.exports-cleanup-suppressions.json`; Open Question 3 rewritten to use it, not a manifest edit.
- **Non-blocking-vs-error contract** (ergonomist): auto-resolved empty input is now a zero-finding exit 0; only an explicitly forced empty mode errors. Modes renamed to user-facing `--mode pr|release` (parse-oriented aliases retained); liveness line now names the surface.
- **Forward reference** to the "inert until pass-1" claim reworded (novice).
- **Anchoring vs dependency-free** restated as a small dependency-free key-position scan (skeptic).
- **Design Decision 3** hedged to match the release-branch uncertainty (critic).
- **Copyeditor**: rewrote the garbled 68/123 parenthetical, split a chained sentence, fixed a tense slip, restored the explicit noun in `designs/README.md`.
- **Pedant**: replaced all `i.e.`/`e.g.`; kept prose em-dash-free per repo convention.

**Result:** follow-up commit pushed to the PR head; CI terminal GREEN (5/5, 0 failed). Panel not re-run (driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr665-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 88 tokens (2833162 cached reads)
- Output: 29816 tokens
- Cost: $3.4659879999999994
- Wall-clock: 956s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
