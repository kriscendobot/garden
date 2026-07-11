# Guard: a test must never push to the production journal2

**Garden's own repo** (`kriskowal/garden`, `main2`): isolated worktree off
`origin/main2`, push directly, no PR (garden-infra convention).

## Why (incident, 2026-07-11)

A test leaked synthetic messages into the **real** maintainer inbox on
`origin/journal2`, where they masqueraded as live fleet traffic (a fake `pxhost`
gardener asking to **ferry upstream**, and `driftname` identity-drift alarms) and
cost real triage. Confirmed source:

- `scripts/jobs/test/run-test.sh:1508` sets `GARDEN_STATE="$TR/state-proxy"
  GARDEN=pxhost`, creates doers `px-live-a`/`px-live-b`/`px-dead`, and calls
  `message-user.sh` — the exact `pxhost` messages that reached production.
- A sibling test runs `identity-drift-guard.sh` with `GARDEN=driftname` /
  `GARDEN_STATE=/tmp/idg-…`, whose alert posts via `inbox-send.sh`.

**Root cause:** the test isolates `GARDEN_STATE` but the **journal remote / producer
clone still targets the real `github.com/kriskowal/garden`**, so `inbox-send.sh` /
`message-user.sh` committed (as this checkout's `kriscendobot` identity) and
**pushed to production `journal2`**. State was sandboxed; the *remote* was not.

## What to build

### 1. A hard guard: refuse a production-journal push in a test context
Make it **structurally impossible** for a test to push to the production journal.
In the producer-clone push path (`commit_and_push` / `ensure_clone` in
`scripts/jobs/common.sh`, and the senders `inbox-send.sh`, `message-user.sh`,
`send-msg.sh`, and the `post-*` producers that share it), add a deterministic
refusal: if the push target resolves to the **real production remote**
(`github.com/kriskowal/garden` / the canonical journal2 origin) **while a test
context is in effect**, `die` loudly instead of pushing. Choose a robust
test-context signal (prefer a positive sentinel the harness sets, e.g.
`GARDEN_TEST=1`; a throwaway/`/tmp` `GARDEN_STATE` is a reasonable secondary
heuristic). Production runs (no sentinel, real `GARDEN_STATE`) are unaffected.
This guard is the durable fix — it closes the whole class, not just these two tests.

### 2. Fix the leaking tests to use a throwaway origin
Audit `run-test.sh` so **every** message/job-post path in the proxy test (~L1508)
and the identity-drift-guard test routes through a **throwaway bare origin**
(override the journal remote / `GARDEN_PRODUCER_CLONE` to a test repo, as the
harness already does for other subtests via a local bare "origin"). No subtest may
inherit the real remote.

### 3. Make the harness set the sentinel
Ensure `run-test.sh` (and any other test entrypoint) exports the test-context
sentinel from `1` place so every subtest is covered by the guard in (1) even if a
future subtest forgets to override the remote.

## Verify
- `bash -n` + `shellcheck -S warning` clean on every file touched.
- A focused check that: with the sentinel set, a `commit_and_push` / `inbox-send.sh`
  whose remote resolves to the production repo **is refused** (non-zero, loud), and
  the same call against a throwaway origin **succeeds**; a production run (no
  sentinel) still pushes normally.
- Run the proxy + drift-guard subtests and confirm **zero** commits land on
  `origin/journal2` (they hit the throwaway origin or the guard).

## Skills
- [self-improvement](../../skills/self-improvement/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [no-comment-banners](../../skills/no-comment-banners/SKILL.md).

## Done
It is impossible for a test to push to the production `journal2`: the push path
refuses a production-remote push under the test sentinel, and the proxy +
drift-guard tests route to a throwaway origin. Committed and pushed to `main2`.
The `tada` report gives the SHA, the sentinel/guard mechanism, the tests fixed, and
the verification evidence (a refused production push + clean throwaway run).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-11T09:38:03Z
