This PR adds a single design markdown file (`designs/claude-agent-credential-reauth.md`, 339 additions, 0 deletions) — spec only, no code, no packages touched. CI is GREEN at the current head (the `test` typecheck+vitest check passed at 19:04:56Z). There is no code coverage to run and no dead code the change could have orphaned. The clean stage is a genuine no-op.

## Completion report

**Job:** Gauntlet CLEAN stage for kriscendobot/minion.town PR #96.

**Findings:**
- PR #96 is a **design-only** change: one added file, `designs/claude-agent-credential-reauth.md` (+339/−0). No source packages are touched, so there is no coverage pass to run and no dead code the change could have orphaned.
- CI is **GREEN** at the current head — the `test (typecheck + vitest)` check reported `SUCCESS` (completed 2026-09-08T19:04:56Z), after the 19:42Z claim's underlying head.
- PR is OPEN and still draft (expected — the gauntlet's later un-draft stage handles that; this design also carries an `## Open questions` section, so it is intentionally a review surface).

**Actions taken:** None required. Idempotence check (step 1) resolved to a no-op: coverage trivially complete (no code), CI terminal-green. No checkout, no follow-up commits, no CI re-wait needed.

**Follow-ups:** None from this stage. The gauntlet proceeds to its next stage (panel review).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (90286 cached reads)
- Output: 1584 tokens
- Cost: $0.37978999999999996
- Wall-clock: 27s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
