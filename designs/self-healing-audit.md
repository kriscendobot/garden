# Audit: self-healing wrappers on every script + git-content-store failure capture

Status: audit (2026-06-24, gardener-24 wearing the mentor role, job
`audit-self-healing-wrappers`). Two related audits of the garden's automation:

- **Part A** — does every deterministic script have an outer wrapper that, on
  failure, *captures the failure and drives a `claude -p` self-improvement /
  debugging responder* wearing a role/skill specific to that self-healing task,
  rather than just dying and relying on the central mentor service?
- **Part B** — where should the **git-content-store** capture pattern
  (`git hash-object -w` → pass only the SHA → `git cat-file -p` for selective
  inspection) be adopted, so a large failure log never enters the responder's
  context wholesale?

The follow-up jobs this audit posted are listed at the end. Design-level and
judgment-call changes are left as recommendations for maintainer review.

## The bar (the exemplars done right)

Three artifacts set the bar; every other script is measured against them.

1. **`scripts/jobs/mentor.sh` (+ `handlers/mentor-claude.sh`)** — the central
   self-healing responder. `mentor.sh:43-50` reads `journalctl --user -u
   'garden-*' -p warning` across *all* garden units plus new journal entries,
   builds one digest, and hands it to `mentor-claude.sh`, which wears the
   **mentor** role (`mentor-claude.sh:20-39`) and posts improvement jobs. It is
   a fleet-wide safety net — but coarse: it runs on a **30-minute timer**
   (`garden-mentor.timer`), it has **no per-task role** (one generic mentor
   prompt for every failure shape), and it **inlines the whole journalctl tail**
   into the prompt (`mentor-claude.sh:36`) rather than capturing by hash.

2. **`scripts/driver/driver.sh`** — the *strongest* self-healing wrapper in the
   tree, and the de-facto Part-B exemplar:
   - an `EXIT` trap (`report_unexpected_exit`, `driver.sh:131-151`) that, on an
     unexpected non-zero exit, keeps the `-x` transcript, hashes it, and routes
     it to the gardener inbox via `report-error.sh`;
   - `capture_and_self_improve` (`driver.sh:481-582`) hashes each tick's capture
     into the journal object DB (`git hash-object -w --stdin`, `driver.sh:497`)
     and feeds **only the SHA** to a background `claude -p` self-improvement
     agent (`driver.sh:532-541`), which reads the transcript on demand via
     `git cat-file blob`.
   - **Caveat:** the driver is the *retired/superseded* posture — per CLAUDE.md
     the steward→gardener migration makes the gardener pool the live path and
     leaves driver lanes behind. So the best pattern in the repo lives in a
     script that is being phased out, and it was **never ported into the v2
     service fleet or the gardener worker.**

3. **The gardening state machine** (`designs/gardening-state-machine.md` +
   `scripts/jobs/gardening/garden-pr.sh`, `panel.sh`) — **diverted tracing**
   done right: `GARDEN_TRACE=1` routes `set -x` into `$GARDEN_TRACE_LOG` via
   `BASH_XTRACEFD` (`garden-pr.sh:34-37`, `panel.sh:56-59`) so trace noise never
   reaches the supervisor's context; per-seat verdicts go to a run dir
   (`panel.sh:50-53`), not stdout. **But** the trace half is only half the
   pattern: neither script *captures the trace into the journal* nor *invokes a
   debugger* — both rely on a supervising gardener to hand the trace file to a
   debug subagent, and `fail()` (`garden-pr.sh:46`, `panel.sh:61`) just exits 1.
   The trace lives in `/tmp` and is lost on cleanup.

## Part A — per-script coverage

Legend: **has-wrapper** = captures the failure and drives a dedicated `claude -p`
debugging/self-improvement responder; **partial** = fails safely (retry / graceful
degrade) and/or is visible to the central mentor, but no dedicated capture+responder;
**missing** = the failure is lost or swallowed with no capture and no responder;
**deterministic** = no `claude -p` path — correctness rests on CAS-retry, and a
self-healing responder is not the right tool (gaps noted inline).

