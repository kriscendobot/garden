## Retro report: kriscendobot/minion.town#146, review 5387502389

**Verdict: this was a review miss** (category `style-convention`, severity moderate). It joins the existing `prefer-endo-primitives` cluster, which now has 9 misses across 9 PRs. The record is at `review-misses/misses/kriscendobot-minion.town-pr146-review-64a01f1e.md`, written with `review-miss-record.sh`: `count=9 status=improvement-dispatched recurrence=0`.

**What I checked myself:**
- **The review:** kriskowal's CHANGES_REQUESTED on head 1258647 asked to use the upstream `@endo/cancel` JavaScript package directly, fixing its TypeScript support upstream if needed. The PR had instead added `src/endo/cancel-kit.ts`, a local TypeScript copy of that package's code, because the package has no npm release yet.
- **Why it's a miss:** #146 was the follow-up to the #140 miss, which is already in this cluster and was literally "use endo/cancel." The rule against re-writing code a package already provides was already on the books twice:
  - the purist seat's "reuse over re-implementation" check (37b04ec909, 2026-08-04);
  - the build-vs-buy skill (2026-09-24).
- **What the panel did:** it ran two full rounds before the review (`panel-runs/kriscendobot-minion.town-146/677588ce0f46.md` and the round-2 run). Every seat that noticed the copy called it a "faithful vendored port" and accepted "the package is unpublished" as the reason. Purist only commented and then approved; procurer only commented.
- **Why the automated check couldn't fire:** the journal has no `config/export-index-providers` file, so the endo packages' exports are never indexed for minion.town. On top of that, a package the repo doesn't depend on yet is classed `blocked`, and both the pre-push probe and the procurer seat stay silent on `blocked` hits.
- **The primary job did its work:** the PR merged on `@endo/cancel` from the dev registry, and `cancel-kit.ts` is gone. No mismatch with what the primary reported.

**Threshold decision: hold, and ask the maintainer.** The cluster is still marked `improvement-dispatched`, which stops a new dispatch automatically. Nothing is in flight on the board (`todo/`, `doing/`, `plan/`). But the cluster's fixes landed on 08-04 and 09-24, and three misses have arrived since (endojs/endo-but-for-bots#1336, kriscendobot/minion.town#140, #146). Those are really repeats after the fix. The recorder can't flag them because the cluster was never marked closed. The skill says a second improvement round shouldn't start on autopilot, so I sent the maintainer a message (`msg-kriscendobot-minion.town-pr146-review-64a01f1e-retro-40202fed3594`) proposing round 2 and asking for "dispatch" or "hold":
- create `config/export-index-providers` and point minion.town at `endojs/endo-but-for-bots@llm`;
- report an `@endo/*` package that isn't a dependency yet as a should-fix finding ("add the dependency") instead of staying silent;
- add a builder/purist rule: an unpublished upstream package is no reason to copy it in; consume it from the dev registry or git, or fix it upstream.

**Follow-ups:**
- If the maintainer replies "dispatch", post the builder job `review-improve-prefer-endo-primitives-r2`.
- Separate problem with the recorder: a cluster left at `improvement-dispatched` after its fix has landed (`improved_by` is set) never becomes `closed`, so later repeats are never flagged as recurrences. The writer or the improvement job should close the cluster once the fix commit lands.

Self-improvement: the skill's recurrence section assumes improvement jobs close their clusters. This one didn't, so I escalated by hand. Fixing that close-out is the follow-up above.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr146-review-64a01f1e-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1211079 cached reads)
- Output: 10293 tokens
- Cost: $1.0582678
- Wall-clock: 129s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
