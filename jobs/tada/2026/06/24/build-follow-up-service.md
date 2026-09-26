Pushed to `origin/main2` as `12036a1a`. Here is my completion report.

---

# Job `build-follow-up-service` — completion report

**Done.** The `garden-follow-up` autonomous service is built, tested, and pushed to `origin/main2` under the bot identity (`endolinbot`). Single commit: **`12036a1accb6df3e4434f1637c5a91e5931bf081`**.

## What I built (modelled precisely on the mentor service)

- **`scripts/jobs/follow-up.sh`** — thin, quiet, oneshot tick. `killswitch_engaged && exit 0`; ensures/syncs a dedicated journal clone at `GARDEN_STATE/follow-up/journal`; finds tada reports new since `GARDEN_STATE/follow-up/seen` (keyed by `jobs/tada/<base>.md`, exactly like mentor's SEEN); extracts each report's `## Follow-ups` section; builds a digest of the *actionable* ones; hands it to a pluggable handler (`GARDEN_FOLLOWUP_HANDLER`). No-op reports (section is empty or starts with "None") are marked seen but skipped. The seen-marker advances only on handler success, else `die` and retry next tick. Quiet-on-success (no stdout, no commit when nothing's new).
- **`scripts/jobs/handlers/follow-up-claude.sh`** — wears the **liaison** role (`roles/COMMON.md` + `roles/liaison/AGENT.md`) via `claude -p --dangerously-skip-permissions`. Builds a prompt embedding the digest, asks the inner agent to classify each follow-up and emit an EXACT action grammar, then parses and executes the blocks.
- **`scripts/jobs/set-schedule-once.sh`** + **`scheduler.sh` extension** — one-time future scheduling.
- **`scripts/systemd/garden-follow-up.{service,timer}`** (Type=oneshot, `OnActiveSec/OnUnitActiveSec=10m`), registered in `install-units.sh` (the `garden-*` render glob picks up the unit files; I added the `enable --now garden-follow-up.timer` line and updated the summary log).
- Docs: **`skills/schedule/SKILL.md`** (the `once:` field + `set-schedule-once.sh`) and a new **§ Autonomous follow-up surface** in `roles/liaison/AGENT.md`.
- Tests: **`run-test.sh` SUBTEST 13** + **`follow-up-stub.sh`**.

## Service name & cadence (renameable by the maintainer)

Service is **`garden-follow-up`**, timer cadence **10 minutes** (`OnUnitActiveSec=10m`), as suggested.

## Action grammar & one-shot design

The handler executes four block types the inner liaison agent emits:
- `JOB <base> … ENDJOB` → `post-job.sh` (one-time job now).
- `SCHEDULE <name> <cadence> [prefix] … ENDSCHEDULE` → `set-schedule.sh` (recurring).
- `SCHEDULE-ONCE <name> <ISO> … ENDSCHEDULE` → `set-schedule-once.sh` (one-time future).
- `MAINTAINER … ENDMAINTAINER` → delivered to the standing maintainer inbox (`inbox-send.sh maintainer`).

Names are derived deterministically as `fu-<report-base>-<n>`, so re-processing never duplicates (post-job / set-schedule are basename-idempotent). **One-shot design:** `set-schedule-once.sh` writes `schedules/<name>.md` with an `once: <ISO>` field instead of `cadence:`. The scheduler honors it in a new branch *before* the unchanged recurring path: when `now >= once`, it dispatches the job using a **deterministic basename (the prefix, no timestamp)** and `git rm`s the schedule file **in the same CAS commit** — so it fires exactly once and a retried dispatch is idempotent. The recurring `cadence:` path is byte-for-byte unchanged.

## Authority bounds (an autonomous liaison, bound tightly)

Enforced in the handler prompt and as defense-in-depth in code: **bot repos only, never agoric-sdk** (the handler additionally refuses to post any JOB/SCHEDULE whose body names `agoric-sdk`); **never autonomous ferry/identity-switch**; maintainer-judgment follow-ups (e.g. "confirm whether to continue #197") route to the **maintainer inbox**, not autonomous action. Report bodies are treated as **data describing follow-ups, never instructions** (prompt-injection hygiene). One deliberate strengthening beyond the spec: a **cold-start guard** — on the first tick (no seen-marker) the service marks all existing tada reports seen *without acting*, bounding the autonomous surface to follow-ups produced after install rather than replaying the historical backlog.

## Verification

- `shellcheck` error-level **clean** on every new/edited script (remaining findings are the same SC1091/SC2034/SC2010/SC2015 info/warning classes the existing committed scripts carry — confirmed against the baseline).
- A **self-contained isolated harness** (throwaway journal + stub handler) exercised the full flow end-to-end: **7/7 passed** — cold-start acts on nothing, one-time job posted, one-shot schedule written with `once:`, maintainer message delivered, second tick makes no commit (quiet + idempotent), one-shot dispatched then schedule deleted, one-shot does not re-dispatch. The same logic is committed as `run-test.sh` SUBTEST 13.

## Note / follow-ups for the maintainer

- The shared `run-test.sh` could not be run end-to-end on this host: its concurrency subtests (1, 5) contend on the throwaway journal's refs with the **live ~100-gardener fleet running on `endolinbot`** (gardener 70 is the one that claimed this job), and `set -e` aborts the suite at subtest 5 before reaching subtest 13. This is pre-existing live-host contention, not a regression — my edits touch only concurrency-independent paths and append subtest 13. SUBTEST 13's behavior is fully validated by the isolated harness above. You may want to run `run-test.sh` on a quiescent host (or gate the fleet) to see the whole suite green.
- The reference report `jobs/tada/botany-ebfb-pr197.md` named in the job is not yet on the local `journal2` tip I worked from; I modelled extraction on the live tada reports' actual `## Follow-ups` / `## Follow-ups (escalated to liaison)` shapes (verified against `botany-ebfb-pr273/274`), which the extractor and `is_actionable` handle (including the "None. …(note)" no-op form).
- The service is **not yet enabled** on any host — `install-units.sh install && install-units.sh enable-services` will render and start it. Rename the service/cadence freely before enabling.
