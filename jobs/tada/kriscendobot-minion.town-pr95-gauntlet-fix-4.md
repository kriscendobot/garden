Inbox empty. The fix stage is complete.

## Completion report

**Stage:** gauntlet FIX round 4 — kriscendobot/minion.town PR #95 (design contract `designs/mcp-guest-surface-documentation.md`).

I read the panel round-4 verdict (7 of 8 seats request-changes; orthographer approves), verified each load-bearing claim against the PR-head worktree source, applied the must-fix items plus the substantive should-fixes, pushed one review-feedback follow-up commit, and watched CI to **GREEN**.

**Verified against source before editing:**
- MCP SDK validates each tool's zod input schema server-side (`safeParseAsync` → `McpError(InvalidParams)` before the handler) — `@modelcontextprotocol/sdk/.../server/mcp.js:177,181`.
- `zod .max()` bounds `.length` (UTF-16 units), matching the daemon; only the emitted JSON Schema is code-point-based.
- The live remove path is `root-host-socket.ts`'s `removeValue` = `await E(host).remove(...)` (the one site the daemon far-error shape is known); `GuestAgent.remove` documents "no-op if absent"; the fake honors it; error taxonomy (`PetNameError`/`DaemonUnavailableError`) is minted locally.
- `test/endo-daemon-integration.test.ts:65` is `skipIf(!ENDO_CHECKOUT)` and CI's `npm test` never sets it (green-because-skipped).
- Invitation design confirms `EndoGuest` has no `accept`; acceptance is blocked on Endo on *no* surface today.

**Fixes applied (must-fix + should-fix):**
- **`remove` discriminator** (critic/skeptic/decomplector must-fix): relocated the idempotence fix from the facet to the live adapter; named the discriminator honestly as a *localized* not-found far-error shape match at `removeValue` (the one place its shape is known), with the upstream-drift risk owned and the "all genuine failures still surface" invariant preserved because the match is narrow, not a blanket catch.
- **`maxLength` server-side rejection** (skeptic): documented that an over-long name is now a JSON-RPC `InvalidParams` error before the handler, not the handler's `⛔` isError text; corrected the UTF-16-vs-code-point caveat direction (external validator accepts, server rejects).
- **Verification runner** (critic/skeptic): stated the build must provision `ENDO_CHECKOUT` so the live-daemon gate actually executes.
- **Layering model + "pet name" intro** (novice must-fix): added a four-layer walk and a pet-name definition at the top of § 1.
- **Widened schema treatment** to `resolve`/`adopt` (shared `assertValidPetName`), carving out `send`'s recipient grammar (ergonomist/critic).
- **§ 2 accept overclaim + tense** (skeptic/copyeditor): corrected to "no accept surface today," conditional tense.
- **Copyedit/pedant must-fixes:** front-matter paragraph breaks, "only"-scope contradiction, citation-form + enumeration-order normalization, error-contract 256-char row, `has` prefix-branch guidance, TOCTOU wording, remove-description gate, changeset two-commit split.
- Avoided a self-inflicted regression: removed `→` arrows I'd introduced (typist-friendly-code-points); grep confirms the doc is clean of typist-unfriendly code points.

**Pushed:** commit `944a7d1` on `design/minion-town-guest-surface-documentation` (`e7c0ffc..944a7d1`) via `safe-push-pr-head.sh` (advance mode). `package-lock.json` warm-cache noise deliberately excluded.

**CI:** `ci-wait-merge.sh ... --no-merge` → rc 0, CI GREEN (1 check, 0 failed). PR left as-is (draft, no merge). Did not re-run the panel; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr95-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3599280 cached reads)
- Output: 38642 tokens
- Cost: $3.8618100000000006
- Wall-clock: 595s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
