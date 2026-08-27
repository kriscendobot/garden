# Design: the continuous Ironhorse fuzz service — take fuzzing out of PR CI, run it forever in the background, and funnel every finding to one standing pull request

A deterministic, leader-only garden background service that drives the Ironhorse
libFuzzer campaign **continuously** off the critical path of pull-request CI, and
turns every distinct reproducible crash into a durable, deduplicated **repair job**
that creates-or-amends **one standing bot-fork pull request** carrying the
regression case and its fix.

Maintainer directive (kriskowal, endojs/endo-but-for-bots#1046, comment
5446442895): *"Please post a job to move the fuzzer out of CI and to drive it
continuously in the background from a new garden service instead. We should have a
standing pull request that is created or amended for each ironhorse fuzz case and
solution."*

Sibling services to model on — each a deterministic, no-LLM-before-the-gate
producer that reads its own external source, dedups against board+journal state,
and posts exactly one job: the **pages-watcher**
([`scripts/jobs/pages-watcher.sh`](../scripts/jobs/pages-watcher.sh)) and the
**dependabot-watcher** ([`scripts/jobs/dependabot-watcher.sh`](../scripts/jobs/dependabot-watcher.sh)).
The **sysop** design ([`designs/sysop.md`](sysop.md)) is the prose template for a
bounded, restart-safe standing daemon.

---

## 0. The gap this closes

Today the Ironhorse fuzzers run **inside pull-request CI** — the `fuzz-ironhorse`
job in `endojs/endo-but-for-bots` `.github/workflows/ci.yml` (a 30-minute smoke over
four of the nine maintained targets, gated on an ironhorse-relevant path change).
That placement is wrong in three ways:

- **It blocks unrelated pull requests.** A fuzz smoke that happens to trip a
  latent crash reddens a PR that changed nothing near Ironhorse. Fuzzing finds
  *pre-existing* latent bugs by construction; gating a feature PR on "the fuzzer
  found something today" couples unrelated work.
- **It is a weak campaign.** 30 seconds per target on a cold, run-scoped corpus
  (the CI corpus cache is keyed on `github.run_id`, so it never accumulates) is a
  smoke test, not a campaign. Real fuzzing wants a persistent, growing corpus and
  hours of compute, which a PR gate can never give.
- **A finding evaporates.** A red CI leg uploads a crash artifact that expires
  with the run. There is no durable trophy, no dedup, no tracked path to a fix.

The service moves the campaign to where it belongs: a **continuous background
process on the leader host**, with a **persistent corpus**, that funnels findings
into a **durable, deduplicated, visible** repair pipeline — while ordinary PR CI
stops carrying fuzzing entirely.

---

## 1. Shape: a bounded per-tick increment, not an unbounded process

The service is a **`Type=oneshot` timer tick** (`garden-ironhorse-fuzz.{service,timer}`),
exactly like the other leader-only singletons — **not** a long-running daemon. Each
tick runs a **bounded increment** of the campaign:

- Fuzz each maintained target for a bounded wall-clock budget
  (`-max_total_time`), against a **corpus that persists between ticks** in
  `$GARDEN_STATE` (never a job worktree). Continuity comes from the timer firing
  repeatedly over the same growing corpus, not from one endless process.
- `Type=oneshot` is the concurrency guard: systemd will not start a second tick
  while one is active, so two increments never race on the same host; the
  leader-only `ExecCondition` keeps two *hosts* from running the same campaign.
- Restart-safety is free: a killed tick simply loses that increment's in-RAM
  progress; the corpus, the dedup markers, and the standing-PR state are all
  durable, so the next tick resumes the campaign where the corpus left off.

This bounded-duty-cycle shape is what makes the campaign **restart-safe and
resource-bounded** while still being "continuous" in the sense the maintainer
asked for: it runs forever, in the background, off the PR critical path.

### Resource bounds

