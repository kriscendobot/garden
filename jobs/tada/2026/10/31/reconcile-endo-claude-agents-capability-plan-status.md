The M3 plan record `endo-claude-agents-capability` now matches the real PR state, so it no longer looks like unstarted work. Both edits are on `origin/journal2`, and I confirmed the new frontmatter there.

**What was wrong:** the record (`plan/designs/endo-but-for-bots/endo-claude-agents-capability.md`) still said `status: Proposed` and `pr: endo-but-for-bots#1102`. #1102 was closed without merging on 2026-09-29. The design and build had already been redone on 2026-10-26: design PR #1558 is open and out of draft but not yet approved by the maintainer, and the first build slice, #1560, is open. The foreman hashes these plan records into what it reads when choosing the next step, so a `Proposed` record pointing at a closed PR was inviting another build dispatch.

**What I changed:**
- **The record:** status is now `In Progress`, `pr` is now `endo-but-for-bots#1560`, and `updated` is 2026-10-31. The body now:
  - marks #1102 closed and says not to re-weave, re-gauntlet or re-dispatch it;
  - names #1558 as the successor design and #1560 as the first slice, and says the build was already dispatched (`build-endo-claude-agents-capability-20261026`), so no further `build-endo-claude-agents-capability*` job should be posted;
  - points the remaining slices to the parked `build-endo-child-agent-factory-slice-2` job (blocked on #1560);
  - ends with a note recording this reconciliation.
- **The companion record** `endo-claude.md`: its link to this design now names #1558 and #1560 instead of #1102.

Both landed through `land-journal-edit.sh` with `GARDEN_EDITABLE_TREES=plan`. I left `plan/README.md` alone because it is generated; the bulletin loop re-renders it from the records.

**Follow-ups:**
- **Early Complete risk:** the weekly reconcile marks a record `Complete` as soon as its `pr` merges. #1560 is only the first slice, so its merge would mark this design `Complete` too early. The record body warns about this, but someone needs to reset the status by hand if it happens.
- **Validation:** `validate.sh` fails on one error I didn't cause: `daemon-docker-selfhost.md` uses the status `Declined`, which isn't in the allowed list.
- **Another stale record:** `endo-claude` is still `In Progress` even though its PR #1015 merged on 2026-09-29. The weekly reconcile should flip it to `Complete`; I left it unchanged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reconcile-endo-claude-agents-capability-plan-status.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (980194 cached reads)
- Output: 6246 tokens
- Cost: $0.8247747999999999
- Wall-clock: 86s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
