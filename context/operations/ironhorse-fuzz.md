# The continuous Ironhorse fuzz service

The garden drives the Ironhorse libFuzzer campaign **continuously in the
background** — off the pull-request critical path — captures every distinct
reproducible crash as a durable, deduplicated **finding**, **triages** findings in
bounded batches, and opens repair work only for **clusters of probable port
defects** that create-or-amend **one standing bot-fork pull request** (cases +
fix). This page is the operator's entry point; the mechanics live in
[`designs/continuous-ironhorse-fuzz.md`](../../designs/continuous-ironhorse-fuzz.md),
[`designs/ironhorse-fuzz-triage-and-batch.md`](../../designs/ironhorse-fuzz-triage-and-batch.md)
(the triage/batch/backpressure contract), and `scripts/jobs/ironhorse-fuzz.sh`.

> **PAUSED (2026-08-31).** `garden-ironhorse-fuzz.{timer,service}` are in
> `EXCLUDED_UNITS` (`scripts/jobs/install-units.sh`), so a deploy cannot re-arm the
> lane. The triage-and-batch backpressure is now implemented (below); re-arming is
> still the deliberate maintainer act described under **Re-arming** at the end of
> this page.

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
  reproduction, minimizes, dedups by a stable `sha256` identity, then applies three
  producer-side controllers before releasing any work (below). The only LLM work is
  inside the bounded **triage** and **cluster-repair** jobs it posts.
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
- journal `ironhorse-fuzz/triage/<id>.md` — per-finding triage record (`status:` one of
  `pending|genuine|artifact|duplicate`, plus bounded diagnostic fields). Written by
  the triage job, read by the producer.
- journal `ironhorse-fuzz/clusters/<cluster-id>.md` — a cluster of genuine findings
  sharing one root signature; one cluster repair per generation.
- journal `ironhorse-fuzz/backpressure.md` — the hysteretic band's persisted state
  (`fuzzing: running|stopped`); written only when the state flips.
- journal `ironhorse-fuzz/migrations/triage-batch-v1.md` — the legacy-backlog
  migration manifest (see **Re-arming**).

## The triage-and-batch controllers (backpressure)

A finding moves `captured -> triage-pending -> genuine -> clustered -> repaired`
(terminal: `artifact` or `duplicate`). The producer never classifies a finding
itself — that is the triage job's LLM work; it only reads the durable records and
releases **at most one bounded job per tick**, gated by three controllers:

1. **Hysteretic band** (the only one in the repo). Before running any target it
   counts nonterminal findings. **High water** — 24 total or 8 for any one target —
   stops every fuzz run; **low water** — below 12 total *and* below 4 for every
   target — resumes. The gap prevents one completion from flapping the timer. Even
   while stopped it still releases one triage or cluster job, so the backlog drains.
   Tunable via `GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL/TARGET` and
   `..._LOW_WATER_TOTAL/TARGET` (the band self-reverts to 24/8 over 12/4 if an override
   inverts the ordering).
2. **Doom-signature feedback.** The reaper quarantines a refused repair into
   `jobs/plan/` with `doom_signature:`. When one target accumulates
   `GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N` (default 3) same-signature dooms, the producer
   stops releasing triage/cluster work for **that target** regardless of queue depth
   — the policy-refusal cluster is the stop signal. Clearing the quarantine (a
   deliberate maintainer act) lifts it.
3. **Serialization.** At most one triage job and one cluster repair are live at a
   time, and triage release pauses while a cluster repair is changing the standing
   head. A triage job handles the <=12 oldest pending markers for one target; a
   cluster holds <=8 genuine findings sharing a root signature.

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
scripts/jobs/test/ironhorse-fuzz-test.sh        # hermetic: 70 assertions, no GitHub/cargo
                                                #   (incl. backpressure band P, doom feedback Q,
                                                #    migration R, and the paused-lane guard S)
scripts/jobs/test/ironhorse-fuzz-rehearsal.sh   # narrated synthetic-crash rehearsal end to end
```

## Re-arming (a deliberate two-part maintainer act)

The lane stays paused until **all** of the following, in order (per
[`designs/ironhorse-fuzz-triage-and-batch.md`](../../designs/ironhorse-fuzz-triage-and-batch.md)
§ Implementation and re-arming):

1. Land and **deploy** this implementation.
2. **Run the legacy-backlog migration** (one idempotent journal CAS op — it never
   promotes a doomed job, only takes custody of the backlog and seeds triage), then
   let the triage stage work the backlog below low water:

   ```sh
   # On the LEADER host, as the bot user. Preview first, then run:
   scripts/jobs/ironhorse-fuzz-migrate-backlog.sh --dry-run
   scripts/jobs/ironhorse-fuzz-migrate-backlog.sh
   ```

   It supersedes every legacy `ironhorse-fuzz-<id>-repair` (and the old
   `ironhorse-fuzz-repromote-quarantined` job) without deleting any finding marker,
   seeds a `pending` triage record for each unresolved finding, and writes the
   manifest. It **fails closed** on a missing marker or a legacy job live in
   `jobs/doin/`. It uses its own journal clone/CAS path — it never touches the
   deployed root's `journal/` worktree.
3. Remove **both** `garden-ironhorse-fuzz.timer` and `garden-ironhorse-fuzz.service`
   from `EXCLUDED_UNITS` in `scripts/jobs/install-units.sh`, then deploy that change.
4. On the leader host: `systemctl --user enable --now garden-ironhorse-fuzz.timer`
   and confirm the first tick logs the triage-and-batch schema (backpressure counts +
   a triage/cluster release, not a per-finding repair).

The two-part pause is deliberate: repository exclusion prevents a deploy from
undoing the pause, and the host-local enable is the operator's explicit activation.
