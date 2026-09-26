CI is GREEN (rc 0). All six panel round-3 must-fix items are applied, pushed, and verified.

## Completion report

**Job:** endojs/endo-but-for-bots PR #997 — gauntlet FIX round 3 (docs-only design PR).

**What I did:** Read the round-3 panel verdict (request-changes, 6 seats) and applied all six must-fix items to the two-file diff (`designs/worker-retention-and-revocation.md` + `designs/README.md`), verifying the code-citation findings directly against the head worktree's `packages/captp/src/captp.js` before editing.

**Changes (commit `f341840e9`, pushed via `safe-push-pr-head.sh --mode advance`, `2cfe72550..f341840e9`):**
1. **README milestone contradiction** — placed the design uniformly in **M4 (Networking)**: moved the catalog row from the M3 table to M4 beside `ocapn-orthogonal-persistence`, now consistent with the per-design estimate table (M4) and the Mermaid OCapN subgraph.
2. **"partition-shaped" claim** — corrected Q1's arrival-after-collection rule: verified `convertSlotToVal` throws `Unknown export` at `captp.js:708` before any `CTP_RETURN` and `dispatch`'s `quietReject(returnIt=false)` (`:320-336`, `:1021`) sends no reply → the caller's question hangs silently. Named "reply with an explicit rejection on `Unknown export`" as a concrete prerequisite.
3. **Race gaps** — added the lease-expiry-vs-resolution race (idempotent single-owner drop) and admission-cap check-then-mint TOCTOU (single-mutation check-and-mint) as an explicit fifth window; recorded diamond/N-referrer and gift-id replay as Open Questions.
4. **Falsified "bounded against adversarial peers"** — extended the per-root lease to bound the whole retention interval (incl. the post-resolution cross-peer wait a withholding peer can pin); qualified the recommendation and DD6.
5. **Nonexistent `questions` Map** — fixed every citation to the real `settlers` Map (`captp.js:486`; `answers` at `:488`) across the Q4 body, Dependencies row, and Citations; dropped two non-verbatim `@endo/exo` taxonomy quote marks.
6. **Missing completion-summary comment** — posted one combined top-level comment covering all three rounds' head SHAs and must-fix items ([issuecomment-5306717029](https://github.com/endojs/endo-but-for-bots/pull/997#issuecomment-5306717029)).

**CI:** GREEN — `ci-wait-merge` rc 0, 5/5 checks passed, no merge (PR stays draft per gauntlet).

**Follow-up (non-blocking):** the round-2 whole-file `→`/`↔`→ASCII glyph sweep across historical README entries was not split into its own `chore(designs):` commit; noted in the summary comment for a follow-up if the reviewer wants the mechanical churn separated. The driver re-posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 105 tokens (5760212 cached reads)
- Output: 32614 tokens
- Cost: $4.962242999999998
- Wall-clock: 791s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