| Script | Class | Grounding / failure path |
| --- | --- | --- |
| `scripts/driver/driver.sh` | **has-wrapper** | EXIT trap + `capture_and_self_improve` (`:131-151`, `:481-582`). The gold standard; superseded posture. |
| `scripts/jobs/mentor.sh` | **has-wrapper** (is the responder) | central digest → mentor role (`:43-72`). Its own failure just `die`s (`:71`); coarse cadence + no capture-by-hash (see Part B). |
| `scripts/jobs/gardener.sh` | **missing** | On handler failure it writes a one-line "exited non-zero" report and **completes the job (doin→tada)** (`:70-74`). The handler's stdout/stderr — the gardening state machine's actual failure — is **discarded**, and a failed job is recorded as *done*. No capture, no responder, no diverted-trace wiring. **Highest-value Part-A gap:** this is the live v2 supervisor of the state machines. |
| `scripts/jobs/gardening/garden-pr.sh` | **partial** | diverted tracing present (`:34-37`); `fail()` exits 1 (`:46`); trace never hashed, no auto-responder (`designs/gardening-state-machine.md` § Divert debugging assigns this to the supervisor, which today does not do it — see gardener.sh above). |
| `scripts/jobs/gardening/panel.sh` | **partial** | diverted tracing + run-dir verdicts (`:56-59`, `:50-53`); `fail()` exits 1 (`:61`); no capture/responder. |
| `scripts/jobs/follow-up.sh` | **partial** | `die` on handler failure, seen-marker held for retry (`:110-116`); seen only by central mentor; no capture/responder. |
| `scripts/jobs/proxy.sh` | **partial** | `die` on handler failure, seen-marker held (`:98-104`); central mentor only. |
| `scripts/jobs/triager.sh` | **partial** | `die` on handler failure, journal cursor held to re-triage (`:56-63`); central mentor only. |
| `scripts/jobs/foreman.sh` | **partial → missing** | handler failure is **swallowed** with `|| true` (`:110`); no die, no capture — a broken foreman handler is invisible except as "no pump". |
| `scripts/jobs/bulletin.sh` | **partial** | genuinely robust by design (graceful degrade to deterministic dashboard, CAS back-off) but the **journalist failure is swallowed** `2>/dev/null` (`:177`) with no capture of *why* it failed. |
| `scripts/jobs/watchman.sh` | **partial** | evolution handler best-effort `|| log` (`:65-66`); `die` only on the required broadcast (`:60-62`); central mentor only. |
| `scripts/checks/run-all.sh` | **partial** | itself a self-improvement dispatcher (gate fires → `claude -p prompt.md`, `:179`); but a claude that **exits non-zero is only logged** (`:179-181`) — the dispatch failure is swallowed, no capture. |
| `scripts/watcher/endo-but-for-bots/watcher.sh` | **missing (stub)** | Phase-1 stub, `exit 0` (`:59`); the self-heal contract (Restart=on-failure + `report-error.sh` escalation) is *documented* (`:24-25`) but unimplemented. |
| `scripts/jobs/scheduler.sh` | **deterministic** | CAS-retry per dispatch; gap: an unparseable `once:`/cadence only `log`s and skips (`:41`) — a wedged schedule is silent. |
| `scripts/jobs/reaper.sh` | **deterministic** | race losers retry next tick (`:58-62`). Adequate. |
| `scripts/jobs/repo-watcher.sh` | **deterministic** | idempotent reconcile; gap: `unit_ctl` arm/disarm failures only `log WARN` (`:50,:57`), never escalated. |
| `scripts/jobs/gardener-scaler.sh` | **deterministic** | delegates to `install-units.sh scale` (`:33`). Adequate. |
| handlers `*-claude.sh` (mentor, follow-up, proxy, foreman, triager, watchman, bulletin, gardener) | **partial** | thin by design; each parses `claude -p` output and propagates/​swallows. None captures its own failure; all rely on the outer script + central mentor. |
| primitives (`post-job`, `claim-job`, `complete-job`, `cursor-*`, `inbox-*`, `send-msg`, `read-msgs`, `journal-entry`, `set-*`, `install-units`, `maintainer-*`, `message-user`) | **deterministic** | CAS / git plumbing; no claude path; retry or `die`. Adequate. |

### Part-A summary

**~22 scripts with a `claude -p` or supervisory role: 2 has-wrapper, 1 responder
(mentor), 8 partial, 3 missing, ~8 deterministic (adequate).** The self-healing
posture is **not universal.** The one full implementation (`driver.sh`) is on the
retired path; the live v2 supervisor (`gardener.sh`) has the worst coverage —
it swallows the state machine's failure into a *completed* job. The fleet's only
real safety net is the central mentor's 30-minute journalctl scan, which is
coarse, has no per-task role, and inlines logs rather than capturing them.

