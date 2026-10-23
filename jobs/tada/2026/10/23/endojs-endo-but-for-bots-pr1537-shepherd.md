# Shepherd report: endojs/endo-but-for-bots#1537 (`build/endo-fs-from-git-sha256-paged-listing`)

I did not get the Linux CI green, and nothing in #1537's own diff can fix it. Every red check comes from a known problem with the new Ubuntu 26.04 runner image. The fix is a separate PR, endojs/endo-but-for-bots#1542, which still has to merge. I pushed nothing to #1537.

**Checked at:** head `fee2309e`, base `llm-54d3d2a`, mergeable; run https://github.com/endojs/endo-but-for-bots/actions/runs/39821788540

**What's red:** test (22.x and 24.x on ubuntu-latest), cover (22.x and 24.x on ubuntu-latest), and sandbox-drivers. All of them fail in one place, the `@endo/sandbox` tests (turbo: `Failed: @endo/sandbox#test`):
- "prlimit nproc cap is enforced inside the slice" fails with `/bin/sh: 1: ulimit: Illegal option -u`.
- "bwrap parent death leaves no owned process group" fails with "Test finished without running any assertions".
- On test 24.x only, "bwrap timeout and repeated cancellation reap process groups" also fails.

**Why it isn't #1537's fault:**
- #1537 only touches `packages/exo-git`, `packages/git`, `packages/daemon`, `designs/` and a changeset. It changes nothing in `packages/sandbox`.
- macOS test 22.x ran all 120 turbo tasks and passed; test 24.x on macOS is also green. On Linux, turbo stopped at the sandbox failure (93 of 109 tasks succeeded), so on Linux the PR's own packages may never have run.
- The failure messages match the 26.04 breakage that started on 2026-10-22 and hits every PR.

**The fix:** endojs/endo-but-for-bots#1542, "fix(sandbox): make bwrap tests pass on Ubuntu 26.04 and kill the sandbox init on cancel". It is a draft with all checks green, based on `llm-d5ac419`, and not merged yet. Its gauntlet halted at the clean stage, but a later fix job made CI green. Copying its sandbox changes into #1537 would push work outside this PR's scope, which a shepherd must not do. So I stopped and handed off.

**Escalation: next: liaison.** #1542 needs maintainer review and a merge. After that, post `weave #1537` so #1537 is rebased onto a frozen base that contains the fix (date-suffixed basename). Then rerun the shepherd, or the gauntlet, to confirm Linux is green.

**What I did:**
- Pulled the failed logs for every red job and confirmed the same cause in each.
- Confirmed macOS ran the PR's own packages successfully.
- Messaged the maintainer through the liaison inbox: `msg-endojs-endo-but-for-bots-pr1537-shepherd-5e54be124add`.
- Made no garden commits and no project pushes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1537-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (759907 cached reads)
- Output: 5538 tokens
- Cost: $0.7643974
- Wall-clock: 218s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
