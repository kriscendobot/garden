CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** kriscendobot/minion.town PR #97 gauntlet — FIX round 3. Design doc `designs/claude-agents-capability.md`.

Applied the round-3 design panel's request-changes items in one pass, pushed as a follow-up commit (`9bd7ae9`) to the PR head `design/claude-agents-root-endowment`, and watched CI to terminal: **GREEN** (rc 0, 1 check, 0 failed).

**Must-fix items resolved:**
- **critic F1 (de-endowment path):** added a *De-endowing a root (demotion)* subsection — a live `rootSubjects` check on the introduced facet's mutating methods plus `ClaudeCredentials` teardown on demotion so a removed `iss+sub` cannot re-arm; wired a step-3 acceptance probe and evidence bullet.
- **skeptic (child facet export path):** added a paragraph analyzing a `create`d child mail-attaching its own `@claude-agents` facet — no amplification, not separately enumerable but fully revocable via `dismiss` of the child; strengthened `dismiss` to specify recursive subtree teardown.
- **decomplector 1 (fail-open `[]`):** stated that reconciliation and revocation read the persisted directory-backed set *directly*, never the fail-open `list()`/`listDelegations()` facet; annotated both facet comments as operator-facing display reads.
- **pedant/copyeditor/novice (cross-references):** fixed the dangling `§ Confinement canary` → "Production sequence step 4" and `§ Identifying the root account` → its containing section + run-in label.

**Should-fix items also applied** (strong panel consensus, to converge round 4): `delegate(label, { maxChildren })` with both required (F3/F4); `create` success tag `provided`→`created` (ergonomist); `agent-limit-reached` carries `scope: "subscription" | "delegation"`; `listDelegations` returns `DelegationInfo` records; attenuation re-expressed as base `ClaudeAgents` + `RootClaudeAgents extends` (no `Omit`, decomplector 2); persisted lease is a wall-clock/epoch deadline not monotonic (skeptic); `models()` two-plan evidence reframed as unit-test-plus-single-canary with the two-real-plan check deferred to Open questions (critic F5/skeptic); inbox-watch flow's trigger/authorization surface change stated, wired into step 2, and given an acceptance bullet (critic F2/skeptic); "host is the root" clarified as the operator role distinct from the daemon `@host` (novice); plus copyedit/pedant mechanical fixes (`-ly` hyphens, `i.e.`→"that is", `+`→"and", double-colon split, nested-parenthetical `InferResult` gloss promoted).

Committed only the design file (reverted an incidental `package-lock.json` cache-warm change). No banned code points introduced.

**Follow-ups:** none owned by this stage — the gauntlet driver re-posts panel-4. A couple of purely-stylistic should-fixes (pedant's italic-plus-quotation-marks redundancy; some pre-existing colon/hyphen instances outside touched paragraphs) were left as noted comment-level items.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 164 tokens (10516620 cached reads)
- Output: 58049 tokens
- Cost: $8.326989000000003
- Wall-clock: 896s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
