Fix stage complete. CI is green.

## Completion report

**Stage:** FIX round 2 of gauntlet `kriscendobot-minion.town-pr97-gauntlet` on PR #97 (kriscendobot/minion.town, `docs(claude-agents): reconcile design to root-only endowment amendment`). This is a docs-only PR editing `designs/claude-agents-capability.md`.

**What I did:** Read the latest panel verdict (round-2, posted 19:40:55Z) and applied its must-fix and should-fix items once, in an isolated project worktree off the PR head (`b335393`):

- **critic** — Made revocation a callable interface: added root-only `revoke(delegationId)` and `listDelegations()`, `delegate()` now returns a `delegationId`, and the live-delegation set is persisted host-side so the root can revoke a grant even after losing the handle or a restart. Stopped reusing the "introduction"/"facet-per-introduction" term of art for delegation (it reuses only the *attenuation*, lands as an ordinary revocable adopted capability, explicitly not an `introducedSpecialNames` introduction).
- **skeptic** — Stated forwardability of the delegated sub-factory (forwarding is possible but grants no amplification; same `delegationId`/sub-namespace/pool, one `revoke` tears down all holders) and added the forwarding canary; added a canary revoking the root's own subscription while a delegated peer has live/pending inference; cited build #87's seams by file at its pinned draft head (`b6280ed`) with a drift caveat.
- **decomplector** — Made `delegate()` idempotent-by-`label` matching `create()`'s retry-safety (and flagged the no-label call as not retry-safe); specified the CapTP inbox-watch flow as one discrete `infer` per message (not a standing lease), composing with the single in-flight slot.
- **ergonomist** — Carved `list`/`models`/`listDelegations` out of the never-reject "every method" claim as non-mutating fail-open reads; updated `DelegatedClaudeAgents = Omit<…, "delegate"|"listDelegations"|"revoke">` and the two Decisions bullets.
- **copyeditor/novice/pedant** — Split the opening nested-gloss paragraph and the diagram-walkthrough run-on, moved the `DelegatedClaudeAgents` definition and the eight-descendant parenthetical to where they're grounded, rewrapped over-width lines, defined the MCP/CapTP flow terms before use, hyphenated `root-only` in the diagram.
- **orthographer** — Renamed the coined `cancelled` option to `canceled` (11 sites).

Also caught and fixed three em-dashes I had introduced (panel's em-dash rule), and kept the accidental `package-lock.json` warm-cache change out of the commit (staged the design file only).

**What changed:** one commit `9a0af56` (design file only, +265/−123), pushed to the PR head via `safe-push-pr-head.sh` (`b335393..9a0af56`).

**CI:** `ci-wait-merge.sh … --no-merge` returned rc 0 — **CI GREEN** (1 check, 0 failed).

**Follow-ups:** none from this stage. The driver re-posts panel-3 to re-review these fixes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (6424383 cached reads)
- Output: 40773 tokens
- Cost: $5.506315500000001
- Wall-clock: 708s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
