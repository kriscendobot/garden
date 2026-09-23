Inbox empty. Work complete and landed on `main2`.

## Completion report

**Job:** cybernetics-rec9-inbox-coalescing — implement rec 9 of `designs/cybernetics-audit.md` § 3.3/§ 7: extend the proven coalescing discipline to the raw maintainer-inbox path.

**What I did** (landed bare on `main2` as `5c1d9cd124`):

- **`inbox-send.sh`** — added an opt-in `GARDEN_MSG_COALESCE=1` mode. With a stable `GARDEN_MSG_ID` (the `(sender, episode)` key), a re-send now **amends the open unread entry in place** — `notice_count` bumps, `first_seen` preserved, `last_seen`/body refresh — under a **1 h per-key delivery throttle** (`GARDEN_MSG_COALESCE_THROTTLE_SECS`) whose suppressed occurrences are **counted and folded, never dropped**. Once the recipient drains the entry, a re-occurrence posts a fresh episode (same archive rule as `watchdog-notice.sh`). The default stable-id path keeps its idempotent-skip contract (the GitHub re-poll case) untouched, so existing callers (proxy, issue-inbox) are unaffected.
- **`orchestrate.sh` / `gauntlet.sh`** — `orch_notify`/`gauntlet_notify` now pass `GARDEN_MSG_COALESCE=1` with the subject as the episode key (already a stable `<base>`-condition key).
- **`follow-up-claude.sh`** (the follow-up liaison handler) — `route_rejected` and the `ENDMAINTAINER` producer coalesce on a message-content digest.
- **`message-user.sh`** — coalesces by default with a per-job, per-content episode key `msg-<doer>-<digest>`: a gardener re-reporting the same status folds, distinct messages keep their own entry (key on `(sender, episode)`, not sender alone). Pin `GARDEN_MSG_ID` or set `GARDEN_MSG_COALESCE=0` to override.
- **`skills/message-bus/SKILL.md`** — documented the coalescing contract.

**Boundaries honored:** messages are never discarded (per-sender/per-episode coalescing only); no digest built (that stays the telemetry ladder's rung); distinct human-authored messages from the same sender still get distinct ids.

**Verification:** new `scripts/jobs/test/inbox-coalesce-test.sh` (19 assertions, all pass) plus `run-test.sh` 379/0, `watchdog-notice-dedup` 23/0, `orchestrate` 51/0, `gauntlet` 38/0, follow-up + proxy focused tests, `tests/checks` 10 suites/0, `shellcheck -S warning` clean. Fixed one test coupling in `run-test.sh:1997` (it grep'd for the legacy `20*` timestamp id; message-user's new id format is `msg-<doer>-…`).

**Follow-ups:** none required. The audit doc follows a no-per-rec-status convention (rec 10's landing didn't annotate it either), so I left it unedited.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec9-inbox-coalescing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 220 tokens (14709210 cached reads)
- Output: 70842 tokens
- Cost: $10.281205000000002
- Wall-clock: 1244s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