The unit is the **first leader-only singleton to carry real cgroup limits**
(modeled on `garden-worker@.service.in`): `MemoryAccounting=yes` + `MemoryHigh`/
`MemoryMax` confine an OOM to the fuzz cgroup so a memory-hungry target cannot
snipe an innocent singleton or the host; `CPUQuota` caps the duty cycle;
`TimeoutStartSec` bounds the tick; the per-target `-max_total_time` and a
`-rss_limit_mb` bound each libFuzzer process; and the service prunes the corpus
back under a configured size cap every tick. A fuzz crash or OOM takes down at
most the tick, never a gardener, a singleton, or the host.

---

## 2. Untrusted-data discipline (load-bearing)

Fuzzer output and crash bytes are **untrusted input** — a crash is, by definition,
whatever adversarial bytes the fuzzer synthesized. The service therefore treats
every artifact as hostile data and **never interpolates crash bytes into a shell
command or an LLM prompt**:

- The stable **finding identity** is a hex `sha256` over `target \0 minimized-bytes`
  — inert, safe to name files and jobs with.
- The repair job body carries **only bounded metadata**: target (validated against
  the fixed target allowlist), project SHA, toolchain, libFuzzer options, the
  artifact's `sha256`, its durable path, and the exact reproduction command. The
  raw bytes reach the repair job **only** as a durable file path/hash and as an
  inert base64 blob it decodes to disk — never inlined into the prompt text.
- The service never `eval`s, never word-splits artifact content, and passes crash
  files to the fuzzer **by path**, never by value.

The service is **deterministic orchestration**. The only LLM work is inside the
bounded repair jobs it posts, and each of those independently **reproduces** the
case from the durable artifact before it changes any code.

---

## 3. State layout

**Durable host-local state** (`$GARDEN_STATE/ironhorse-fuzz/`, survives job-worktree
teardown and restart; the corpus can be large so it lives here, never in the
journal):

```
$GARDEN_STATE/ironhorse-fuzz/
  journal/                 dedicated journal clone (CAS writes)
  project/                 pinned project checkout for the campaign (submodule-initialized)
  corpus/<target>/         persistent, growing corpus per target (size-capped)
  findings/<finding-id>/   input.bin  meta.md  repro.log   (raw bytes stay on disk)
  logs/                    per-tick campaign logs
```

**Durable journal state** (branch `journal2`, small text only — dedup and
lifecycle, no large binaries):

```
ironhorse-fuzz/standing.md            standing-PR lifecycle (generation/branch/marker/pr/state)
ironhorse-fuzz/standing-archive/<g>.md   retired standing-PR records (post-merge rollover)
ironhorse-fuzz/findings/<finding-id>.md  per-finding dedup marker + provenance (base64 minimized input, no host path dependence)
```

Provenance recorded for every finding — enough to reproduce it anywhere:
**target, project SHA, toolchain, libFuzzer seed/options, artifact `sha256`, the
inert base64 of the minimized input, and the exact command**. The journal marker
makes dedup and reproduction survive both a service restart **and** a leader
handoff to another host.

---

## 4. Finding identity and deduplication

A finding is identified by `finding-id = sha256(target "\0" minimized-input)[:16]`.
Two independent dedup gates make repeated discovery and restart idempotent:

1. **Journal marker** `ironhorse-fuzz/findings/<finding-id>.md` — if it exists, the
   finding was already handled; skip. This survives host loss.
2. **Board pre-check** — `posted_anywhere ironhorse-fuzz-<finding-id>-repair`
   across `plan/todo/doin/tada` (the pages-watcher idiom), plus `post-job.sh`'s own
   basename+`--identity` idempotency as belt-and-suspenders.

So the same crash rediscovered on the next tick, or after a restart, posts **no
duplicate job and no duplicate PR commit**. Two *distinct* crashes (distinct
minimized bytes) yield two distinct finding-ids and two repair jobs.

Minimization (`cargo fuzz tmin`) before identity means two inputs that reduce to
the same root cause collapse to one finding; it is the stable key, not the raw
fuzzer output.

---

## 5. The standing pull request and its rollover

