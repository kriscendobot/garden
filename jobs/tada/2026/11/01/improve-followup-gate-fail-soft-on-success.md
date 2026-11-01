Finished: the follow-up gate no longer blocks a successful job whose `## Follow-ups` holds only advisory maintainer notes. It now sends those notes to the maintainer inbox and lets the job complete. Pushed to main2 as `6595aa9dff9`. The gate test suite and the design-build-handoff test both pass.

**What changed**
- **New check (`scripts/jobs/common.sh`):** `followup_item_is_advisory` marks one follow-up item as advisory when it is one of these:
  - a maintainer decision or option ("changeset decision (maintainer)", "maintainer's call", "if the maintainer wants…");
  - a CI status note (not yet reported, pending, unstable, "awaiting CI");
  - work that only happens after a future merge ("once #1560 merges, … needs retargeting").

  An item is never advisory if it says the work is warranted, owed now or immediately, or should be posted, dispatched, staged or scheduled. Saying that a watcher "will post" something later does not count as owed work. A new helper, `followup_section_items`, splits the section into items, joining wrapped lines.
- **What the gate counts as fleet work:** `followups_prescribe_fleet_work` now looks at each item and skips advisory ones for both its checks (an item opening with a verb like "Conduct", and the prose patterns).
- **What the gate counts as a "posted" claim (`assert-followup-posted.sh`):** this check also skips advisory items. Without that, "the CI watcher will post a shepherd" read as a claim of posted work and still blocked the job. I also updated the header doc.
- **Result:** a section made only of advisory notes now goes through the existing inbox escalation (`message-user.sh`, coalesced, `reply_to=<base>`), and the job completes once the message is confirmed on the board. If the escalation fails or doesn't land, the gate still blocks, so a lost note can't pass silently.
- **Regression test (d6 in `scripts/jobs/test/followup-posted-gate-test.sh`):** it uses a report shaped like the weave's (changeset decision, CI not yet reported, retargeting after merge) and checks that:
  - the gate passes and the notes reach the maintainer inbox;
  - a failed escalation still blocks;
  - owed work dressed as an advisory note still blocks ("warranted now", "a weave should be posted");
  - the original #910 / #876 cases are still not treated as advisory.

**Caveats**
- The original blocked report was no longer available (its temp file was gone, and the stored report is the later retry's). I rebuilt the test report from the three note kinds named in the job spec, so the exact wording that blocked at 19:33:48Z isn't covered.
- I didn't implement the spec's other option, completing any job whose work was already done whenever the gate blocks. It would also let real cases of unposted work through, like the original #910 and #876 incidents. Advisory notes now get to the inbox through the existing escalation instead.

**Follow-ups**
None.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-followup-gate-fail-soft-on-success.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2030167 cached reads)
- Output: 16404 tokens
- Cost: $1.3722733999999999
- Wall-clock: 1016s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
