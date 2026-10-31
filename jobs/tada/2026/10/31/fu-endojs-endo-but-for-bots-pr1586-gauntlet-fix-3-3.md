---
handed-off: fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3-rerun
deliverable-complete: false
---
I couldn't rerun the red job or post the CI result on #1586 from this host, so I handed both to a successor job, `fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3-rerun`. It is pinned to the endolin host and has already been claimed. I diagnosed the failure; the fix already exists in #1542, so I wrote no code.

**The red job.** Run 41222139396 has one failing job, `cover (22.x, ubuntu-latest)`. It has one failing test: `bwrap › bwrap timeout and repeated cancellation reap process groups`, with "process group 5849 survived bounded cleanup" (`packages/sandbox/test/bwrap.test.js:1099`). `gh run rerun --failed` failed here with "Resource not accessible by personal access token". This host's token is also refused for PR comments on endojs, so I couldn't report on the PR either.

**Diagnosis.** This isn't the ubuntu-26.04 `ulimit -u` break; all the other bwrap tests passed in that run. It's a real containment race in the bwrap sandbox driver, and #1586's diff doesn't touch that code. The same test has failed on many other PRs.
- A group SIGTERM that arrives while bwrap is still setting up its namespace kills the outer bwrap launcher first.
- bwrap's source shows the sandbox's init only arms `--die-with-parent` at the end of setup, so it is unprotected until then.
- That init ignores SIGTERM from outside its namespace. It then either sits stuck in the process group (what CI sees) or leaves the group and runs the sandboxed command as an orphan.
- I reproduced it against real bwrap 0.9 on this host by killing 0–30ms after spawn. Leaked sandboxes per 350 kills:

| Kill strategy | Leaked |
| --- | --- |
| Group SIGTERM (what the driver does now) | 65 |
| Group SIGTERM, then group SIGKILL when the launcher exits (#1591's approach) | 12 |
| Group SIGKILL | 3 |
| Group SIGKILL plus a SIGKILL of the init pid that bwrap reports | 0 (across 700 kills) |

**The fix.** #1542 kills the sandbox init directly, using the pid bwrap reports, and adds a regression test for the setup window. That is the approach that leaked nothing. It is green, out of draft, and has been waiting on a maintainer merge since 2026-10-24. #1591's viability stage already called it superseded by #1542, and the numbers above back that up.

**What I posted:**
- **Successor job:** it reruns the failed job (and once more if the same bwrap failure recurs), then posts the outcome on #1586 and points to #1542 if it's still red there.
- **Maintainer message:** sent through the inbox with the diagnosis and leak rates. It asks the maintainer to merge #1542 and close #1591.

**Follow-ups:**
- Once #1542 merges, PRs on the `llm-9a14ddf` base, #1586 among them, need a weave to pick up the fix.
- I killed the leaked bwrap processes my experiments left on this host.
- I made no commits to the garden or to #1586.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4684200 cached reads)
- Output: 39290 tokens
- Cost: $2.6607200000000004
- Wall-clock: 2931s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
