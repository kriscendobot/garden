CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1228-gauntlet-fix-5 — FIX round 5 for PR #1228 (`design(claude): finish the bare CLI caplet contract`), a docs-only design PR.

**Panel verdict (round 5):** disposition **must-fix**. Request-changes seats: critic, skeptic, copyeditor, novice (decomplector, ergonomist, pedant comment/should-fix; orthographer approve).

**Applied to `designs/endo-claude.md` + `designs/README.md`** (one follow-up commit `d4e62f7ec`, pushed via `safe-push-pr-head.sh --mode advance`, `58426da73..d4e62f7ec`):

- **novice (must-fix):** reconciled the stale "confined `claude -p` harness" leftover on the old line 891 to the § Status vocabulary convention ("unconfined host harness that spawns the tool-surface-confined child"); grep-swept the whole doc for other `confined` violations (none remained).
- **copyeditor #1 (explicit must-fix):** changed the lone "per-session" reference to PR #1206 to "one-guest," matching every other reference.
- **critic #1:** added a § Status statement that the tool-surface narrowing is architectural and reached independently of PR #1015's sunk scope, not a backfill of already-written code.
- **critic #2 / skeptic #2:** added a DD6 paragraph stating the design's own primary/default topology (co-located, loopback) *triggers* the cross-guest residual, so under the recommended default the only truthful attestation is `co-located-accepted` and the gate is record-keeping, not mitigation.
- **skeptic #1:** folded subscription-tier credential verification into acceptance-condition step 4 (assert the helper presented a subscription token, fail the run on a silently-substituted metered key or dropped `--bare`) rather than deferring to the work list.
- **copyeditor #2/#3/#4, pedant #1, copyeditor #5 (should/comment):** un-parenthesized the ~5-sentence argv-residual aside and acceptance step 6; recast the "influence≡prompt" equation and step-3 to verb-first parallel construction; de-duplicated the README "narrowing" sentence.

**Notes / non-changes:** the decomplector/ergonomist `options.isolation` → `isolationAttestation` rename (should-fix/comment-only) and novice's "move/trim § Status" (should-fix) were left as maintainer-owned design-shape calls; DD6 already carries the "unverified attestation, not a verified control" hedge extensively. Restored a spurious `packages/floot/package.json` em-dash change introduced by the install step (not part of the diff). Kept my new prose em-dash-free.

**CI:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge` → **rc 0, CI GREEN** (7/7 checks, 0 failed). Did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2719890 cached reads)
- Output: 18063 tokens
- Cost: $2.6227030000000013
- Wall-clock: 866s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
