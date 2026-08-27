# The continuous Ironhorse fuzz service

The garden drives the Ironhorse libFuzzer campaign **continuously in the
background** — off the pull-request critical path — and turns every distinct
reproducible crash into one durable, deduplicated **repair job** that
creates-or-amends **one standing bot-fork pull request** (case + fix). This page is
the operator's entry point; the mechanics live in
[`designs/continuous-ironhorse-fuzz.md`](../../designs/continuous-ironhorse-fuzz.md)
and `scripts/jobs/ironhorse-fuzz.sh`.

Directive: kriskowal on endojs/endo-but-for-bots#1046 — *"move the fuzzer out of
CI and drive it continuously in the background from a new garden service; we should
have a standing pull request that is created or amended for each ironhorse fuzz case
and solution."* Pull-request CI no longer runs `fuzz-ironhorse`; the campaign lives
here instead.

## What it is

- A **leader-only** `garden-ironhorse-fuzz.{service,timer}` singleton — a
  `Type=oneshot` tick that runs a **bounded fuzz increment** each firing over a
  **persistent corpus**, so the campaign is continuous, restart-safe, and never
  runs on two hosts at once.
- **Deterministic orchestration, no LLM.** The tick captures crashes, confirms
  reproduction, minimizes, dedups by a stable `sha256` identity, and posts one
  `builder` repair job per distinct finding. The only LLM work is inside those
  bounded repair jobs.
- **Untrusted-data safe by construction.** Crash bytes are handled only by path
  and surfaced to the repair job as bounded metadata + a durable artifact
  path/hash + an inert base64 blob — never inlined into a shell command or a
  prompt.

## Activation (deliberate — not auto-armed on a live host)

The unit installs through the normal machinery and is auto-enabled by presence:

```sh
scripts/jobs/install-units.sh install          # render + install (picks up the new unit)
scripts/jobs/install-units.sh enable-services   # enable the timer (leader-only at runtime)
```

Before it can actually fuzz on the leader host, provision the pinned toolchain once
(heavy, one-time):

```sh
# On the LEADER host, as the bot user:
rustup toolchain install nightly-2026-08-15
cargo install cargo-fuzz --locked
# The first tick provisions the pinned project checkout under
# $GARDEN_STATE/ironhorse-fuzz/project and initializes the c/moddable submodule
# (point GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER at a warm peer checkout to skip the
# multi-GB fetch — see the ironhorse-fuzz-build-setup runbook).
```

Until the toolchain is present the tick logs a WARN and skips each target cleanly
(no crash, no host impact) — it is inert, not broken.

## Where its state lives

Durable, outside any job worktree:

- `$GARDEN_STATE/ironhorse-fuzz/corpus/<target>/` — the persistent, size-capped corpus.
- `$GARDEN_STATE/ironhorse-fuzz/findings/<id>/` — minimized input + metadata + repro log.
- `$GARDEN_STATE/ironhorse-fuzz/project/` — the pinned project checkout under fuzz.
- journal `ironhorse-fuzz/standing.md` — the standing-PR generation/branch/marker/state.
- journal `ironhorse-fuzz/findings/<id>.md` — per-finding dedup marker + portable provenance.

## The standing pull request

All findings in a generation amend **one** PR on the bot branch
`ironhorse-fuzz-findings` (in `endojs/endo-but-for-bots`, base `llm`), adopted by the
durable `<!-- garden-job: ironhorse-fuzz-findings -->` marker. When that PR **merges
or closes**, the service archives the record, **bumps the generation**, and the next
reproducible finding opens `ironhorse-fuzz-findings-2`, and so on — no finding lost,
no duplicate PR. The unsolved-finding backlog is the set of finding markers whose
repair job has not yet landed a fix.

## Tuning (systemd unit + env)

The unit carries the fleet's first singleton cgroup bounds (`MemoryMax=8G`,
`MemoryHigh=6G`, `CPUQuota=150%`, `TasksMax=512`); raise them on a dedicated fuzz
host, lower on a contended one. The tick reads `GARDEN_IRONHORSE_FUZZ_*` overrides
(targets, per-target seconds, corpus cap, artifact-byte cap, per-tick finding cap,
repo/branch/toolchain) — all documented at the top of `scripts/jobs/ironhorse-fuzz.sh`.

## Verifying it without waiting for a real crash

```sh
scripts/jobs/test/ironhorse-fuzz-test.sh        # hermetic: 26 assertions, no GitHub/cargo
scripts/jobs/test/ironhorse-fuzz-rehearsal.sh   # narrated synthetic-crash rehearsal end to end
```