### Systemd-layer observations

- **No unit defines `OnFailure=`.** A failed oneshot tick (mentor, follow-up,
  proxy, foreman, scheduler, reaper, repo-watcher, gardener-scaler, triager@,
  watchman) triggers no dedicated debugging handler unit; it only waits for the
  next timer and is seen, if at all, by the central mentor's journalctl scan.
- Only 5 units carry `Restart=` (`gardener@`, `bulletin`, `driver@`,
  `design-poller`, `watcher@`); the timer-driven oneshots have neither `Restart=`
  nor `OnFailure=`. `Restart=on-failure` restarts the process but does not
  *capture or diagnose* — it is not a substitute for a self-healing responder.

## Part A — supporting role/skill gaps

| Artifact | v1 | v2 | Gap |
| --- | --- | --- | --- |
| **mentor** role | — | ✅ `roles/mentor/AGENT.md` | present; its "skills" list names `self-improvement` as "to be migrated from v1" — **not landed.** |
| **`prompt-on-failure-capture`** skill | ✅ `v1/skills/prompt-on-failure-capture/SKILL.md` | ❌ | the canonical capture-by-SHA playbook (capture → known-SHA short-circuit → four-slot brief → `claude -p` → apply) **never ported to v2.** |
| **`gardener-inbox-error-reporting`** skill + `report-error.sh` | ✅ `v1/skills/.../report-error.sh` | ❌ | the helper that hashes a transcript and appends only the SHA to the gardener inbox is **v1-only** and targets the **`journal`** branch — v2 uses **`journal2`** (`common.sh:24`), so a straight copy would push to the wrong branch. |
| **diverted-tracing** technique | — | ✅ in `garden-pr.sh`/`panel.sh` | present, but no script hashes the trace or auto-invokes a debugger (Part-A above). |
| **canonical `self-healing-wrapper`** skill | ❌ | ❌ | **No single playbook** for "capture-on-failure → hand to `claude -p` debugger → propose/post a fix." The pattern is copied ad hoc (driver.sh, report-error.sh) or absent. **Recommend authoring one** so it stops being re-derived. |

## Part B — capture-via-hash opportunities

The pattern (per `designs/driver.md` § Prompt-on-failure capture pattern and the
v1 `prompt-on-failure-capture` skill): on failure, `LOG_SHA=$(... | git
hash-object -w --stdin)`; pass only `$LOG_SHA` (and the repo path) into the
`claude -p` prompt; the responder uses `git cat-file -p $LOG_SHA` + `grep`/`sed`/
`awk`/`tail` to pull only the relevant slices. Identical inputs hash to identical
SHAs, so recurring flakes short-circuit.

**Where it is used:** `driver.sh` (transcript + per-tick capture), v1
`report-error.sh`. **Where it is absent: the entire v2 job fleet.** Every v2
service builds a digest temp file and inlines `$(cat "$digest")` straight into
the `claude -p` prompt.

Prioritized opportunities:

| Pri | Script | What fails | What output | Recommended change |
| --- | --- | --- | --- | --- |
| **1** | `scripts/jobs/gardener.sh` | the job handler (gardening state machine / `claude -p`) exits non-zero | the handler's **full stdout/stderr**, currently **discarded** (`:70-74`) | hash the handler output into the journal before completing; pass the SHA to a debugging responder (or the gardener/mentor inbox) instead of a one-line "exited non-zero"; reconsider completing a failed job as `tada`. |
| **2** | `scripts/jobs/mentor.sh` + `mentor-claude.sh` | n/a (cost/context) | the **whole `journalctl -p warning` tail** + full journal entry bodies, inlined at `mentor-claude.sh:36` | hash the digest into the journal; pass the SHA; let the mentor `cat-file`/`grep` only the relevant unit's lines. The journalctl tail is the single largest wholesale-inlined blob in the fleet. |
| **3** | `garden-pr.sh` / `panel.sh` | any stage `fail()` | `$GARDEN_TRACE_LOG` in `/tmp`, **lost on cleanup** | on `fail()`, hash the trace into the journal and emit the SHA in the terminal failure line, so the supervisor's debug subagent has a durable, selectively-inspectable artifact. |
| 4 | `triager-claude.sh` | n/a (context) | `git log --no-merges --stat`, capped `head -400` (`:27`) | replace the arbitrary 400-line cap with hash-capture; the responder pulls only the relevant commits via `cat-file`. The `head -400` is the poor-man's selective inspection. |
| 4 | `watchman-claude.sh` | n/a (context) | `git log --stat -- roles skills`, capped `head -400` (`:24`) | same as triager. |
| 5 | `bulletin.sh` | journalist `claude -p` fails | stderr **swallowed** `2>/dev/null` (`:177`) | capture the journalist's stderr by hash so the mentor can see *why* the narrative failed, without churning the deterministic dashboard path. |
| 5 | `proxy-claude.sh`, `foreman-claude.sh`, `follow-up-claude.sh` | n/a (context) | digest inlined (`:110`, `:77`, `:89`) | digests are small today; adopt the helper for uniformity once it exists. |

