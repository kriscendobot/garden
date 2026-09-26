Fix stage complete. CI is green.

## Completion report

**Job:** kriscendobot/minion.town PR #96 gauntlet — FIX round 6 (design PR: credential-expiry detection and operator-mediated reauth for Claude agents).

**What I did:** Applied the panel round-6 must-fix items from the three `request-changes` seats to `designs/claude-agent-credential-reauth.md`, pushed as a follow-up commit, and watched CI to green. Applied once; did **not** re-run the panel (the driver re-posts panel-7).

**Changes (commit `0e591f3`):**
- **critic** — `usage-exhausted` now carries the same signal-pinning + fail-closed discipline as `credential-invalid`: named the concrete distinguishing shapes (subscription usage-limit `error.type` on an HTTP 429 with reset time vs. 401/403 authentication-family; API-key billing/`insufficient_quota` vs. revoked-key `authentication_error`), version-pinned, and where a 401/403 can't positively separate budget-vs-credential the outcome **fails closed to `unclassified`** (never `credential-invalid`, never `usage-exhausted`). Added a symmetric §8 acceptance criterion.
- **skeptic** — Covered the **factory admission point**: `create()`'s `needs-auth` is shared with `infer()` (only `unknown-model` is create-only), so the concierge's autonomous fire is armed on **both** host-side exos; added a §8 factory-path criterion. Hooked the **`unclassified` degrade** into the §3 admin-handle runbook (contact root / reassign operator) so it is actionable, not a dead-end FYI.
- **decomplector** — **Dropped** the unused standing send-capable `@claude-operator` handle. The concierge resolves the operator from its own root `iss+sub` and mediates all escalation and the reauth-complete wake, so no guest-held human channel is needed; scoped a general operator-messaging channel out as separate future authority. Cascaded through §1, §3 (four special names → three), §4, §6, §7, the sequence diagram, and §8.
- **Bonus (pre-existing defect):** the §6 mermaid diagram was already broken at HEAD — a semicolon in the `Note` text is parsed as a mermaid statement separator, which would render as a GitHub error box. Replaced it with an em dash and verified with `mermaid.parse()` (`OK sequence`).

**Verification:** committed with explicit pathspec (reverted an unrelated `package-lock.json` churn from worktree setup); pushed via `safe-push-pr-head.sh` (`4ff9cb8..0e591f3`, advanced cleanly); `ci-wait-merge.sh --no-merge` returned **rc 0 (CI GREEN)**, total=1 failed=0.

**Follow-ups:** none from me; the gauntlet driver re-posts panel-7 to re-review. PR remains draft (design carries an Open questions section, so it stays a review surface).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4561389 cached reads)
- Output: 34907 tokens
- Cost: $4.2107485
- Wall-clock: 615s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
