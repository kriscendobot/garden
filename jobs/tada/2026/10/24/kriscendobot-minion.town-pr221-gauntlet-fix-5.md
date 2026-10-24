Fix round 5 for kriscendobot/minion.town PR #221 is pushed as commit `012ffb8d` on `design/recursive-dynamodb-capabilities`, and CI is green (`ci-wait-merge` rc 0, 3 of 3 checks passed).

No prepass block was attached to this job, so I worked from the latest panel verdict, review 5636900142 on head `1087ba1a`. The change is to `designs/recursive-dynamodb-capabilities.md` only: 264 lines added, 291 removed.

**Must-fix items:**
- **Decomplector #1 (specified surface with no consumer):** I removed the guard language, the `cancelled` promise a deriver could hold, `control.lineage`, and the mechanism for revoking one caplet-derived child without its siblings. I removed the guard tests that went with them and added a short out-of-scope note.
  - **Judgement call — I kept the recursive `derive` method and its ancestor checks.** kriskowal's mandate on PR #144 explicitly asks for recursive partitioning, so removing it would contradict the request. §10 now gives that reason. If panel-6 still objects, this is the point to settle.
- **Copyeditor #1 (ambiguous `derive` scope):** §10 now says plainly that `derive` is a method on the facet, not an entry in the §3.4 operation set, and that the first build ships the facet without it.

**Should-fix and comment items I also applied:**
- **Decomplector #2 and #3:** I replaced the `GrantStore` persistence port, grant names and tombstones with the supervisor's existing launch declaration as the only durable grant record. A withdrawal that survives restart means removing the grant from the declaration and then calling `control.withdraw`. §§6.1–6.3, the §7 ownership map and the §9 tests are rewritten to match.
- **Skeptic #1:** new §8.2 writes out the concrete coupon root restriction, using the attributes from the PR 199 adapter's code. It checks the restriction against every §3 rule. This also fixed an error in the old text, which said the base key space was only `COUPON#` and `BOOK#`. `POOL`, `ID#` and `RUN#` are also in it, and they stay out of the index only because they carry no `queue` attribute.
- **Skeptic #3:** the rollout no longer depends on a per-host revision report that doesn't exist. A new phase 5 repeats the convergence check daily for a week after cutover, with a rollback runbook.
- **Skeptic #4:** added what the operator does when the recount alerts several days running.
- **Skeptic #5:** noted that splitting a status partition into buckets also changes the cursor and audit digests.
- **Copyeditor #2–#7:** defined `SafeReason`, named the package where the text said "layer", fixed the unclear pronoun and the use of "rejecting", replaced "ahead of", and rewrapped long lines.
- **Skeptic #2** was about guards on updated fields; it no longer applies now that guards are gone.

I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr221-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2250307 cached reads)
- Output: 26173 tokens
- Cost: $1.8348174000000006
- Wall-clock: 581s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
