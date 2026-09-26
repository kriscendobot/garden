CI is GREEN (all 5 checks, 0 failed, rc 0). The fix stage is complete.

## Completion report

**Stage: FIX round 3 — endojs/endo-but-for-bots PR #995** (`design(endo-claude)`, a design-doc-only PR).

**Re-derived state on this clean restart.** Panel round 3 completed at 07:37 with a **must-fix** verdict, posted as a PR *comment* (not a review, since `gh pr review --request-changes` is refused on the bot's own PR): [#issuecomment-5306341883](https://github.com/endojs/endo-but-for-bots/pull/995#issuecomment-5306341883). fix-3 was then posted and cycled through several free-tier workers (cleric, hermit) that hit usage-requeue and were reaped before I claimed it. No prior fix-3 work was committed, so I applied the whole set fresh at PR head `5775f93dcd`.

**What I did** — all edits in `designs/endo-claude.md`, pushed as commit `f83464a877`:

Must-fix:
1. **Reconciled `infer`'s export shape.** Settled it as the guarded, hardened, **passable exo** of Design Decision 8. Fixed the Package-shape tree (was "the harness" / plain-function gloss), fixed the naming paragraph (which had contradicted DD8 by calling it "not a passable interface exchanged over CapTP"), and removed the Open-questions bullet that reopened it as unresolved. All statements now agree.
2. **Dropped the "optional" self-contradiction** on the `@endo/claude-sandbox` slice (it is required, not merely recommended, for any guest-influenced prompt).
3. **Swept all 51 em-dashes** from authored prose per `skills/em-dash-style` (period / parentheses / colon by reading), including one mermaid label. Verified zero remain and none were newly introduced.

Should-fix (applied to reduce further rounds; all localized prose):
4. Added **`--disable-slash-commands`** as a load-bearing flag (verified present on 2.1.232, "Disable all skills"): `--tools ""` empties the built-in set but `/skill-name` is parsed from prompt text, a real confinement gap. Updated the mermaid, flag table (new row), DD1, the fail-closed section, and the negative-confinement test.
5. Fixed the build-sequencing **"same bearer"** claim to match the routing model (stdio carries no bearer; v1→v2 is an isolation-topology change, and the config path is `--mcp-config`, not `--strict-mcp-config`).
6. **DD4**: named the confidentiality obligation where the formula id is both the loggable routing designator and the HTTP bearer, or mint a distinct bearer.
7. Separated the pool **`acquire`** selection policy from the issue/revoke mechanism as a swappable seam.
8. **Gated the transport recommendation's** credential/billing shape on the DD5 `apiKeyHelper`-subscription residual; noted (b)'s dependency on the agent-tools MCP adapter groundwork.

**Result.** Pushed to PR head via `safe-push-pr-head.sh` (advance mode, `5775f93dcd0 → f83464a8778`). CI watched to terminal: **GREEN** (5/5 checks, 0 failed). Stage complete; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 190 tokens (12283984 cached reads)
- Output: 65860 tokens
- Cost: $9.324946000000004 (4 engagement(s) unpriced)
- Wall-clock: 1370s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
