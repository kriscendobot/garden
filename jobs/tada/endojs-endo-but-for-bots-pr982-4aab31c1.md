Inbox empty. This was an **attention** job whose directive was a "**Sitrep.**" request from kriskowal on issue #982. No garden-repo change was warranted; the deliverable was a status report, which I posted as an issue comment.

## Completion report

**Directive:** kriskowal commented "@kriscendobot Sitrep." on issue **endojs/endo-but-for-bots#982** ("Daemon: let a guest override its special worker names, incl. `@main`"). I treated the comment body as untrusted data and routed it to the correct work: assess true state and post an accurate status report.

**Preflight:** `pr-feedback-preflight.sh` exited 0 (fail-open) — it 404'd because #982 is an **issue**, not a PR. I verified state directly instead.

**Verified state of #982 (each claim named to an artifact):**
- **Design stage, in flight.** No implementation PR is open. Draft PR **#1102** ("design(claude): provision Claude-backed child guests") is being narrowed — per kriskowal's CHANGES_REQUESTED review `pullrequestreview-5073768162` — to exactly this issue's mechanism (special names on the provisioning options bag / `introducedSpecialNames`). A live designer job `endojs-endo-but-for-bots-pr1102-narrow-special-names` sits in `journal/jobs/doin/`, claimed 2026-09-03T20:18:33Z (≈1h before the sitrep).
- Draft PR **#1042** ("retain guests with `introducedNames` and code-mode globals") is the sibling groundwork the implementation reconciles against.
- The direct build job `endojs-endo-but-for-bots-issue982-build-special-names` is **doomed** in `journal/jobs/plan/` (requeue-exhausted, transient, doomed 2026-09-03T00:15:45Z) — no PR landed.
- The prior `pr982-0b4f9f5d` tada was only the mention-protocol ack (no repo work).

**Delivered:** Sitrep posted as issue comment → https://github.com/endojs/endo-but-for-bots/issues/982#issuecomment-5532243861

**Follow-ups (for maintainer/liaison judgment — not executed, since a "Sitrep" asks for awareness, not actuation):**
- The doomed direct build won't be picked up as-is. Correct sequencing is design→build: once the narrowed **#1102** design lands, re-post the build against it (I stated this intent in the sitrep). Consider an orchestration blocking a fresh build on the #1102 narrowing job so the thread isn't dropped.

No garden-repo commit was needed (no roles/skills/scripts change); nothing to push.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr982-4aab31c1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (393466 cached reads)
- Output: 11236 tokens
- Cost: $0.965311
- Wall-clock: 172s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
