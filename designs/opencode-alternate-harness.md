---
created: 2026-07-28
updated: 2026-07-28
author: designer
---

# Design: opencode as an alternate worker harness

| Field | Value |
| --- | --- |
| Status | Proposed (investigation only — no provider armed, no spend) |
| Directive | kriskowal, 2026-07-28: *"investigate using opencode as an alternate harness for applicable models … evaluating jobs across more dimensions and perhaps having an easier route to more models."* |
| Decision | **Adopt-narrowly, probe first.** opencode is worth a bounded probe as a *harness-diversity* backend — one kind per provider it fronts, sharing a single handler, gated by the existing explicit-model-only lane discipline. Do **not** adopt it as a single many-provider kind, and do **not** add "harness" as a new arm dimension. |
| Evidence | opencode docs captured 2026-07-28 (treated as DATA): [cli](https://opencode.ai/docs/cli/), [server](https://opencode.ai/docs/server/), [permissions](https://opencode.ai/docs/permissions/), plus the `run --format json` event shape and on-disk storage layout (see § Sources). |

## What opencode is

opencode is an open-source terminal AI coding agent (`github.com/anomalyco/opencode`,
formerly `sst/opencode`) — a TUI/CLI/IDE agent in the same family as `claude` and
`codex`. Unlike those two, it is **provider-agnostic by construction**: it resolves
models through the [Models.dev](https://models.dev) catalog and per-provider API
keys, so one binary fronts many providers under a `provider/model` namespace
(`-m anthropic/claude-…`, `-m openai/…`, `-m google/gemini-…`, `-m moonshotai/…`,
plus a curated "OpenCode Zen" set and arbitrary custom OpenAI-compatible providers).

It ships a headless subcommand, `opencode run [message…]`, and a headless HTTP
server, `opencode serve`. The headless `run` path is the garden-relevant seam: it is
the direct analogue of `claude -p` and `codex exec`.

### What reach it actually adds

The honest incremental value is narrower than "more models" suggests, because the
**codex handler already fronts any OpenAI-compatible endpoint** — the `cleric`
(OpenAI), `hermit` (local Ollama `/v1`), and `fireworker` (Fireworks) kinds all
share `cleric-codex.sh`, and that custom-provider path already reaches OpenRouter,
Groq, DeepSeek, Together, and friends. So opencode does **not** unlock
OpenAI-compatible providers we can't already reach. What it *does* add is two things
the incumbents cannot express:

1. **Providers whose native API is not OpenAI-shaped** and that Models.dev
   normalizes — most notably Google Gemini (native) and Anthropic (native), and
   whatever else the catalog covers, without hand-writing a provider adapter.
2. **Harness diversity.** opencode is a genuinely different agent scaffold (tool
   loop, planning, edit strategy) than `claude` or `codex`. Running the *same model*
   under a *different harness* is a real evaluation axis: agents differ in tool-use
   competence on identical weights. This is the "more dimensions" the directive
   asks for — and, as § The kind-vs-dimension question shows, the reputation arm key
   **already captures it**, because `kind` leads the key.

## The kind-vs-dimension question (the design core)

Reputation arms are keyed
`arms/<kind>/<provider>/<model>/<thoughtfulness>/<work_class>@<target>`
([bid-auction](../skills/bid-auction/SKILL.md)). The job spec frames the worry as
"harness is not a dimension — it is implied by kind, so the garden cannot express
the same model under two harnesses." That framing is half right, and the correction
is the crux of the recommendation:

- **`kind` already *is* the harness axis.** It is the *leading* segment of the arm
  key, and each kind binds to exactly one handler, which binds to exactly one
  harness. `gardener` = the `claude` harness; `cleric`/`hermit`/`fireworker` = the
  `codex` harness; `mystic` = the Kimi harness. Two different kinds on the *same*
  provider/model are already two *distinct arms* the auction scores independently.
  So "the same model under two harnesses" **is expressible today** — as two kinds —
  the moment a second kind can reach that provider/model.
- **The real tension is not expressiveness; it is the one-kind↔one-provider
  invariant.** A single opencode kind spanning anthropic + google + openai + …
  would break two things that assume kind determines provider: `job_eligible_for_kind`
  (`claim-job.sh`, which derives the pinned provider and admits only the matching
  kind) and the `(kind, provider)` pairing in the arm key (now many-to-one).

Three options, and what each lets the auction *learn*:

| Option | Shape | What the auction learns | Cost / blast radius |
| --- | --- | --- | --- |
| **A. One many-provider opencode kind** | `kind = opencode`, provider derived per-job from the pin | opencode-vs-native *in aggregate*, but the `(kind,provider)` invariant is broken: eligibility must re-derive provider inside the kind, and "unpinned never leaks to a paid provider" must be re-established *within* the kind. | Rewrites `job_eligible_for_kind`'s kind↔provider assumption; risk of unpinned work wandering onto paid Gemini/Anthropic. |
| **B. Harness as a new explicit arm dimension** | `arms/<kind>/<harness>/<provider>/…` | Nothing that A or C don't already give — because `harness` is *functionally determined by kind* (a kind runs one handler runs one harness). The new segment is redundant. | Highest: changes every arm path under `reputation/arms/`, and the **reducer is the sole writer** (`reputation-reduce.sh`) — a migration of all projections for zero added expressiveness. |
| **C. One opencode kind *per provider*, one shared handler** ✅ | `opencode-anthropic`, `opencode-google`, … each `provider`-bound, all reusing one `handlers/opencode.sh` parameterized by provider — exactly the cleric/hermit/fireworker pattern on `cleric-codex.sh` | The full harness A/B: `opencode-anthropic` and `gardener` are two kinds on the same anthropic/opus → two arms scored independently. Per-provider accept-rate and cost of *the harness itself* become first-class. | Lowest: `job_eligible_for_kind` and the `(kind,provider)` pairing are **untouched**; each paid `opencode-<provider>` kind is an explicit-model-only lane like `fireworker`/`mystic`. |

**Recommendation: option C.** Keep harness encoded in `kind`; represent opencode as
one kind per provider it fronts, all sharing a single handler. This preserves every
invariant, makes the harness comparison fall out for free, and confines the
"more models" cost to what it genuinely is.

**What C reduces and what it does not.** opencode collapses the *handler-per-provider*
cost — the expensive part — because one `opencode.sh` fronts every provider it
reaches (the same way `cleric-codex.sh` already fronts three). It does **not**
eliminate the per-provider *registry wiring* (a `worker_kind_field` row, a
`count_key`, a `hosts/<host>` line, an eligibility branch). But that wiring is
already table-driven and mechanical; the handler is the part that was costly, and
that is exactly what a multi-provider harness removes. The `fireworker` lane — wired
but **undeclared** (no `fireworkers:` line on this host, so inert) — is the precedent
for how cheap that residual wiring is.

## Constraint-by-constraint verdict

The eight load-bearing constraints from the job spec, each verified against
opencode's documented behavior rather than assumed.

### 1. Deterministic session id + resume — ⚠️ PARTIAL (sidecar tier, not deterministic tier)

`gardener-claude.sh` pins a **deterministic** session id, `uuid5(URL, "garden-job:"+base)`,
and passes `--session-id` on first run so a basename-preserving requeue can
`--resume` the *same* id and carry the transcript forward. **opencode cannot accept
a client-chosen session id at first run**: the server *assigns* the id
(`POST /session` returns it; the body takes only `parentID`/`title`), and the CLI's
`--session`/`-s <id>` only *continues an already-existing* server-assigned session.

This is **not disqualifying** — it is exactly the `codex` situation, which the
`cleric-codex.sh` handler already solves: codex also assigns its own id, and the
handler **parses the id out of the JSON stream and persists it to a per-base
sidecar** under `$GARDEN_STATE`, so a same-host requeue resumes via
`codex exec resume <sid>`. opencode fits the identical pattern: `run --format json`
emits `sessionID` in **every** event (including the *early* `step_start`), so the
handler parses it, writes `$GARDEN_STATE/<state_ns>/sessions/<base>`, and resumes
with `-s <sid>`. Best-effort, same-host, uncommitted work carries the state across
a cross-host requeue — the spine's requeue semantics never depended on backend
resume.

**Verdict:** opencode joins the **sidecar-resume tier** (with codex/kimi), not the
deterministic-uuid5 tier (claude only). Adoptable. Parse `sessionID` from
`step_start`, *not* only the terminal event (see hazard in constraint 2).

### 2. Cost ledger — ✅ PASS, and stronger than codex

The handler must write `usage/<base>.jsonl` or `complete-job.sh` fails open to
`agentic_dollars: censored`, which **freezes the arm** (censored events never
increment `attempts`/`accepts` — the live mystic/moonshot bug, open jobs
`fix-censored-events-frozen-reputation-arm` / `wallclock-cost-proxy-for-censored-arms`).

opencode is a genuine improvement here: `run --format json` emits `step_finish`
events carrying **`cost` in USD** *and* detailed token counts (`input`, `output`,
`reasoning`, `cache.read`, `cache.write`), **per provider, uniformly**, priced from
Models.dev. This is *better* than codex — which reports tokens but **no dollars**,
leaving reputation deliberately unpriced — and comparable to claude's own envelope.
A multi-provider harness that reports real USD across all its providers is a point
*for* opencode, not against it.

Two caveats, both handler-level and both must be coded defensively:

- **Unpriced models.** cost is only as good as Models.dev's price for that id. A
  custom/local/unlisted model may report `cost: 0` or omit it → censored-arm risk
  returns. Do not fabricate a rate; treat a genuinely absent price as an accounting
  miss and prefer a paid, priced model for the probe.
- **Early exit (upstream issue #26855).** `run --format json` can exit *before*
  emitting the final `step_finish`, dropping the terminal cost. The handler must
  **sum `cost` across all `step_finish` events seen**, not read only the last one,
  and treat a run that produced *no* priced event as a miss rather than a $0 invoice.

### 3. Robust binary resolution — ✅ PASS (reuse the existing pattern)

Do **not** add another bare `command -v opencode || die` — that shape caused the
2026-07-28 ps23 outage (`claude` off the `systemd --user` PATH; every job FATAL'd,
open job `improve-gardener-claude-bin-resolution`). The shared spine already has the
right tool: `worker_agent_bin`/`claude_bin`-style resolution that retries, probes
known install locations, and `die_environmental`s to `EX_TEMPFAIL` (a *transient*,
requeue) rather than escalating. The opencode handler must route its binary through
that same resolver, and coordinate with the open bin-resolution job so both handlers
share one hardened resolver rather than each growing its own.

### 4. Headless + prompt-from-file + honest exit codes — ⚠️ MOSTLY PASS, one gap to verify

`opencode run [message]` is headless (no TUI). The prompt is supplied as a command
argument — identical to `claude -p "$prompt"` and `codex exec … "$prompt"`; a
file-sourced prompt is passed as one large arg, and `--file`/`-f` attaches files to
the message. `--format json` gives the machine-readable stream. All good.

**The gap:** opencode's **exit-code semantics are undocumented**. `gardener.sh`
classifies handler failure into transient-vs-defect and the reaper's
outage-vs-productive accounting depends on that signal being honest (a provider
quota refusal must read *environmental*, not a job defect). This **must be verified
empirically** before adoption — kill a run mid-stream, refuse the API key, exhaust a
quota, and confirm the exit codes (and stderr classifiable text) let the spine
distinguish the cases. Until verified, treat exit-code honesty as an open risk, not
an assumption.

### 5. Tool-permission and sandbox model — ✅ PASS with configuration

opencode has a config-based per-tool gate: each of `bash`, `edit`, `read`,
`webfetch`, `websearch`, `external_directory`, `doom_loop` resolves to
`allow`/`ask`/`deny`. `--auto` approves everything not explicitly denied — the
posture parity of `--dangerously-skip-permissions`/`--dangerously-bypass-approvals`.
There is **no real filesystem sandbox** (same as claude and codex) — **the garden
container is the sandbox**, unchanged. It *can* be constrained to the per-job
worktree: run with `cwd = $worktree` and set `external_directory: deny` so tools
cannot reach outside the workspace.

Prompt-injection discipline is a **prompt-construction** property, not a harness
one: the job body is DATA framed by `worker_job_prompt` (`handlers/worker-common.sh`),
which the opencode handler reuses verbatim, so injection hygiene does not regress.
The `.env`-read-denied-by-default posture is a small bonus.

### 6. Transcript capture — ⚠️ GAP (new spool source required)

Deletion is disabled fleet-wide and finished transcripts spool for archival
([transcripts.md](../context/operations/transcripts.md)). The existing
`transcript_spool` captures Claude's `~/.claude/projects/<encoded-cwd>/<sid>.jsonl`.
opencode stores sessions **elsewhere and in a different shape**: under
`~/.local/share/opencode/storage/` as a multi-file JSON tree
(`session/`, `message/`, `part/`), overridable via `OPENCODE_DATA_DIR`. The existing
capture path **does not see these**, and the single-JSONL archive/replay assumption
does not fit a directory tree.

**Fix (mirrors mystic's `KIMI_CODE_HOME`):** give each job a **private
`OPENCODE_DATA_DIR`** under its state namespace (`$GARDEN_STATE/<ns>/opencode/<base>`).
That simultaneously (a) isolates sessions per job so a requeue resumes only its own
state, (b) **bounds** opencode's known-unbounded storage growth (upstream issue
#22110) by letting completion `rm -rf` the per-job dir, and (c) makes capture a
plain directory archive of that dir on genuine completion, added as a new
`transcript_spool`-style source. Straightforward, but it *is* net-new plumbing —
not free.

### 7. Model routing — ✅ PASS (clean mapping)

opencode's `provider/model` namespace is nearly isomorphic to garden's
`(provider, model)` pair. `resolve_model_tier <provider> <tier>`
([model-selection](../skills/model-selection/SKILL.md)) resolves a garden tier to a
concrete id; the handler then emits `-m <opencode-provider>/<id>`. The one required
piece is a small **garden-provider → opencode-provider-id** map (e.g. garden
`anthropic` → opencode `anthropic`; garden `moonshot` → opencode `moonshotai`;
garden `openai` → opencode `openai`; a new garden `google` → opencode `google`),
which is table data, not code. Concrete ids pass through iff the routing table
classifies them — the existing invariant holds unchanged.

### 8. Eligibility gating — ✅ PASS *only under option C*

`job_eligible_for_kind` derives the provider from the `model:` pin and admits only
the matching kind; moonshot and fireworks are explicit-model-only lanes so an
unpinned board job can never wander onto a paid provider. **Option C preserves this
exactly:** each `opencode-<provider>` kind is bound to one provider, so a pin still
determines the provider unambiguously, and each paid opencode kind is declared an
explicit-model-only lane (the `fireworker`/`mystic` branch pattern). **Option A
would violate it** — a single many-provider opencode kind cannot be pinned to one
provider, so unpinned work could reach paid Gemini/Anthropic. This constraint is, on
its own, decisive for choosing C over A.

## Scorecard

| # | Constraint | Verdict |
| --- | --- | --- |
| 1 | Deterministic session id + resume | ⚠️ Partial — sidecar tier (parity with codex); no client-chosen id |
| 2 | Cost ledger | ✅ Pass — USD + tokens per step, *stronger* than codex; guard unpriced models + issue #26855 |
| 3 | Robust binary resolution | ✅ Pass — reuse the hardened resolver, not `command -v` |
| 4 | Headless + honest exit codes | ⚠️ Mostly — headless fine; **exit-code semantics undocumented, must verify** |
| 5 | Tool-permission / sandbox | ✅ Pass — `--auto` + `external_directory: deny` + cwd; container is the sandbox |
| 6 | Transcript capture | ⚠️ Gap — new per-job `OPENCODE_DATA_DIR` spool source required |
| 7 | Model routing | ✅ Pass — `provider/model` maps cleanly; small provider-id table |
| 8 | Eligibility gating | ✅ Pass **under option C**; ❌ fails under option A |

No constraint is disqualifying. Two (1, 6) require the same per-job-state pattern
mystic/cleric already use; one (4) is a genuine unknown that a probe resolves.

## Recommendation

**Adopt-narrowly, and prove it with a probe before arming anything.**

Adopt opencode **only where it adds what the incumbents cannot**:

- a provider not reachable through codex's OpenAI-compatible path (primarily **Google
  Gemini native**), or
- a **harness A/B** against a provider that *already* has a native kind (e.g.
  `opencode-anthropic` vs `gardener` on the same Opus model), to learn whether the
  *harness itself* moves accept-rate or cost.

Structure it as **option C** — one kind per provider, one shared `handlers/opencode.sh`,
each paid kind an explicit-model-only lane. Do **not** adopt it as a single
many-provider kind (breaks eligibility, constraint 8) and do **not** promote harness
to a new arm dimension (redundant with `kind`, highest blast radius, sole-writer
reducer migration for zero added expressiveness).

Do **not** adopt it as a default for any unpinned or high-stakes (designer/builder)
routing. Like `mystic`, it ships disabled and stays disabled until a maintainer
directs a bounded canary. This investigation arms nothing and spends nothing.

## The smallest probe (kimi-k3 precedent)

Follow the [kimi-k3](../context/operations/kimi-k3.md) shape — one pinned worker,
one harmless reversible canary, verify the arm scoping — as a
[gap-revealing-build](../skills/gap-revealing-build/SKILL.md) **probe** (a DRAFT
report of what held and what didn't), not a full harness build:

1. **One provider, one worker.** Add a single `opencode-anthropic` kind (registry
   row + `count_key` + eligibility branch), reusing the mystic/cleric per-job-state
   pattern (private `OPENCODE_DATA_DIR`, sidecar session id). Declare it
   explicit-model-only. Enable **exactly one** worker on this host. Choose anthropic
   deliberately: it *already* has a native kind (`gardener`), so the probe directly
   proves the harness-A/B claim.
2. **One reversible canary job**, frontmatter pinned to `model:` an opencode-routed
   anthropic model at a low tier, doing a harmless reversible tool action (create and
   remove a throwaway file), exactly like the kimi canary.
3. **Verify four things end-to-end:**
   - the `--format json` stream yields a parseable `sessionID`, and a *forced
     requeue* (kill mid-run) resumes via the sidecar rather than restarting;
   - `usage/<base>.jsonl` gets a **real, non-censored** USD cost from summed
     `step_finish` events (not `agentic_dollars: censored`);
   - the reputation event lands on arm
     `opencode-anthropic/anthropic/<model>/<tht>/<work_class>@<target>` — **distinct
     from** the `gardener/anthropic/<same-model>/…` arm, proving the harness A/B is
     now a first-class, independently-scored comparison;
   - a killed run and a refused key classify as **transient/environmental** (requeue),
     not a job defect (constraint 4 — the one real unknown).
4. **Report the gap.** If exit-code honesty (4) or unpriced-cost (2) or the transcript
   spool (6) does not hold, the probe's finding is the deliverable; do not widen to a
   second provider until they do.

## Migration sketch (only if the probe holds)

1. `handlers/opencode.sh` — a sibling of `cleric-codex.sh`, provider-parameterized,
   reusing `worker-common.sh` (worktree lifecycle, prompt, completion contract) and
   the hardened binary resolver. Parse `sessionID` from `step_start`; persist a
   per-base sidecar; run with `--auto --format json`, `cwd = $worktree`,
   `external_directory: deny`, private `OPENCODE_DATA_DIR`; sum `step_finish` cost
   into `usage/<base>.jsonl`.
2. `common.sh` — one `worker_kind_field` row per opencode provider
   (`opencode-anthropic`, later `opencode-google`, …), each sharing the handler;
   add each to the kinds list; a garden-provider → opencode-provider-id map.
3. `claim-job.sh` — extend `job_eligible_for_kind` so each `opencode-<provider>` kind
   admits only pins for its provider, and each paid one is explicit-model-only.
4. A new `transcript_spool` source archiving the per-job `OPENCODE_DATA_DIR` on
   completion; wire it into the capture timer.
5. `garden-opencode-<provider>@` systemd unit(s) from the worker template; a
   `hosts/<host>` count line (default 0 — inert until declared, the `fireworker`
   precedent); scaler wiring falls out of the kinds list.
6. Docs: a `context/operations/opencode.md` activation page (kimi-k3 shape), a
   `model-selection` note that opencode-`<provider>` is a distinct kind/harness on an
   existing provider, and a rate-card/arm note that its cost is provider-computed USD.

## Relationship to the AI SDK design

[ai-sdk-garden-integration.md](ai-sdk-garden-integration.md) already reasoned about
adding a provider-broad runtime at the worker-harness boundary and chose "optional,
non-production, sibling handler, do not overload `model:`, harness ≠ model." This
design is the **concrete, CLI-based instance** of that same boundary: opencode is a
shipping single-binary harness that needs no TypeScript/Zod dependency closure, no
hardened-JS review, and no OAuth-parity question, because it is invoked exactly like
`claude`/`codex` — a subprocess behind a handler. Where the AI SDK note left "which
runtime" open, opencode answers it for the *evaluation* use case with the lowest
integration surface. The two are complementary, not competing: AI SDK Core remains
the candidate for schema-validated structured output; opencode is the candidate for
harness-diversity evaluation of ordinary mutation jobs.

## Sources (external documentation, read as DATA)

- [opencode CLI reference](https://opencode.ai/docs/cli/) — `run`, `serve`,
  `--session`/`-s`, `--continue`/`-c`, `--model`/`-m provider/model`, `--format json`.
- [opencode server / session API](https://opencode.ai/docs/server/) —
  server-assigned session ids; no client-chosen id.
- [opencode permissions](https://opencode.ai/docs/permissions/) — per-tool
  allow/ask/deny, `--auto`, `external_directory`, no FS sandbox.
- `run --format json` event shape (`step_start`/`step_finish` with `sessionID`,
  `cost` USD, token classes) and the early-exit hazard (upstream issue #26855).
- On-disk storage `~/.local/share/opencode/storage/` (`OPENCODE_DATA_DIR`
  override) and unbounded-growth issue #22110.
</content>
</invoke>
