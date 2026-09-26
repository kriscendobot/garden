CI is GREEN. The fix pushed cleanly and passed CI.

## Completion report

**Job:** Gauntlet FIX round 1 — kriscendobot/minion.town PR #95 (design doc: MCP guest-surface documentation contract).

**What I did:** Applied the panel-1 must-fix items to `designs/mcp-guest-surface-documentation.md` in one revision, pushed as a follow-up commit to the PR head, and watched CI to green.

**Substantive (critic) fixes:**
- **§ 2 reconciled with the existing design.** Dropped the invented "two principals each approve a pending introduction" symmetric-approval flow (it both restated the gap and contradicted `invitation-only-guest-onboarding.md` § 7). § 2 now routes peer introduction through the existing `guest_introduce(contactName, toContactName)` mechanism and only records that the mail surface depends on it.
- **`structuredContent` invariant honored.** `guest-tools.ts:435-438` records that the surface deliberately carries no `structuredContent`/`outputSchema`. Instead of adding a lone structured output to `has`, the fix now corrects `has`'s *description* to name its exact branchable text outcomes — keeping the surface consistent.
- **`remove` idempotency moved to the right layer.** Fixed at `GuestFacet.remove` returning a discriminable idempotent success, rather than `registerGuestTools` re-classifying the daemon's error text by string match.
- **Schema-completeness asymmetry justified.** Made explicit that `maxLength: 255` is empirically grounded (the 256-char probe reached MCP) while the pattern restriction is deliberately omitted (malformed-name probe never reached MCP).

**Copyedit fixes:** straightened curly quotation marks throughout (preserving verbatim daemon output, incl. the genuine en-dash in `1–255`); made the seven/six/one child accounting explicit; fixed ambiguous pronouns (`remove` description, "the mail evaluation"); resolved § 1 mood drift; softened the error-contract "now prevented" present-tense overclaim to conditional; `Companion` → `Companions`.

**Result:** commit `3137f77` pushed to `design/minion-town-guest-surface-documentation`; CI GREEN (rc 0). Did not re-run the panel (driver posts panel-2).

**Follow-up note for the eventual implementation PR (out of scope here, panel-flagged):** the `guest-tools.ts:437` comment cites `designs/clip-gateway.md`, which is absent from `designs/`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr95-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1323140 cached reads)
- Output: 19562 tokens
- Cost: $1.802789
- Wall-clock: 356s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
