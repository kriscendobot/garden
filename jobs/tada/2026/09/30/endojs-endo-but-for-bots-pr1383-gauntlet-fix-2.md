**Gauntlet FIX round 2: endojs/endo-but-for-bots PR #1383 (daemon lifecycle idempotency design)**

Both must-fix items from the panel-2 review are fixed, the follow-up commit is pushed, and CI is green: `ci-wait-merge.sh` returned rc=0 with 28 checks and 0 failed.

**Must-fix 1 (integrator): the PR body did not follow the upstream template.** I rewrote the PR body with `gh pr edit` so it uses the template's sections in order:
- **Refs:** fully qualified links to minion.town #117, #130 and #137.
- **Description**
- **Considerations:** Security, Scaling, Documentation, Testing, Compatibility and Upgrade, each filled in. Testing names the tests from Phased Implementation.

I also dropped the "Main findings on `llm`" list, which repeated the design's survey (pruner) and named the working branch (integrator). The `garden-job` marker is kept.

**Must-fix 2 (decomplector): `endo.pid` had two writers, and ownership was recorded in several places.** I checked the code first: `engo`'s `WritePID` writes the file, and `manager-go.js` `updateRecordedPid` then overwrites it. Changes to `designs/daemon-lifecycle-idempotency.md`, in commit `db7c336883`, pushed with `safe-push-pr-head.sh` (c414c05c8b → db7c336883):
- **New survey subsection:** "Who writes `endo.pid` today".
- **One owner record (§2):** the `<ephemeral>/endo.lock` claim marker is now the single record of which process owns the daemon. The root of the process tree writes it: `manager-node.js` on the Node path, `engo` on the Go path. The file format is fixed as `<pid>\n<start-time>\n`, where start time is field 22 of `/proc/<pid>/stat`, parsed from after the last `)`.
- **`endo.pid`** becomes a copy written by the same claimant, and `manager-go.js` stops overwriting it.
- **The socket `.lock` marker** stays, but only to guard the socket path.
- **One state check:** `start`, `stop`, `status`, `ping` and auto-start all use a single classifier (absent, booting, live or stale) keyed on the state directory. §1 and §5 now use it.

**Should-fix items I also addressed:**
- §4 now covers the `engo` path: its children get a parent-death signal (critic).
- The exit-code table has separate rows for action commands and query commands, and no longer names `start --foreground`, which the design never defined (ergonomist).
- New text states what a plain `endo start` can and cannot observe about losing the claim.
- Phase 1 gains a test for `stop` against a daemon that is still booting (skeptic).
- The design no longer refers to the `llm` branch or calls itself a "note".
- Wording nits: LSB is spelled out, one table header is now title case, and the capitalization of the two messages is consistent.

**Follow-ups:** none. I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1100094 cached reads)
- Output: 8774 tokens
- Cost: $0.9534667999999998
- Wall-clock: 1026s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
