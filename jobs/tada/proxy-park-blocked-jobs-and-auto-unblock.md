Inbox is empty. The work is complete, tested, and pushed to `main2`. Here is my completion report.

---

## Completion report: `proxy-park-blocked-jobs-and-auto-unblock`

**Status: done.** Landed on `main2` (commit `3ea11611e`), full test suite green (**210 passed, 0 failed**), authorization recorded in `roles/proxy/AGENT.md` and a journal `message` entry (`185050Z-message-…`).

### What I built
A maintainer-authorized (2026-06-27) extension of the proxy's bounded authority: park a blocked job and auto-resume it when its blocker completes — deterministically, no LLM.

- **Structured blocking convention** — new `block-job.sh` (a gardener signals `block-job.sh <its-base> <artifact>`), plumbed through a `GARDEN_BLOCKED_ON` passthrough in `inbox-send.sh` that emits a `blocked_on:` frontmatter field.
- **Proxy park pre-pass** (`proxy.sh` § `park_blocked_jobs`) — runs alongside the watchdog auto-clear sibling, every tick. For each `blocked_on:` notification it, in one atomic commit: parks the named job as a `gate: blocked` plan carrying `blocked_on=<artifact>` (moved out of `todo/`/`doin/`, or created from the notification body if the job already left the board), archives the notification (`unread→read`), and — for a **bot-fork PR** blocker only — fires ONE best-effort courtesy comment (new `handlers/block-pr-comment-gh.sh`, gated to deny agoric-sdk, no PR state change). **The plan's `blocked_on:` field is the single source of truth** — no separate dependency store.
- **Gate semantics** — `post-plan.sh` learns `--blocked`/`--blocked-on`; `common.sh` gains `plan_blocked_on`, `parse_pr_ref`, `is_job_basename`. `plan_deferred_ranked` already excludes non-`deferred` gates, so the foreman never auto-promotes a blocked plan (now **asserted by a regression test**). The bulletin's `render_plan_queue` gains a third **"blocked (awaiting `<artifact>`)"** group.
- **Deterministic unblock trigger** — new `unblock.sh` + `garden-unblock.service`/`.timer` (auto-enabled; `install-units.sh` derives its set from present units). Promotes a blocked plan → `todo/` when the blocking **job** lands in `tada/`, or its **PR** is merged/closed (state read via the gh/jq handler shared with mirror-closer, which fails LOUD on a missing binary — the silent-jq discipline). Promotion reuses `promote-plan.sh`, which strips the blocked frontmatter, cleaning up the edge by construction.

### Tests
New `SUBTEST 20b`: proves park → no-auto-promote (`plan_deferred_ranked` excludes blocked while still selecting deferred) → unblock-on-completion (PR open→merged and blocking-job→tada, stubbed `gh`) → bulletin blocked group → courtesy comment fired exactly once with correct args, job-blocker got none. Two new hermetic stubs (`block-pr-comment-stub.sh`, `unblock-pr-state-stub.sh`). Also fixed the pre-existing empty-plan-queue assertion (2→3 `(none)` groups).

### Design notes / follow-ups
- The **structured** path is fully deterministic, as the spec preferred. A **free-text** "blocked on X" maintainer message (no `blocked_on:` field) is not auto-parked — it still flows to the proxy's `claude -p` handler as a normal gating question. Wiring the handler to extract `(blocked-job, blocker)` and call the park primitive is the optional LLM-fallback the spec marked "MAY"; left as a clean follow-up.
- The pre-pass parks regardless of the grace window (like the watchdog sibling): a blocked job can't proceed and would otherwise risk reaping from `doin/`; parking is reversible and surfaced in the bulletin's blocked group.
