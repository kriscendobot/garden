# Fix round 1 for endojs/endo-but-for-bots PR #1355: done, CI green

I made the panel's round-1 fixes to `designs/hardened-url-shim.md` in one follow-up commit, pushed it, and CI came back green (28 of 28 checks, no failures).

**Commit:** `1be22af092` ("docs(designs): restructure hardened URL shim status and resolve open questions"), pushed to `design/hardened-url-shim-status-reconciliation` (moved from `6fd7c06c17` to `1be22af092`) with `safe-push-pr-head.sh`.

**Changes, by panel finding:**
- **Open questions left open (skeptic, decomplector, should-fix):** both items under `## Open questions` now have a *Resolved:* note pointing to § Status.
  - Q1: the shipped name is `%URLSearchParamsIteratorPrototype%`, as proposed.
  - Q2: the shipped design shares the prototype and pins `%URLPrototype%.constructor` to `%SharedURL%`.
  - I checked both against `packages/ses/src/tame-url-constructor.js` and `permits.js` in this checkout.
- **Status section prose (copyeditor, should-fix):**
  - The seven-item run-on sentence is now a bulleted list with parallel phrasing.
  - The seven-line sentence about the renames is split into separate sentences.
  - "Absent-host degradation" is now spelled out as "graceful degradation on hosts that provide no `URL` constructor".
  - The opening now reads "The design is complete."
- **Terms used before they are defined (novice, should-fix):** the Status section now points readers to § Design for the terms. It also names the blob-registry methods (`URL.createObjectURL` and `URL.revokeObjectURL`) and explains how a shared compartment could reach the powered constructor.
- **Comment-only items I also addressed:**
  - A note that the rest of the document keeps the originally proposed names (skeptic).
  - The start-compartment cost of the constructor pin: there, `new URL(...).constructor === URL` is false (decomplector).
  - `urlBlobTaming`'s `'retain' | 'remove'` values break the `'safe' | 'unsafe'` pattern of the other `*Taming` options, so future options should not copy it without a deliberate decision (ergonomist).
  - That `%InitialURL%` matches the existing `%InitialDate%` / `%SharedDate%` naming pattern.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 16 minutes.

**Follow-ups:** none from this stage. The gauntlet driver will post panel round 2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (530756 cached reads)
- Output: 4500 tokens
- Cost: $0.6215032
- Wall-clock: 1116s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
