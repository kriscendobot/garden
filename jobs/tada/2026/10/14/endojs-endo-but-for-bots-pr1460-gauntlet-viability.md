I'm letting the gauntlet go ahead for PR #1460: it is still open, nothing newer replaces it, and the maintainer is actively working on it.

**Deciding question:** Is #1460 still the current canonical Parcel design, with no newer PR or base-branch design replacing it, and does the maintainer still want the SturdyRef→Parcel reshape?

**Evidence:**
- **PR state:** open, unmerged and still a draft. It was created today (2026-10-14T22:30Z). The head is `9728449f4e` on `design/parcel`, against the frozen base `llm-7ff30af`. It is design-only: it adds `designs/parcel.md` and edits `designs/README.md` and `designs/sturdy-refs-endor-syscall.md`.
- **Not superseded:** a search for "parcel" across all PRs finds no newer design. The related open PRs (#1389, #1391, #1392, #1399, #774) are older work on individual layers, opened between 2026-07-17 and 2026-09-30. #1460 is the newest and is meant to coordinate them (its body cites #1389). The `llm` branch has no `designs/parcel.md` (404), so the base has not taken over the design.
- **Premise still holds:** kriskowal requested changes ("@kriscendobot rsvp") at 22:53Z today. The bot addressed all seven review decisions in `cbc8ae454b` and posted follow-ups at 23:01Z and 23:06Z. CI is green on the current head, and the PR is waiting for the maintainer's re-review. The JavaScript stack is still unreleased, so the rename-without-aliases plan still fits.

I spent no clean, panel, fix or CI-wait budget; this was only the viability check.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1460-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (107051 cached reads)
- Output: 1219 tokens
- Cost: $0.3547902
- Wall-clock: 79s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
