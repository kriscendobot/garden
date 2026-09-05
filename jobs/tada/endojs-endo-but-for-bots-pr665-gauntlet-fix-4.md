CI is green (rc 0). The fix is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #665 (design doc: `release-automation-major-bump-exports-trigger`).

**What I did:** Read the panel round-4 verdict (request-changes from critic, decomplector, ergonomist, novice; should-fix items from skeptic and copyeditor; approve from pedant). Applied the must-fix and reasonable should-fix items in one follow-up commit to the PR head, pushed, and watched CI to green.

**Changes applied** (2 files: the design doc + `designs/README.md`):
- **Fail closed on missing provenance** — dropped the unspecified "parse the changeset note" fallback entirely; a `.js` key with no manifest entry is never flagged (critic, decomplector #1, skeptic #2). Removes the second, unspecified provenance representation.
- **Manifest binds provenance to creation-time value**, not just key name (`{pkg: {"./k.js": "./src/k.js"}}`), so a delete-then-recreate under a new value is not mistaken for a pass-1 artifact (decomplector #2).
- **Dropped the `--mode` parse-technique aliases** (`changesets`/`versions`) — one canonical spelling per value (ergonomist).
- **Renamed** `.exports-cleanup-suppressions.json` → `.exports-migration-suppressions.json` for a shared prefix with the manifest; explained the pairing (ergonomist).
- **Acknowledged the residual Checks-tab visibility gap** of the annotation surfacing, with a stated escalation path (ergonomist).
- **Dropped the undefined "not pass 2" negation** in the problem statement (novice #1, copyeditor #1); **forward-referenced gate A** at its first mention (novice #2).
- **Reconciled the `designs/README.md` M2 "Reopened" vs "exit criterion still met"** contradiction as a "convenience row added," not a milestone re-opening, across all three occurrences (novice #3, critic note).
- **Sharpened the Surface 2 confirmation** to ask whether *this fork's own* changesets ever reach a `changeset-release/*` PR (skeptic #1).
- Prose tightening ("is false" subject, Design Decision 3 trim, "specific exact") and the `0.x`-span spacing fix (copyeditor #2/#3/#5, pedant).

Left as-is: copyeditor #4 (comment-only, split a numbered step).

**Pushed:** `5d0b5e178b..67d91f5aba` to `design/release-automation-major-bump-exports-trigger`. **CI: GREEN** (5/5 checks, 0 failed, rc 0). I did not re-run the panel; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr665-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3146482 cached reads)
- Output: 26064 tokens
- Cost: $3.0521540000000003
- Wall-clock: 834s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
