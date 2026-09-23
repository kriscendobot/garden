CI is GREEN (rc 0). The fix is pushed and CI passed. 

## Completion report

**Job:** gauntlet FIX round 1 — kriscendobot/minion.town PR #37 (`design(mail): ocap mailboxes`), a docs-only design PR (`designs/ocap-mailboxes.md`).

**What I did:** Read the latest panel verdict (design-panel round 1, review `4956981720`, disposition **must-fix**) and applied every seat's must-fix and should-fix items in a single follow-up commit (`7798593`), pushed to the PR head via `safe-push-pr-head.sh` (advance mode), then watched CI to terminal.

**Changes applied (`+232 / -113`):**
- **critic must-fix / skeptic / decomplector** — reconciled §8's `<formula-id>@minion.town` scheme with §4's opacity rule: new paragraph distinguishing a bot's own *published inbound* address (a router-facing string, not a bearer reference, no live-reference amplification) from a *held* handle's opaque correspondent identity; named the rotation address-churn as a deliberate default and deferred the unit-of-rotation to §11 (removing the §8-vs-§10 "already answered / still open" contradiction).
- **decomplector must-fix / critic note** — decomposed the atomic `admin` facet into independently-grantable `admin.identity` / `admin.audit` / `admin.breaker` sub-facets; stated the platform holds them at provisioning.
- **ergonomist** — renamed `directory` facet → `intake` (collision with the Endo guest's pet-name directory); restated revoke authority as rejecting the retained `cancelled` promise (no imperative `revoke()`); defined async-bounce visibility (typed delivery-status message to the sender's `inbox`).
- **skeptic** — added new §9 "Threat model and acceptance criteria"; labeled §8's external edge by direction (inbound/outbound).
- **novice / critic (comment-only)** — glossed "locator"; weighed the SES-native ACL alternative in §2.
- **pedant / copyeditor** — swept all 45 em-dashes to periods/colons/parens (judgment rewrites), arrows/ellipsis/`⇄` → ASCII in prose and mermaid labels, en-dash section ranges → hyphens, plus the five copyeditor prose fixes (§§1, 4, 5, 6, 8). Renumbered prior-art → §10, open questions → §11, and updated all cross-references.

**Verification:** em-dash grep clean; `typist-friendly-code-points.sh` probe passes; CI (test: typecheck + vitest) GREEN — `total=1 failed=0` (docs-only change does not touch the code suite).

**Follow-ups:** none. Per the staged-gauntlet contract I stop here without re-running the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr37-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (2288233 cached reads)
- Output: 43064 tokens
- Cost: $3.2122755
- Wall-clock: 628s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
