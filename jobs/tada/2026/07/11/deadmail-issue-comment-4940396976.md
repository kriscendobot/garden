Inbox empty, garden worktree clean (this job was entirely project-repo work on the fork). Done.

---

## Completion report

**Job:** dead-lettered message picking up the intent of `issue-kriskowal-garden-29` — fold a new maintainer comment (mhofman, on kriskowal/garden #29) into the in-flight garden#29 "promote a running vat to critical" work and reply on the issue thread.

**The comment asked three things** and I addressed each:

1. *"Any reason you cannot run the a3p test yourself?"* — Verified the concrete blocker: the garden fleet runs inside an **unprivileged Docker container with no Docker daemon/socket/binary** (`/.dockerenv` present, `/var/run/docker.sock` absent, no `docker`/`podman`). a3p's `synthetic-chain` harness is Docker-in-Docker, so I genuinely cannot build the image, run the proposal, observe the deterministic vatID, or observe the test outcome. Answered this plainly on the thread and named what unblocks it (fork CI's a3p run, or a Docker-capable host).

2. *"Any do-nothing contract is fine, not necessarily ymax."* — Rewrote `a3p-integration/proposals/n:upgrade-next/test/critical-vat.test.js` to be **target-agnostic**: it now drives purely off the pinned vatID(s) instead of hard-coding the `ymax1` label, with an optional per-pin `label` for a fail-loud drift cross-check.

3. *"Leaving the target vat running is fine."* — Recorded that maintainer sign-off in the proposal README and reframed activation to recommend a self-contained do-nothing contract (no `g:ymax1` surgery), with reuse-live-ymax1 as the documented alternative.

**Changed / pushed** (fork `kriscendobot/agoric-sdk`, branch `garden29-promote-ymax-critical`, PR #9, commit `71cb13f9`):
- `a3p-integration/proposals/n:upgrade-next/test/critical-vat.test.js` — target-agnostic assertion + optional label cross-check (node `--check` passes).
- `a3p-integration/proposals/n:upgrade-next/README.md` — records both decisions; documents the single residual (vatID pin needs one real a3p run to observe).

**Reply posted:** https://github.com/kriskowal/garden/issues/29#issuecomment-4940868836 (did not close the issue).

**Deliberately did NOT do:** blind-ship a new do-nothing contract bundle + deploy plumbing I cannot run — that is exactly the "authored but not run" pattern the maintainer is pushing back on. Instead I made the reviewable framing/logic changes and posted two pointed questions.

**Follow-ups (awaiting maintainer answer):** (a) produce the observed vatID via fork CI's a3p run vs. a Docker-capable path; (b) reuse an existing trivial a3p contract fixture vs. add a dedicated minimal one. Either becomes a new job when he replies.
