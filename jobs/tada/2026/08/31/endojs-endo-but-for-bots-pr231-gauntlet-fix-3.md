CI is GREEN (rc 0). The fix is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr231-gauntlet-fix-3 — FIX round 3 for PR #231 (`design(familiar): MVR release plan`).

This is a **design PR** whose deliverable is `designs/familiar-release.md`, so the panel's must-fix items are edits to that document. I read the round-3 panel verdict (posted as issue comment `2026-08-31T09:07:46Z`, disposition **must-fix**; request-changes seats: critic, skeptic, decomplector, pedant, novice) and applied every finding, plus the cheap comment-only ones from ergonomist and copyeditor.

**Changes applied (single commit `5257f9fb8`, pushed to `endojs:design/familiar-release`):**

- **Per-gap disposition schema now uniform (skeptic, decomplector, ergonomist, pedant).** Added `**MVR disposition:**` to the 9 gaps that lacked it (G1, G5, G7, G9, G12–G16), so the document's declared single-source-of-truth schema holds for all 16 gaps. Removed the redundant `**MVR resolution:**` label in G2/G3/G6 (folded into prose). Rewrote the schema paragraph to state that `**Resolved by:**` appears only where a recorded decision set the disposition.
- **Tier 0/Tier 1 build dependency disambiguated (critic).** Distinguished the per-PR Tier 0 build smoke (`macos-14` only) from the pre-existing release build matrix; stated each Tier 1 cell builds its own platform's package.
- **CI path filter widened (skeptic).** Added `packages/chat/**` to the Tier 0/1 filter so a vite-renderer regression can't slip past the Blocker gate.
- **Linux launch risk reframed (critic, skeptic).** Recast the residual Linux GUI-launch gap as a named, Blocker-adjacent risk (not a generic display-bound one), and noted the unprivileged-user-namespace alternative to the `chrome-sandbox` setuid setup in G4.
- **G9 fixes (novice, decomplector, critic).** Dropped the unused `ENDO_ADDR` from the heading, glossed "weblet", clarified the port-collision fix is independent of the gateway direction, and trued up its effort to account for the new failure-dialog UI.
- **Forward references + provenance (novice, skeptic).** Made all "Open Question N" citations explicit forward pointers; added provenance to G11's "user-tested by the maintainer" claim.
- **Prose hygiene (pedant, copyeditor).** Removed all 10 remaining prose em-dashes (hard override), normalized `followup`/`Familiar` spelling, moved the `CAS` gloss to first use, fixed G3's comma splice, G4's broken parallel, the G2 run-on, and the mock-gateway double negation.

I deliberately left copyeditor finding 4 (a Target-field mood-consistency sweep across all 16 gaps) — a comment-only, broad stylistic rewrite, not a must-fix.

**Verification:** Pushed via `safe-push-pr-head.sh` (advance mode, `07c19a836..5257f9fb8`). CI watched to terminal, bounded: **GREEN** (`total=5 failed=0`, rc 0).

**Follow-ups:** none blocking. Per the stage contract I did not re-run the panel; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5804712 cached reads)
- Output: 37086 tokens
- Cost: $5.011538
- Wall-clock: 1011s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
