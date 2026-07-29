Pushed to `main2` as `1dde198602`. Inbox is empty.

## Report

**Fixed:** `scripts/jobs/proxy.sh` § `park_blocked_jobs` wrote `plan/<base>.md` straight from the live `doin/`/`todo/` file. A `doin/` file carries the trailing `---`/`claim:` block `claim-job.sh` appends, and either may carry the reaper/gardener cycle markers. Both survived the round trip — `promote-plan.sh`'s `strip_frontmatter` removes only the *leading* plan block — so when the blocker cleared and `unblock.sh` promoted, the stale claim block rode back into `todo/` (a claim record for a run that had ended, reading as live provenance to anything that greps for it), and the counters rode back into the no-op-promotion trap the cycle-marker reset exists to close.

**Changes**
- `scripts/jobs/proxy.sh` — the lifted body now goes through `cut_claim_block | strip_cycle_markers`. The notification-body fallback (a job already off the board) is untouched: it has no claim block or markers by construction.
- `scripts/jobs/common.sh` — added `cut_claim_block` beside the existing cycle-marker section: the same last-`---`-followed-by-`claim:` anchor `clean_body` and the `stamp_*_hint` inserters use, so a body's own `---` rule survives and a claim-free body is never truncated.
- `scripts/jobs/promote-plan.sh` — comment now names the proxy park as a fourth sharer of the common helpers.
- `roles/proxy/AGENT.md` § Blocked-job parking — documents the clean-on-the-way-in step and why it has to happen at the park.
- New `scripts/jobs/test/proxy-park-body-hygiene-test.sh` (8 assertions).

**Reaper untouched, as specified.** Its poison park still writes a body whose `garden-deadline-overrun` counter persists (`promote-plan.sh` clears that at the promotion); Subtest 2 of the new test asserts exactly that, and `reaper-poison-park-test.sh` / `productive-cycle-test.sh` / `outage-poison-pause-test.sh` stay green.

**Verification.** The new guard fails 3 of its 8 assertions against the pre-fix `proxy.sh` and passes all 8 after — I validated this by temporarily reverting the one-line change. Full suite `run-test.sh` 368/368, `promote-plan-poison-reset-test.sh` 32/32, `annotate-plan-test.sh` 45/45, plus the three reaper tests above.

**Note on the rebase.** The push hit a conflict: sibling jobs had landed `strip_cycle_markers` + `cycle_marker_summary` into `common.sh` (the post-plan parking half and the annotate-plan half) while I worked. I resolved in favor of the landed shared helpers and dropped my duplicate definition, keeping only `cut_claim_block` as the new addition, then re-ran everything before pushing.

**Follow-up (not done, no defect observed).** A parked body lifted from `todo/` may carry that job's own leading `role:`/`model:` frontmatter, which then sits as text inside the plan body. `plan_field`'s whole-file first-match `sed` still finds those keys, so promotion currently preserves the pin by accident rather than by design — worth making explicit if anyone touches that parse.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fu-improve-promote-plan-poison-reset-3-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (5378026 cached reads)
- Output: 27364 tokens
- Cost: $4.4639630000000015
- Wall-clock: 547s

<!-- garden-usage-end -->
