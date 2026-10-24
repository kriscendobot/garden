---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-24T04:19:11Z
job: kriscendobot-minion.town-pr221-gauntlet-panel-3
claim: ce4cec35494f0697
---
PR #221 ergonomist review

Originating dispatch: user request to review PR #221 in the specified minion.town worktree against `68c3960bbe82ecaae699e4d95d2d1cc900f2fa86...HEAD`.

**Verdict:** request-changes

**Findings:**
- must-fix: `designs/recursive-dynamodb-capabilities.md:109-146,363-394` promises that every capability method resolves a `Result`, yet a CapTP break rejects and is merely described as something the caller should treat as `unavailable`. A caller handling the advertised union will miss this normal lifecycle failure, and the same logical outcome arrives through two incompatible channels. Normalize well-formed transport failures to the documented `{ type: "unavailable", retryable }` result (or explicitly remove it from `Result` and specify a distinct rejection contract). [rule: src/endo/claude/types.ts (THE NEVER-REJECT CONTRACT)]
- must-fix: `designs/recursive-dynamodb-capabilities.md:343-394` requires callers to restart after cursor expiry, restart, or attenuation, but leaves those cases inside unspecified `SafeReason` under the same `invalid-request` tag as malformed requests. Expose a stable cursor-specific result with the required recovery action, distinct from a request the caller must correct, so pagination can implement the prescribed restart without parsing an implementation reason. [proposed-rule: A public result union must give callers a stable, discriminated outcome for every recovery action the API requires.]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
