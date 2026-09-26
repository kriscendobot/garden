CI is green. The fix stage is complete.

## Completion report

**Job:** FIX round 2 for kriscendobot/minion.town PR #64 (`design/claude-agents-capability`), a design-document PR.

**What I did:** Read the panel round-2 request-changes verdict (5 seats request changes, 2 comment-only) and applied every must-fix and should-fix item, plus the cheap comment-only polish, to `designs/claude-agents-capability.md` in an isolated project worktree.

**Changes (one follow-up commit, `5fb1db0`):**
- **Interface signatures (critic, ergonomist, decomplector):** Widened `ClaudeAgent.run` to `Promise<InferResult | { type: "needs-auth" } | { type: "pool-exhausted" }>` — now resolves tagged sentinels instead of rejecting, matching `create`'s convention. This fixed both the missing `needs-auth` resolution the prose promised and the resolve-vs-reject inconsistency for `pool-exhausted`.
- **`@claude-account` surface (skeptic):** Added a typed `ClaudeAccount` interface (`connect`/`status`/`disconnect`), bounded why re-introducing it into every prompt-driven descendant is safe (no secret, single-`iss+sub` scope), and made the confinement canary probe that surface directly.
- **Quota counter (critic, skeptic, decomplector):** Stated where the retained-child counter lives (one host-side per-user ledger), that its check-and-increment is atomic/serialized against concurrent `create`, and that dismissing a child reclaims its slot. Added concurrent-boundary and reclaim tests to the acceptance evidence.
- **Undefined terms (novice):** Glossed "special names" and "introduction" on first use; added `list()` prose and a `provideGuest` forward pointer (novice, ergonomist).
- **Polish (copyeditor, pedant):** `iss+sub` gloss on first use and diagram-label spacing, `platformNames` subject-verb fix, pronoun disambiguation in the containment paragraph, harmonized citation form.
- Kept the doc em-dash-free per `skills/em-dash-style` (recast my draft's em-dashes to parentheses) and verified no typist-hostile code points.

**Push & CI:** Safe-pushed as a review-feedback follow-up commit (advance mode, `73f42c6..5fb1db0`). CI went **green** (rc 0) within seconds.

**Follow-ups:** None. The driver re-posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr64-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 61 tokens (2335150 cached reads)
- Output: 20594 tokens
- Cost: $2.407623
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
