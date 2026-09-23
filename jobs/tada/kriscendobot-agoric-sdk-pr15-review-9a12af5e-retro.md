Inbox empty. Work complete.

## Completion report

**Job:** prosecutor / review-retrospective second loop on kriscendobot/agoric-sdk PR #15 review `4726486961` (primary `kriscendobot-agoric-sdk-pr15-review-9a12af5e`).

**Idempotency:** clear — no prior `misses/` or `dismissed/` record for this base.

**Discrimination → MISS (spec-violation).** dckc's inline note asked why `withdrawHandler.handle` used `returns(M.any())` when its static return type is precisely known (`` `flow${number}` ``); the primary loop tightened it to the already-exported `FlowKeyShape`/`M.promise()`. Grounded in the PR's actual review history: the full 16-seat `kriscendobot-agoric-sdk-pr15-gauntlet` returned unanimous approve and affirmatively praised the loose guards as "compatibility-first / upgrade-safe," after which the maintainer hand-filed a cascade of guard-tightening reviews. No code-panel seat carries the guard-tightness-vs-known-type lens (`missed_by: spec-keeper`). Applies the repo's own standing `CONTRIBUTING` § TypedPatterns convention — a documented rule with in-repo precedent, not new direction.

**Recorded & clustered:** joined `exo-guard-matches-static-type` → **count=3** (third `severity: major` member, all PR #15). Verified landed on `origin/journal2`.

**Threshold → DISPATCHED (severity bypass).** Plain floor's two-PR requirement is unmet (single PR), but the bypass squarely applies: a third `severity: major` miss whose grounds cite a standing rule that already existed and did not bind. The two-PR guard rejects coincidental co-located bugs; this is one structural review-lens gap demonstrated three times, general to every future agoric-sdk exo-guard PR. Rationale recorded; cluster marked `improvement-dispatched` with `improvement_job` set.

**Improvement job posted:** `review-improve-exo-guard-matches-static-type` (identity `review-cluster:exo-guard-matches-static-type`), builder tier, with the mandatory two-part contract — **(a) prevention** (encode the TypedPatterns guard-tightness discipline in the narrowest builder-facing artifact) and **(b) sensing** (amend the spec-keeper seat brief + add a `panel-hints` probe that fires on the loose-guard diff signal, same commit) — plus a per-member re-litigation test over all three misses. The job is already claimed (`jobs/doin/`).

**Journal:** `result` entry `163845Z-result-gardener-b24860.md`.

**Changes:** journal2 only (miss record, cluster status, improvement job, result entry) — all via the sanctioned CAS writers. No garden `main2` changes from this prosecutor job; the code/probe edits are the dispatched builder's deliverable. **Follow-ups:** none from me — watch the builder job to closure (it will `cluster-status … closed`).
