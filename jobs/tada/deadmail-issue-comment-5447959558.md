Both halves of the dead-lettered intent are complete. Writing the report.

## Completion report

**Job:** dead-letter pickup — `issue-kriscendobot-garden-51` (the doer handling kriscendobot/garden issue #51, the Endor xs2rust / test262-coverage arc tracker) had already completed, so a maintainer comment couldn't be delivered to it.

**The intent:** @kriskowal commented on issue #51 — *"Please let each subsequent turn of the ratchet supplement or create a PR as needed."* The "ratchet" is the standing serial `test262-coverage-ratchet` press-driver. His concern: some recent turns recorded coverage advances only as local evidence on the issue without landing a PR.

**What I did:**
1. **Folded the directive into the ratchet's standing instructions.** Updated the `test262-coverage-ratchet` schedule body (via `set-schedule.sh`, CAS-pushed to `journal2` at commit `067cdafdac`; `last_dispatched` and `hourly` cadence preserved so it doesn't re-fire prematurely). Step 3 now mandates that **every turn land its coverage delta in a PR** — supplementing an already-open, still-draft ratchet PR for the same suite/family when the slice fits, or opening a fresh PR otherwise — and marks a turn that posts only issue prose without a PR as **incomplete**. Step 4 now requires each delta comment to name the PR (number/URL + commit).
2. **Replied on the issue thread** (https://github.com/kriscendobot/garden/issues/51#issuecomment-5448003470), acknowledging the directive, describing the standing rule now in force, and noting it takes effect from the next dispatch within the remaining window before the Friday 08:00 Pacific (15:00Z) deadline. Provenance footer auto-attached; issue left open (submitter closes).

**Changed:** `journal/schedules/test262-coverage-ratchet.md` (journal2 only — no main2 code change was needed; this is journal/schedule state).

**Follow-ups:** None required. The ratchet's remaining turns (hourly, until the 15:00Z deadline backstopped by `test262-ratchet-deadline`) will now enforce the PR-per-turn rule automatically. The just-prior local-only intrinsics work will be carried into a PR by the next ratchet turn, per the new rule.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5447959558.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 35 tokens (1129512 cached reads)
- Output: 10285 tokens
- Cost: $1.43836
- Wall-clock: 185s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