There is **one open standing PR per generation**, on a stable bot-owned branch in
`endojs/endo-but-for-bots` (base `llm`), carrying the durable
`<!-- garden-job: <marker_base> -->` marker that
[`ensure-pr.sh`](../scripts/jobs/gardening/ensure-pr.sh) uses to **create-or-adopt**.
Every repair job in a generation targets the same branch and the same marker, so
the **first** finding of a generation *creates* the PR and **every** later finding
*adopts and amends* it — never a duplicate PR, never a duplicate commit (the
finding-id dedup upstream guarantees each amendment is distinct).

**Rollover after merge/close.** The service owns the lifecycle deterministically.
Each tick, if `standing.md` records an open PR, it re-checks that PR's state:

- **still open** → repair jobs keep amending it.
- **merged or closed** → archive the record to `standing-archive/<gen>.md`, **bump
  the generation**, and point the *next* finding at a fresh branch
  `ironhorse-fuzz-findings-<gen+1>` with a fresh marker. The PR is **not**
  pre-created; the next reproducible finding creates it, so a quiet period after a
  merge costs nothing and no empty PR is opened.

Crucially, rollover is decoupled from finding capture: a finding is **always**
represented (durable marker + repair job) regardless of standing-PR state, so
nothing is lost in the merge→rollover window, and nothing is duplicated because the
generation bump is a single CAS write the next finding reads.

A finding that **cannot yet be solved** is still durable and visible: its journal
marker persists and its repair job reports the unsolved case into the standing PR
(body or comment) rather than silently disappearing — the backlog is the set of
finding markers whose repair job has not landed a fix.

---

## 6. The repair-job contract

For each reproduced finding the service posts one uniquely-keyed repair job
(`ironhorse-fuzz-<finding-id>-repair`, role `builder`) that owns **both** halves:

- a **load-bearing regression case** — because `fuzz/corpus/` and `fuzz/artifacts/`
  are gitignored (a corpus seed cannot be committed as a permanent regression), the
  durable case is a **Rust unit test in `ironhorse-vm`** that replays the minimized
  bytes and asserts no panic (per the ironhorse-fuzz-build-setup runbook); and
- the **causal fix**.

It **reproduces first**: decode the inert base64 (or read the durable path),
verify the `sha256`, run the exact reproduction command, and only then change code.
It amends the standing branch with **fetch/rebase/push CAS** discipline, calls
`ensure-pr.sh <marker_base>` to create-or-adopt the standing PR, runs the required
gauntlet, and documents the case and solution in the PR body or a PR comment. An
unsolvable case is reported visibly rather than dropped.

---

## 7. Project-side change (separate bot-fork PR)

In `endojs/endo-but-for-bots`, the `fuzz-ironhorse` PR-CI job is a **leaf** (no
`needs:` references it) occupying `ci.yml` lines 758–899; it is removed wholesale
along with its job-local wiring (the `FUZZ_TOOLCHAIN` env, both `actions/cache`
blocks, the submodule fetch, the toolchain/cargo-fuzz install, the lockfile-freshness
step, the run, and the artifact upload). The nine fuzz targets, the `fuzz/`
cargo-fuzz project, and the local `cargo +nightly fuzz run <target>` workflow are
**preserved and documented**; the pinned nightly — recorded *only* in that CI env
today — is relocated into a `rust/engine/ironhorse-fuzz/fuzz/rust-toolchain.toml`
and a README note so local runnability survives. This change ships as its own
appropriately-based bot-fork PR and runs the required gauntlet.

---

## 8. Activation

The unit installs through the normal `install-units.sh` machinery (drop a
non-template `.service`+`.timer` with `WantedBy=timers.target` into
`scripts/systemd/` → auto-enabled). It is **inert until armed**: it runs only on
the leader, only for the authorized bot fork, and does nothing until its pinned
project checkout is provisioned. It never touches upstream `endojs/endo`, never
switches identity, and never ferries. Operator procedure:
[`context/operations/ironhorse-fuzz.md`](../context/operations/ironhorse-fuzz.md).

This design was landed by the build job that implements it; the contract above is
realized in `scripts/jobs/ironhorse-fuzz.sh` and its hermetic tests, so it lands
bare (no open questions, no review PR).
