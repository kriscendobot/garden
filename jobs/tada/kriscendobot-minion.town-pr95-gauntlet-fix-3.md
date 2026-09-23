CI is GREEN (rc 0). The fix round is complete.

## Completion report

**Job:** Gauntlet FIX round 3 — kriscendobot/minion.town PR #95 (`designs/mcp-guest-surface-documentation.md`).

**What I did.** Read the panel round-3 request-changes verdict (critic, skeptic, decomplector, ergonomist, copyeditor, novice requesting changes; pedant comment-only; orthographer approve), verified each disputed code claim against the checkout, applied the fixes in one commit, pushed to the PR head, and watched CI to green.

**Verified against `src/` before editing:**
- `grep "Formula does not exist"` in `src/`/`test/` → **empty**. The design's "current path re-classifies by string match" baseline was false; `remove` (guest-tools.ts) just calls `facet.remove` and renders `✅ removed` unconditionally. `GuestFacet.remove`/`GuestAgent.remove` are both `Promise<void>`.
- Invitation design § 7 tool table (lines 345-348) lists only `guest_invite`, `guest_contacts`, `guest_introduce`, `guest_inbox` — **no accept MCP tool**; acceptance is browser-shell (§ 3 states).
- `okJson` comment (guest-tools.ts:437) reads "mirroring the guest tools" — the design had it reversed as "mirroring the clip tools."
- `assertValidPetName` bounds `name.length` (UTF-16 code units); `readText` returns stored value verbatim.

**Must-fix items applied:**
- **§ 1 `remove`** (critic/skeptic/decomplector/ergonomist): dropped the false baseline; named the concrete facet-level mechanism (catch the daemon's not-found rejection, resolve success), kept `Promise<void>` and one idempotent message, dropped the undiscriminated "was already absent" outcome the daemon cannot signal.
- **§ 2 accept path** (critic/skeptic/ergonomist): stated plainly that acceptance is browser-shell only today (no accept MCP tool); recovery sentence now names the surface switch.
- **okJson/clip reversal** (novice): corrected — clip tools mirror guest tools; directory tools carry prose, no JSON payload.
- **Vehicle** (novice): named the follow-up build job for § 1; Status line no longer contradicts "proposes changes."
- **Status vs "changes only"** (copyeditor): reworded to "proposes changes to only…".

**Should-fix items also applied** (cheap and clearly correct): maxLength code-unit-vs-code-point caveat + `MAX_PET_NAME_LENGTH` export recommendation; Error-contract `JSON.stringify` escaping note + `readText` present-non-text row + verbatim-value sentinel-collision caution; caller-terms character-rule prose (attribution kept in design/comment, not caller-facing describe); live-daemon (not fake) pinning of the remove idempotence gate; dropped inline draft-history narration; fixed list punctuation, deictics, and en dash in own prose. Also converted my introduced em dashes to match the document's established em-dash-free style.

**Changed:** `designs/mcp-guest-surface-documentation.md` only (commit `e7c0ffc`, pushed `9e2a945..e7c0ffc`).

**CI:** GREEN (rc 0, `ci-wait-merge` rollup total=1 failed=0).

**Follow-up:** none for this stage; the driver re-posts panel-4. The § 1 code changes remain a proposal for a follow-up build job (as the design now states); the § 2 `send` description change stays gated behind the invitation design's build gates.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr95-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2212691 cached reads)
- Output: 23647 tokens
- Cost: $2.5555195
- Wall-clock: 421s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
