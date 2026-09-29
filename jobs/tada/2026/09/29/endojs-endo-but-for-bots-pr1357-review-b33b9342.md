---
handed-off: ebfb-pr1357-review-5348050214-orch
deliverable-complete: false
---
The four asks in kriskowal's review of #1357 are routed to an orchestration on the board, but none of them is resolved yet. Nothing in the design doc has changed, so I'm completing this job as a declared handoff.

The review (5348050214, CHANGES_REQUESTED) opened with "@kriscendobot rsvp" and answered the design's § Open questions in four inline comments. The preflight found no peer had already resolved them (exit 0).

**How each ask is routed** (all confirmed present on `origin/journal2`):
- **Orchestration `ebfb-pr1357-review-5348050214-orch`** runs its two parked children one after the other, continuing if a child fails.
  1. **`ebfb-pr1357-revise-review-20260929`** is a design revision of `designs/endo-claude-inference-backends.md`. It covers:
     - **Q1 (comment 4129919081):** the maintainer's "Yes": the deployed root user uses kriscendobot's subscription. The design's recommendation (a) is replaced by option (b).
     - **Q2 (comment 4129930579):** multiple subscriptions and guest bring-your-own-token are hard requirements. The revision must assess whether the OS slice is optional, revise Decision 9 to match, and build on the secret-store design (`designs/daemon-secret-manager.md`).
     - **Q3 (comment 4129939009):** adopt a provider-neutral `@endo/inference`, never use "Claude" to mean Codex, and keep it open to any provider through interfaces, plugins or enrichers.
     - **Q4 (comment 4129942772):** the document stays a draft, and the evidence probe is recorded in it.
     - It also replies on each inline thread with the commit that resolves it.
  2. **`ebfb-pr1357-inference-probe-20260929`** is a probe build stacked on the revised design, answering Q4 ("I need real evidence"). It builds a minimal `@endo/inference` with a Claude backend using two or more credentials, deploys to minion.town (or an equivalent live host) to record real production turns and gate results, and opens a draft PR with the gap report and evidence.
- **The rsvp reply:** I wrote an acknowledgment covering all four decisions, but posting it on #1357 failed. This host's bot token gets a 403 on endojs PR comments. I posted **`ebfb-pr1357-rsvp-ack-5348050214`** (in `todo/`), pinned to `endolin-garden-ece02cb4`, to post that comment verbatim.

**Follow-ups:**
- If either orchestration child is claimed on oros-studio, it hits the same 403 when replying on threads or opening its PR. It will need to hand off to an endolin host. The lasting fix is to give the bot token pull-request write access on endojs.
- By mistake I ran one read-only `git log` in the `journal/` worktree. It changed nothing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-review-b33b9342.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (966625 cached reads)
- Output: 9069 tokens
- Cost: $0.8181930000000001
- Wall-clock: 1605s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
