Validation complete. Final state verified: canary in `tada`, pool at zero, doc committed.

## Report

**Fireworks lane validated end to end.** Canary `fireworks-canary-20260728-glm52` ran on the fireworker lane, reached `jobs/tada/` with its exact marker, and the pool was returned to zero.

**Wire id: `fireworks/accounts/fireworks/models/glm-5p2`.** Resolved by listing `GET $GARDEN_FIREWORKS_BASE_URL/models` and extracting ids only (five Serverless ids live on the account; no body persisted). Confirmed with `resolve_model_tier fireworks fireworks/accounts/fireworks/models/glm-5p2`, which echoed the id back. The routing table row is `fireworks<TAB>fireworks/*`, so classification only enforces the namespace — the liveness check has to come from the provider, which is the point of the design.

**Auth probe: HTTP 200**, status code only — no `-v`, no headers, no body, no fixture. The key was touched by name only throughout.

**End-to-end verification:**
- **Marker** — report contains `CANARY-MARKER: fireworks-canary-glm52-ok`, read back exactly after a real tool action (create → read → `rm`).
- **Claim gate held, observed directly.** All eight gardeners (anthropic), the cleric (openai), and the mystic (moonshot) each declined with `pinned to a model this <kind> cannot honor; skipping (backend-fit)`. Only the fireworker claimed it. The explicit-model-only property is intact.
- **Reputation scoping is correct** — the shared-handler risk did *not* materialize. Event carries `kind: fireworker`, `provider: fireworks`, `model: fireworks/accounts/fireworks/models/glm-5p2`, `recorded_by: …/fireworker-1`. Not openai/anthropic/moonshot/local.
- **No side effects** — no commit on `main2` in the run window, no stray marker file anywhere.

**One caveat, stated plainly:** the `git status --porcelain` clean result is the canary's own report — its worktree was torn down on completion before I could re-run the check independently. I corroborated externally (no commits, no stray files) rather than directly.

**Token data: the codex lane emits none.** The successful canary's ledger row was `{"outcome":"tada","source":"none","elapsed_s":8}` — `complete-job.sh`'s fallback, no token fields. The handler *has* a parse path (jq over codex's terminal `token_count` event, `cleric-codex.sh:~258`); it yielded nothing. This is **codex-lane-wide, not a Fireworks defect**: of 110 ledger rows with `source: "result"` and real tokens/dollars, every one is the anthropic/claude lane; no codex-lane row has ever carried tokens.

**Correcting a stale premise in the job spec:** "all 1377 events censored, no lane writes a usage ledger" no longer holds — the anthropic lane now writes real tokens and dollars (commit `11d0e8655f`, landed today after the spec was written). The remaining gap is the codex lane specifically. Sent this to the live `wallclock-cost-proxy-for-censored-arms` job, since wall-clock *is* reliably recorded for codex runs, which makes a wall-clock proxy well-founded for exactly that lane.

**Pool returned to `fireworkers: 0`** (maintainer did not authorize a larger trial); `garden-fireworker@1` unit removed. Note the host now carries an *explicit* `0` where it previously had no line — operationally identical, but it records that the kind was considered and is deliberately off.

**Changed:** `context/operations/fireworks.md` — added a "Validated end to end" section recording the above (commit `caf95cd607` on `main2`). No secret, response body, or fixture appears in any commit, journal entry, or log.

**Follow-ups:**
1. Codex-lane token capture is broken or unsupported — either codex emits no `token_count` for a custom OpenAI-compatible provider, or the payload shape doesn't match the jq selector. Worth a targeted fix; until then every codex-lane arm (cleric, fireworker, hermit, mystic) stays `censored` and unmeasured. Weigh that before any Fireworks trial larger than a canary.
2. **Repo health:** every git operation in this worktree warns `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6 / failed to run repack`, with a stale `gc.log` blocking automatic cleanup on the shared `/home/kris/garden2/.git`. Pushes still succeed. I did not attempt repair — that repo is shared with the journal worktree and is exactly the surface the 07-17/07-21 incident warns about. Flagging for deliberate handling.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/validate-fireworks-job-end-to-end.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 77 tokens (2850599 cached reads)
- Output: 20535 tokens
- Cost: $2.6888795
- Wall-clock: 612s

<!-- garden-usage-end -->
