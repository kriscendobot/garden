**Fix round 2 for kriscendobot/minion.town PR #200: all must-fix items from the latest panel review are pushed, and CI is green on the new head.**

The job had no prepass block, so I worked from the latest panel review on head `6b01b3bd` (review 5588444475). The PR head moved `6b01b3bd` → `7e4e154e` in three commits, pushed with `safe-push-pr-head.sh`.

**Guest deletion (saboteur, breaker, purist, wire-watcher, engine-realist, spec-keeper)** — mainly `src/web/guest-web-socket-service.ts`:
- **New order:** store a `web-deleting-*` marker name first, remove the handle names, then every `web-open-*` temporary name, then the agent names, cancel the guest through the marker, and remove the marker last.
- **Cancellation:** a failed cancel now makes the deletion fail instead of being ignored. Success is reported only after cancellation works and nothing but the marker still names the guest.
- **Interrupted deletion:** any failure after the marker is stored leaves the deletion pending. This covers a lost connection after the daemon already applied a removal, and a crash. Guest routes then answer 409 `deletion-pending` (new `GuestDeletionPendingError`), recovery bonds are kept, and the next `DELETE /api/guest` finishes the job, even after a restart.
- **Races:** once a deletion starts, `open()` refuses that guest, both before and after it binds its temporary name. Two deletions of the same guest at once share one outcome.
- **Input check:** name lists coming back from the daemon are validated.

**Other code:**
- **Audit log durability** (`durable-append.ts`): the directory is now synced after every append, not just by the call that created the file.
- **`settings.js`** (typist, transplanter): the invite result is typed by `kind` instead of `Promise<any>`. The CLI panel now shows both macOS/Linux and Windows PowerShell commands. An ad-hoc strict type check of the file passes.

**Docs (archivist, integrator, pruner):**
- `closed-beta-waitlist.md` now gives the real deletion order.
- `invitation-only-guest-onboarding.md` drops the "forget this browser" requirement, since Log out now does that job.
- `DEPLOYMENT.md` no longer mentions the retired role panel or buy panel, and no longer narrates PR history; the same narration is gone from `clip-shell-framework.md`. The narrating comment in `home.js` is removed.

**Tests:** I added fault tests for:
- a removal the daemon applies before the connection drops, then resuming after a restart
- a failed cancel followed by a successful retry
- a leftover temporary name blocking success
- the handle → agent → cancel order
- two deletions of the same guest at once
- a request racing a deletion

I also added a test for two first writes to the audit log at once, and PowerShell command assertions.

**Verification:**
- `tsc --noEmit` is clean.
- `npm test`: 1450 passed, 1 failed. The failure is `test/git-remote/capability.test.ts › propagates a git failure rather than reporting the ref absent`, in code this diff doesn't touch; I didn't check whether it also fails on the old head.
- CI: all 7 checks passed, and `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN). My first run of that script was stopped by the tool's 10-minute background limit, so I polled the checks in the foreground and then re-ran it to get the exit code.
- I posted a completion summary comment on the PR (the scribe item): https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6296308716

**Not done, for the next panel:**
- the optional property-test and pagination-test suggestions (fast-checker, corner-prober)
- a real-daemon restart test
- cleaning up the PR description (stale #198 stacking note, methodology text, the veto checklist and footer)
- the browser has no special handling for the new 409 `deletion-pending` answer; the delete panel just shows "Not deleted: …" and lets the person retry

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4470773 cached reads)
- Output: 32925 tokens
- Cost: $2.544086600000001
- Wall-clock: 1701s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
