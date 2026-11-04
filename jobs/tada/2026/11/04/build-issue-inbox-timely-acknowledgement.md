I built all four changes as separate commits and pushed them to `main2`. All tests pass. The status pass ships in dry run, and going live is parked as a follow-up.

**Commits (on `origin/main2`):**
1. `b61f46475f3`: **Latency checker runs its heartbeat checks under a REST latch.** The REST-cooldown and budget-deferral gates, at the start of the tick or partway through, used to exit before the heartbeat classification. Now they skip only the sweep that calls the GitHub API. The heartbeat checks and their notices run without any API call, so a REST latch that never lifts now raises `comment-watcher-stuck-cooldown-host`. A skipped sweep never closes a per-repo notice as "recovered" when it wasn't checked.
2. `4405509ba90`: **Heartbeats name the gate.**
   - `watcher_heartbeat_write` takes an optional `detail:` field, and a new `api_cooldown_detail` helper names the latch's owner and expiry.
   - The issue watcher's heartbeat now records the REST latch owner, the journal-outage marker, or the cursor-read return code.
   - A busy cursor-IO lock gets its own `cursor-busy` outcome; it used to be recorded as the `offline-journal` default.
   - The checker treats `cursor-busy` like the other latches (muted at first, then reported as stuck) and copies the detail into stuck notices.
3. `7bb1cbdf456`: **The ack predicate matches the watchers' first-line rule.** A new shared `comment_classify_exactly_addressed` check is used by the issue-inbox watcher, the PR comment watcher and the latency checker. The endo-but-for-bots blind notice **is the same class**: `comment-watcher.sh` also routes only on an exact first-line `@<bot> `, while the checker accepted `@bot` anywhere or any wording that reads as a request. So the checker was reporting correct drops as `never-acked:blind`, both there and on #117's comment.
4. `7f0c3f7cd1c`: **`scripts/jobs/issue-status-pass.sh` and `garden-issue-status.{service,timer}`.**
   - It runs every 120s on the leader only, uses no LLM, and keeps ticking under drain.
   - It skips the tick if the REST latch is live.
   - The maintainer gate (allowlist only) runs before any body is read. Arrivals are new open issues and comments addressed with the exact first-line `@<bot> `.
   - Any later bot comment counts as an answer. Thresholds follow the design (20 minutes, or 5 when 6+ jobs without `requires:` tokens are ahead, held up to 5 minutes after a claim but never past 25 minutes of age). It re-checks the comments just before posting.
   - The text is a fixed template filled only with job-board counts. Its only state is the `garden-status` marker in the comment, and it never closes an issue.
   - It ships with `GARDEN_ISSUE_STATUS_DRY_RUN=1`. That is set both in the unit and as the script's default.
   - `skills/issue-inbox/SKILL.md` and the Monitoring safety section of `CLAUDE.md` are updated.

**Tests:**
- `comment-latency-watch-test` passes, with new cases for: a held latch raising the stuck notice with no sweep, latch-owner detail, `cursor-busy` classification, and unaddressed comments no longer counted as needing an ack.
- `issue-inbox-watcher` 74/0, `tick-bounds` 23/0, `journal-linkage` 17/0, `comment-watcher-test` 489/0.
- The new `issue-status-pass-test.sh` passes. It covers:
  - the rule boundaries
  - the trust and address gates
  - closed issues
  - burst idempotency and a second tick posting nothing
  - suppression by a bot reply
  - the deep-queue count excluding pinned and `scholar-ingest-*` jobs
  - every template, with no issue text echoed
  - a REST cooldown followed by a successful tick
  - dry run

Not covered: an end-to-end replay of #128's timeline.

**Diagnosis report:** it never arrived. `diag-issue-inbox-gap-20261104-endolin` was still in `jobs/todo/` when I finished, and nothing came to my inbox. So the cause of the 03:37–04:32Z gap is **not confirmed**, and I added no fix aimed specifically at it. The leading guess is still a held REST latch on the leader. Once these changes deploy, the heartbeat `detail:` field and the stuck notice will name the gate if it happens again.

**Follow-up:** I parked `issue-status-pass-go-live` with `post-plan.sh`, deferred until 2026-11-05T12:00Z. It removes the dry-run flag after a day of leader logs match the rules. The flag has to be cleared in both places, the unit's `Environment=` line and the script default.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-issue-inbox-timely-acknowledgement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6275774 cached reads)
- Output: 38092 tokens
- Cost: $3.055498800000001
- Wall-clock: 986s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