### The `common.sh` foundation

`scripts/jobs/common.sh` already owns the journal-clone plumbing (`ensure_clone`,
`sync_clone`, the per-service `$DIR` clones). A shared capture helper there would
let every script capture-and-hash uniformly. Sketch:

```sh
# capture_blob <file> [<clone-dir>] -> prints the blob SHA
capture_blob() { git -C "${2:-$DIR}" hash-object -w --stdin < "$1"; }
# inspect_note <sha> [<clone-dir>] -> the one-line brief handed to a responder
inspect_note() { printf 'inspect via: git -C %s cat-file -p %s\n' "${2:-$DIR}" "$1"; }
```

**Design nuance to resolve (recommendation, not a posted job):** the v1 driver
wrote captures into a lane worktree that *shared* the primary `.git`, so the blob
was reachable by any local reader. The v2 services each use a **separate clone**
under `$GARDEN_STATE/<svc>/journal`; a blob hashed there is **local until
pushed**. For a failure the *central mentor on another host* must inspect, the
capture must either be pushed (`git push origin <sha>:refs/captures/...`) or its
SHA written into a *committed* inbox file (exactly what `report-error.sh` does).
The helper should default to the service's own clone; whether/when to anchor or
push a capture cross-host is the judgment call that the `self-healing-wrapper`
skill should codify.

## Recommendations left for maintainer review (not auto-posted)

- **Systemd `OnFailure=` handler unit.** Add a `garden-self-heal@.service` that
  the oneshot units reference via `OnFailure=`, capturing the failed unit's
  recent journal into a hash and dispatching a debugging responder — a
  systemd-native complement to the central mentor's polling. Design-level.
- **`gardener.sh` failed-job semantics.** Today a failed handler is completed as
  `tada` (`:72`). Whether a failure should instead requeue (`todo`), move to a
  `failed/` lane, or stay `doin` for the reaper is a state-machine design
  decision (`designs/gardening-state-machine.md`), separate from the capture fix.
- **Retire-or-fold `driver.sh`.** Its self-healing wrapper is the best in the
  tree but on the superseded path. Decide whether to fold its
  `capture_and_self_improve` + EXIT-trap shape into the gardener/`common.sh` or
  let it lapse with the driver.
- **Deterministic-script escalation gaps.** `scheduler.sh` unparseable
  schedules, `repo-watcher.sh` `unit_ctl` failures, and `run-all.sh` dispatch
  failures are logged but never escalated; low priority, judgment call whether
  they merit a responder at all.

## Follow-up jobs posted

Idempotent basenames on the `journal2` board:

1. **`self-healing-wrapper-skill`** — author the canonical
   `skills/self-healing-wrapper/SKILL.md` (capture-on-failure → `claude -p`
   debugger with a task-specific role → propose/post a fix), citing
   `driver.sh`, `report-error.sh`, and the gardening state machine as exemplars.
2. **`self-heal-common-capture-helper`** — add `capture_blob`/`inspect_note` to
   `scripts/jobs/common.sh` (`shellcheck`/`bash -n` clean), and resolve the
   local-clone-vs-cross-host nuance above.
3. **`self-heal-port-capture-skills`** — port the v1
   `prompt-on-failure-capture` and `gardener-inbox-error-reporting` skills
   (incl. `report-error.sh`) into v2, retargeting the `journal2` branch.
4. **`self-heal-gardener`** — `gardener.sh`: on handler failure, capture the
   handler's output by hash and escalate (mentor/gardener inbox) instead of
   discarding it and completing the job as `tada` (Part-B opportunity #1).
5. **`self-heal-mentor-capture`** — `mentor.sh`/`mentor-claude.sh`: hash the
   journalctl + journal-entry digest and pass the SHA, so the mentor inspects
   selectively rather than inlining the whole tail (Part-B opportunity #2).
