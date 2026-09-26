Fix round 6 for kriscendobot/minion.town#119 is pushed as commit `2a54dce`, and CI on that head is green (3/3).

**What I fixed.** The panel raised four must-fix items, from the stylist, breaker and scribe seats:
- **Stuck parked agents (breaker):** `dismiss` could leave an agent in the parked list forever. That happened when the child directory no longer held the agent's name, so no id came back to release. `dismiss` now also finds the agent by the key it was created under (caller plus name) and releases that. The new `childKey` field on `ChildIncarnation` makes that lookup possible.
- **Silent disk-write failures (breaker):** the file-backed reauth store's delayed disk writes could fail without ever reaching operational alerting. They now raise one `state-unpersisted` alert per run of failures, naming the file path. A new `onWriteRecovered` option on `makeFileReauthStateStore` ends the run when a write succeeds again.
- **Rename (stylist):** `credentialCurrent` is now `isCredentialCurrent`, matching the package's other yes/no checks. All call sites are updated.
- **Summary comments (scribe):**
  - I edited the round 1–2 summary (comment 5843948648). Each of its five declined items now has a reason, and it has a line saying where the review loop stands.
  - I posted a round-6 summary (https://github.com/kriscendobot/minion.town/pull/119#issuecomment-5844609170) with the same status line. It says CI is green and panel round 7 comes next.

**Tests.** I added two tests to `test/claude-reauth.test.ts`. Both fail against the old head `22157b4` and pass on `2a54dce`. Typecheck is clean, and the full suite gives 536 passed and 7 skipped.

**Declined.** The breaker also noted that once a lapse is marked abandoned, no further notice or escalation is sent. That was comment-only and I deferred it, because this matches what design § 4 specifies; an escalation policy would be a design change. The reason is in the round-6 summary.

**Next:** the gauntlet driver runs panel round 7. Nothing else is needed from this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1884029 cached reads)
- Output: 14745 tokens
- Cost: $1.3029937999999996
- Wall-clock: 467s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
