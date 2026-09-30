I applied the fixes from the panel's round-1 review to endojs/endo-but-for-bots PR #1383, pushed them, and CI came back green (28 checks, 0 failed).

**What changed:** one follow-up commit, `c414c05c8`, on `design/daemon-lifecycle-idempotency`. It edits only `designs/daemon-lifecycle-idempotency.md`. It was pushed with `safe-push-pr-head.sh` as a fast-forward from `414af7744`.

Must-fix items:
- **Node vs. Go lock ownership (decomplector):** the design now commits to one claim protocol. The on-disk marker format is the shared contract. The process at the root of the daemon's process tree owns the claim: `manager-node.js` on the Node path, and the `engo` supervisor on the Go path (not the `manager-go.js` it runs). Section 1's check for an already-running daemon lives in the shared `start()` before the `ENDO_BIN` branch, so both paths use the same code. Phase 1 now includes a test with a Node daemon and an `engo` daemon contending for the same state directory. The Dependencies row is updated to match. I checked `go/engo` first: it has no lock of its own today, so the Go side of the claim is new work.
- **Exit codes contradicted each other (ergonomist):** a process that survives SIGKILL now gets its own code, 70 (`EX_SOFTWARE`). Section 5 and the section 6 table now agree, and code 1 is plain "any other failure."

Should-fix and comment items, also applied:
- **PID reuse (decomplector):** the lock now records the owner's start time along with its pid, with `flock` suggested as a stronger option where available.
- **Orphan diagnosis (skeptic):** minion.town#137's own explanation (a process escaping cgroup teardown, fixed by section 4) is now kept separate from the PR #130 probe race (fixed by sections 2 and 3). Removing the `:8920` reaper is now conditioned on which of the two mechanisms is confirmed.
- **Naming and messages (ergonomist):** `--no-start` is renamed `--no-autostart` to match `ENDO_NO_AUTOSTART`, and the "already running" message now includes the pid.
- **Definitions (novice):** "workers" and "engo" are defined where they first appear.
- **Characters and headings (pedant, copyeditor):** `§`, en dashes and arrows are replaced with plain ASCII, and all headings use title case. The file is now pure ASCII and passes Prettier.

**Follow-ups:**
- Replacing `§` goes against the rest of the repo: other design docs use it about 879 times. I made the change here only because two reviewers flagged it; whether to standardize elsewhere is the maintainer's call.
- I didn't apply the critic's two comments (adding `daemon-capability-bus` to Dependencies, and noting that section 1 alone may close the auto-start race) or the skeptic's comment about merging Open Question 1 into section 3. They're optional polish.
- Reading my inbox failed: cloning the journal timed out on this host. I couldn't check for maintainer messages, so there may be some I haven't seen.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1339088 cached reads)
- Output: 10072 tokens
- Cost: $1.0549456
- Wall-clock: 1864s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
