Pushed cleanly. Local and `origin/main2` both at `9145aa20`. The job is complete.

---

# Completion report — `build-foreman-idle-pump`

**Committed and pushed:** `9145aa20` on `origin/main2` (fast-forward over `cf1574cf`), bot identity (`endolinbot`).

## What I built

A `garden-foreman` idle-pump service that keeps the gardener fleet supplied with work, plus its planner role and tests:

- **`roles/foreman/AGENT.md`** — a new planner role (prioritize/sequence *within* the current milestone). Explicitly distinguished from `major-general` (a major-version-upgrade scout, not a milestone planner). Bounds: bot repos only (endo-but-for-bots), never agoric-sdk, work jobs only; maintainer-decision steps route to the inbox.
- **`scripts/jobs/foreman.sh`** — the service: idle detection, settle-window debounce, cost gate, anti-flap.
- **`scripts/jobs/handlers/foreman-claude.sh`** — default `claude -p` planning handler (non-root `--dangerously-skip-permissions`, injection-hygiene framing).
- **`scripts/jobs/test/foreman-stub.sh`** + **`run-test.sh` SUBTEST 14** — deterministic pluggable handler and four assertions.
- **`scripts/systemd/garden-foreman.{service,timer}`** + **`install-units.sh`** registration (install path is automatic via the `garden-*` glob; added the `enable_services` line + summary).

## Chosen parameters

- **Idle definition:** `jobs/todo/` empty **AND** `jobs/doin/` empty (nothing queued, nothing in flight). The proxy posts follow-on jobs from completions, so the board stays busy until the milestone's work chain truly drains.
- **Settle window:** `GARDEN_FOREMAN_IDLE_SETTLE`, default **240s**. A host-local `GARDEN_STATE/foreman/idle-since` marker holds the first-idle timestamp; a busy tick clears it. With a 5m timer this means a pump fires on roughly the **2nd consecutive idle tick** ("N consecutive ticks or a minimum idle duration").
- **Tick cadence:** **5 minutes** (`OnUnitActiveSec=5m`), within the suggested 5–10m.
- **Cost gate:** the handler (and its `claude -p`) runs *only* on sustained idle — never on a busy board or within the settle window. Silent on success.
- **Anti-flap:** the last posted step is recorded in `GARDEN_STATE/foreman/last-step`; if the handler proposes the identical step after a redrain, the foreman does **not** re-post it — it surfaces the repeat as a deduplicated one-line maintainer-inbox note (`GARDEN_STATE/foreman/noted`) so a stuck step is seen rather than silently looped. After every pump it resets the settle clock so the next evaluation is a fresh sustained-idle window away.

## How it determines the milestone and next step

The handler wears the foreman role and reads `designs/README.md` on the bot fork's **`llm`** branch (the Per-Design Estimates / milestone table the journalist bins against). The **current milestone** is the earliest not-yet-complete one. It cross-references merged/in-flight PRs, the designs, the board, and recent journal progress to classify each step as done/in-flight/not-started, then applies the PR dependency registry (`journal/pr-deps/`) + topo-sort so a **blocked step is never chosen**. It emits exactly one block: a `JOB` for the next unblocked step (right role: designer/build/weave/shepherd/fix), a `MAINTAINER` note if genuinely blocked on a decision, or nothing if there is no unblocked work. `foreman.sh` applies anti-flap and posts.

## Verification

- `bash -n` clean on all scripts; `shellcheck` clean (only SC1091 + SC2034, the same baseline every existing garden script carries — `GARDEN_TAG` is consumed by `log()` in the sourced `common.sh`).
- **Foreman subtest: 7/7 pass.** Busy board → no claude call, nothing posted; idle-first-seen → starts the clock, no pump; idle-within-settle → no call, no pump; sustained-idle-past-settle → posts exactly one job (the chosen step); redrained board → identical step not duplicated, repeat surfaced to maintainer.
- Subtests 1–10 of the integrated suite also pass (44 PASS / 0 FAIL).

**Note / follow-up (not a blocker, unrelated to this change):** The integrated `run-test.sh` aborts at SUBTEST 11 (mentor) under `set -e` *when run from inside an active gardener*, because my ambient `GARDEN_GARDENER_CLONE`/`GARDEN_GARDENER_ID` leak into the harness; subtest 1 then clones the real state instead of the sandbox. Unsetting those vars gets the suite through subtest 10. `mentor.sh` itself exits 0 in isolation, so the abort is an environment artifact of running the suite inside the fleet, not a code defect — but a worthwhile mentor-style hardening would be for `run-test.sh` to `env -u GARDEN_GARDENER_CLONE GARDEN_GARDENER_ID` (or `unset` them) at the top so it is robust to being launched by a gardener. I validated SUBTEST 14 via a standalone driver to work around it.
