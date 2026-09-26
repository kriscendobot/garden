Done. Work is committed and pushed to `main2`; tree is clean.

---

## Completion report — `improve-reaper-stuck-fetch-kill-escalation`

**What I did:** Fixed the `reap_stuck_fetches` janitor in `scripts/jobs/reaper.sh` so it escalates instead of sending a single, ignorable `kill -TERM`. Pushed as `9052fab36` on `main2`.

**What changed (`scripts/jobs/reaper.sh`):**
- **Escalation (the core ask):** after the existing `kill -TERM "$pid"`, the janitor now sleeps a grace and then `kill -KILL`s the target. Because SIGKILL doesn't propagate to children, it KILLs the **whole fetch subtree** — the `git-remote-https` / `fetch-pack` transport child where a half-open connection actually wedges would otherwise be orphaned to init and keep the socket. A SIGTERM-ignoring fetch is now truly reaped rather than left in the cgroup for the next reaper start to report. Mirrors the `timeout --kill-after` grace in `common.sh`/`gardener.sh` (a89e9bcda).
- **New knob:** `GARDEN_FETCH_REAP_KILL_AFTER` (default 5s) — the TERM→KILL grace.
- **`_proc_descendants` helper:** walks `ps`'s ppid map to capture the subtree **before** the grace (once the parent dies its children reparent and a walk would miss them); uses ps, not `pgrep -P`, which isn't transitive and is absent on some hosts.
- **Tightened the target matcher (defensive, in-scope):** I discovered — by accidentally nuking live fleet processes in an unsafe first test — that the old loose `case *git*fetch*` match also hits any process whose argv merely *mentions* "git fetch", including a claude agent quoting **this very job spec**. Under the old TERM-only path that was a survivable signal; under the new whole-subtree SIGKILL it would be destructive. New `_is_git_fetch_cmd` confirms `git` is the actual **program word** (bare or path-suffixed, under an optional `timeout <secs> [flags]` prefix) with `fetch` as a standalone arg. The grep stays as a cheap prefilter.

**Verification:** `bash -n` + shellcheck clean (no new findings). Ran two **safe** tests (stubbed `ps` prefilter so only a fake tree could ever be targeted): matcher unit test 11/11 (correctly rejects the claude-agent and bash-snapshot lines, accepts all real `git`/`timeout … git … fetch` forms); escalation test confirmed a SIGTERM-ignoring parent **and** its SIGTERM-ignoring child are both SIGKILLed.

**Follow-ups / notes:**
- The loose-match tightening likely also explains the repeated reaper requeues of this job and its sibling `improve-fetch-timeout-kill-after-grace`: their specs quote "git fetch", so the *old* janitor would TERM the working agent after `GARDEN_FETCH_REAP_AGE` (120s), interrupting it. This fix removes that self-inflicted instability for any fetch-meta job going forward.
- Sibling job `improve-fetch-timeout-kill-after-grace` (the `common.sh` `--kill-after` side) is independent and was in flight separately; no coordination needed — this change is consistent with it.
