Done. Fix stage round 1 complete: applied the panel's must-fix items to the design, pushed as a follow-up commit, CI green.

## Completion report

**Job:** Gauntlet FIX round 1 — kriscendobot/minion.town PR #96 (`designs/claude-agent-credential-reauth.md`).

**What I did:** Read the panel-1 verdict (8 seats, `must-fix` disposition), applied the fixes as one follow-up commit (`51ecdd4`) to the PR head `design/claude-agent-credential-reauth`, pushed via `safe-push-pr-head.sh` (clean advance), and watched CI to green.

**Must-fix items applied:**
- **10-minute TTL dead-on-arrival** (critic, skeptic): decoupled `ReauthTicket` lifetime (long-lived, bounded by a new § 6 park ceiling) from the account-page URL's 10-minute clock, and applied the same decoupling to § 5's external-email path via a stable landing URL that mints the ephemeral transaction server-side.
- **`requestReauth()` no signature/facet-misplacement** (ergonomist, critic, decomplector): added a tagged-result union (`escalated`/`already-pending`/`connected`/`unavailable`), moved it off the status-only `ClaudeAccountStatus` facet onto a distinct escalation facet, and gated it on the concierge's live credential check.
- **`usage-exhausted`/`limit-exceeded` taxonomy** (ergonomist, skeptic, novice): stated the `InferResult` union it joins, added the `limit-exceeded` (resource-bounded) row and a fail-closed default.
- **Concierge resolves operator** (skeptic): stated it resolves the recipient from its own root-`iss+sub` binding and ignores any agent-supplied recipient.
- **Broken `(§ 3)` forward-refs** (copyeditor): repointed to § 6; requalified the pre-expiry-advisory claim as an open question.
- **Base-design cross-ref `:223`** (copyeditor, pedant): recast to name the heading, not a nonexistent § 4.
- **Dangling `ocap-mailboxes.md` link** (pedant, novice, all): replaced with house form + PR #37 qualifier.
- **Unbracketed quotation alteration** (pedant): recast so the quote is verbatim.

**Convergent should-fixes also applied:** park ceiling + `reauth-abandoned` terminal state and host-side escalation budget (skeptic); pre-migration existing-guest fallback (skeptic); `@operator` → `@claude-operator` rename for domain-prefix consistency (ergonomist); "indelible" wording, parallel bullet lead-ins, missing article, ambiguous "Both" antecedent, redundant status line. Kept the doc em-dash-clean and free of typist-hostile code points (removed em-dashes I initially introduced).

**Result:** CI GREEN (rc 0). I did not re-run the panel (per stage contract; the driver re-posts panel-2). No follow-ups outstanding; `package-lock.json` warm-cache churn was left unstaged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4653074 cached reads)
- Output: 35265 tokens
- Cost: $4.293770999999999
- Wall-clock: 649s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
