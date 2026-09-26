Gauntlet FIX round 6 complete for kriscendobot/minion.town PR #97 (`designs/claude-agents-capability.md`).

**What I did**

Read the latest panel verdict (round 6, must-fix) and applied its request-changes-seat items plus the actionable should-fix findings, in one pass, to the design doc:

- **novice (must-fix):** added a forward-pointer to "forms" at its first, load-bearing use (§ Problem and scope), and stated the garden-arc acceptance condition up front with a reference to § Meeting arc item 2.
- **copyeditor (request-changes):** glossed `ClaudeCredentials`/"caplet" on first use in the demotion bullet; fixed the ungrammatical "strand … contention `subscription-busy`" sentence; repaired the dangling "no in-place mutation … to add two fields to" construction.
- **critic (request-changes):** characterized the inbox-watch trigger population's cardinality (bounded to the child's CapTP connection set the root controls) and added a per-child inbox-watch rate cap that bounds sustained flooding, with a matching acceptance-evidence bullet that exercises flooding, not just one-shot contention.
- **skeptic:** deferred multi-root isolation and forwarding reach explicitly in § Open questions; added a per-root-isolation acceptance bullet; hedged the `delegationId`-keyed ledger as a not-yet-confirmed host-side primitive.
- **decomplector:** added a paragraph reconciling directory-structural confinement (for `create`d children) vs the `delegationId`-ledger accounting (for delegation-created children), stating how they compose.
- **ergonomist:** renamed `ClaudeAccount` → `RootClaudeAccount` for a uniform "Root-prefix means privileged" convention across both type families, and pinned `create`'s option-drift behavior (options bound at first creation, advisory-only on a cache hit).
- **pedant:** dropped the bold lead-ins from the four new Decisions bullets to restore list parallelism.

Also converted the 10 em dashes my own additions introduced to colons/parentheses (the doc is deliberately em-dash-free per the em-dash-style skill) and verified no other non-typist glyphs.

**What changed:** one commit `32bea92` on the PR head branch `design/claude-agents-root-endowment` (design doc only; the incidental `package-lock.json` churn from worktree setup was reverted, not committed). Pushed via `safe-push-pr-head.sh` (advanced cleanly, rc 0).

**CI:** GREEN (`ci-wait-merge.sh` rc 0, 1/1 check passed).

**Follow-ups:** I did not attempt novice #3 (moving heavy interface-comment rationale into prose) or ergonomist #3 (`submit`/`resolve` verb note) — both comment-only should-fixes and larger restructures better left to the maintainer's judgment. The driver re-posts panel-7 per the staged gauntlet.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (4372561 cached reads)
- Output: 26452 tokens
- Cost: $3.7409245
- Wall-clock: 485s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
