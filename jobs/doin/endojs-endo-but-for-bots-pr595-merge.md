# Conductor: un-draft and merge endojs/endo-but-for-bots PR #595

PR: https://github.com/endojs/endo-but-for-bots/pull/595
Repo: endojs/endo-but-for-bots  (BOT repo — merging is allowed; NOT agoric-sdk / endojs-endo upstream)
Base: llm (live trunk, NOT a frozen-base snapshot — no unfreeze needed)
Head: designs/captp-error-identification
Head SHA at review time: 8ea983a1f52ccf9c14c5ba578bfd1a6b43a93768

Trigger: kriskowal APPROVED review 4675088277 —
  "Let's proceed to building and gauntlet. We can refactor names while in flight."
The review had NO inline asks and requests no code/design changes; it is a pure
approval of this design-only PR (adds designs/captp-error-identification.md and
designs/unredacted-stack-sanctioned-ses-api.md). At review time the PR was
draft, mergeable: true, mergeable_state: clean, and all 5 check-runs (zizmor,
browser-tests, test, lint, build) were success.

Task (finalization/curation step):
1. Re-verify mergeable + CI green on the CURRENT head (rebase onto live `llm`
   first if behind, per your loop).
2. Un-draft the PR (it is currently a draft).
3. Merge it. You own the merge method — pick per the conductor loop.
4. Frozen-base sweep per your usual discipline if applicable.

Do NOT switch identity; commit/merge under the bot identity. This is a bot repo.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  claimed_at: 2026-07-10T21:32:29Z
