# Spark gardeners: a Muse-Spark-harnessed fleet-worker variant

| Created | 2026-07-10 |
| Author  | designer (job `design-spark-gardeners`, orchestration `orch-spark-gardeners`) |
| Status  | Proposed (maintainer-commissioned 2026-07-10; blocked on the access preconditions in § Preconditions before any build) |

A **Spark gardener** is a gardener fleet worker whose model harness is Meta's
**Muse Spark 1.1** driven through Simon Willison's **LLM CLI** (the
`llm-meta-ai` plugin), rather than `claude -p`. This design defines where the
harness seam sits, which work such a worker can honestly be assigned, how it
integrates with the board, the systemd fleet, the model-selection policy, and
token-spend accounting, and how a producer routes a job to it. It builds on the
scholar's research (job `scholar-muse-spark-harness`, the first child of this
orchestration) and does not re-litigate the model facts; the load-bearing
citations are the journal library pages
`journal/library/concepts/muse-spark-garden-worker-fit.md`,
`journal/library/concepts/muse-spark.md`, and
`journal/library/concepts/llm-meta-ai.md`.

The scholar's one-line verdict, which this design adopts as its premise: a
Spark-backed worker is **technically reachable but not a drop-in**. It is a new
worker harness, not a model swap, and it arrives with a weaker safety and
availability posture than the fleet's current substrate. The motive for
building one is **harness diversity and independence** (a second, non-Anthropic
backend the garden can exercise and compare), not capability: on the newer
coding and agentic benchmarks Muse Spark 1.1 trails the Claude Opus tier the
fleet already runs.

## The premise, restated as constraints

Five findings from the scholar's ingest shape everything below:

1. **The agentic loop exists but the substrate does not.** LLM's tool calling
   (`-T`, with `--td` for debugging) runs registered Python tools in an
   automatic request/execute loop, and Muse Spark supports tool calling,
   parallel tool calls, and structured output (`--schema`). But LLM supplies
   none of Claude Code's built-ins: no file-edit tool, no bash tool, no
   subagents, no permission gate, no hooks. Every tool a Spark gardener may use
   has to be written and registered by us, which is a liability and, handled
   deliberately, also the safety mechanism (§ Safety).
2. **Availability is preview-grade.** The Meta Model API is a public preview,
   per-team gated (a persistent 429 can mean "not enabled for your team"),
   with no published pricing. The fleet's Claude side runs on a subscription;
   Spark would be a metered key with an output-token rate limit charged before
   a request runs.
3. **Capability is not an upgrade.** Muse Spark 1.1 trails Claude 4.8 Opus on
   Terminal-Bench 2.1 and SWE-Bench Pro. Nothing currently pinned to Opus or
   Fable should move to Spark on quality grounds.
4. **Safety leans on the deployer.** Meta state plainly that the standalone API
   ships with no system-level defenses and recommend strict tool allowlists and
   workspace isolation. Prompt-injection robustness improved over 1.0 but
   trails the state of the art on file injection. This intersects the garden's
   Monitoring safety constraint directly (§ Safety).
5. **A behavioral flag for long loops.** The evaluation report's
   self-conversation attractor includes an "anti-usefulness" strand (framing
   helpfulness training as a constraint to reject) in roughly 72% of runs. Far
   out of distribution, not default behavior, but the garden runs long-lived
   unattended agents, so Spark engagements should stay bounded and supervised
   (§ Safety).

## The harness seam: options considered

Today a claimed job runs through one seam:
[`scripts/jobs/gardener.sh`](../scripts/jobs/gardener.sh) invokes
`$GARDEN_JOB_HANDLER <base> <job-file> <report-out>`, defaulting to
[`scripts/jobs/handlers/gardener-claude.sh`](../scripts/jobs/handlers/gardener-claude.sh),
which builds the per-job worktree, resolves the model from the job's `model:` /
`role:` frontmatter, runs `claude -p`, and gates completion on the deterministic
marker. Four ways to admit a second harness:

### Option A (chosen): a per-job `harness:` field, dispatched in `gardener.sh`, to a sibling handler

Jobs gain an optional `harness:` frontmatter field, orthogonal to `model:` and
`role:`. At the existing call site in `gardener.sh` (after the claim, where the
job file is already in hand), a small resolver maps `harness: spark` to
`handlers/gardener-spark.sh` and absence (or `harness: claude`) to
`handlers/gardener-claude.sh`, unless `GARDEN_JOB_HANDLER` is explicitly set
(the test override keeps absolute precedence, unchanged). One worker pool, one
claim path, one reaper, one board.

- Pro: the claim stays harness-agnostic (the git-push CAS never inspects the
  job), so no claim filter, no second pool, no scaler change, no new unit
  template. A Spark job rides every existing lifecycle guarantee: requeue,
  doom counters, deadline overrun, drain, deploy gates.
- Pro: the seam is exactly where model selection already happens, so the
  precedent (frontmatter field, resolved at run time, typo-safe fallback) is
  established and tested.
- Con: any gardener on any host can claim a Spark job, including a host with no
  `llm` installed or no Meta key. Answered with a **precondition gate** in the
  Spark handler, the same shape as the boatman's ferry precondition: detect the
  missing capability, do not attempt the work, and report the gap (§ Fleet
  integration).

### Option B (rejected for v1): a dedicated Spark worker pool with a claim filter

A `garden-spark-gardener@.service` template whose loop claims only
`harness: spark` jobs, while ordinary gardeners skip them.

- Pro: hosts opt in by enabling instances, so an unprovisioned host never
  touches a Spark job; pool sizing and memory limits can be tuned separately.
- Con: `claim-job.sh` currently claims unconditionally; a two-sided eligibility
  filter (Spark workers claim only Spark jobs, Claude workers never do) is new
  claim-path complexity in the garden's most race-sensitive primitive, plus a
  scaler, a unit template, and leader/follower wiring, all for a variant whose
  v1 job volume is a trickle. If Spark routing ever becomes high-volume, this
  is the natural evolution, and Option A's `harness:` field is forward
  compatible with it (the filter would key on the same field).

### Option C (rejected): fold Spark into the model map as a tier

Add `spark` to `resolve_model_tier` so `model: spark` selects it.

- Con: it conflates two axes. `model:` selects a Claude id passed to `--model`
  inside one harness; Spark is a different execution substrate with different
  tools, session semantics, completion contract, and accounting. A tier named
  `spark` would force `gardener-claude.sh` to branch into an entirely different
  program halfway through, and would break the invariant that
  `resolve_model_tier` output is always a valid `claude -p --model` argument.

### Option D (rejected for v1): a bespoke OpenAI-compatible agent harness

The Meta Model API is OpenAI-compatible, so the garden could write its own
agent loop against the wire format, or adopt another OpenAI-compatible agent
CLI.

- Con: strictly more surface to build and maintain than reusing LLM's existing
  loop, credentials handling, logging database, and schema support; and the
  maintainer's directive named Willison's tool as the harness. If LLM's loop
  proves too thin in practice, this option can be revisited with evidence in
  hand. The local-serving sibling (`journal/library/concepts/athanor.md`)
  similarly stays a separate track: it changes where a model runs, not which
  harness drives it.

## The Spark handler

`scripts/jobs/handlers/gardener-spark.sh`, invoked identically to the Claude
handler (`<base> <job-file> <report-out>`), preserving the contracts
`gardener.sh` depends on:

- **Worktree discipline unchanged.** The same per-base worktree
  (`$GARDEN_SCRATCH/gardener-wt-<base>`), created off `origin/main2`, reused on
  resume, torn down only on genuine completion. This is also Meta's
  recommended workspace isolation, which the garden gets for free.
- **Precondition gate first.** Before any model call: `llm` on PATH, the
  `llm-meta-ai` plugin present, a `meta-ai` key configured (or `META_AI_TOKEN`
  set). On failure the handler writes a gap report (what is missing, how to arm
  it) to `<report-out>`, messages the maintainer once through the existing
  inbox path, and exits without the completion sentinel so the job requeues
  visibly rather than being silently lost. A persistent 429 from the API is
  treated the same way: it means the team is not enabled, which is an arming
  gap, not a transient.
- **Invocation.** `llm -m meta-ai/muse-spark-1.1` with the job prompt (the same
  role-brief + job-spec + messaging-discipline framing the Claude handler
  builds), a registered tool set (below), `-o max_tokens` set explicitly
  (requests are charged against the output-token budget before they run, and
  reasoning tokens count against it), and a bounded loop.
- **Completion contract: structured output, not the prose marker.** The Claude
  handler gates on a textual completion marker as the model's final act. Spark
  supports schemas natively, and instruction-following fidelity on a weaker
  model is exactly where a prose protocol frays. The Spark handler instead
  requests a final structured object (`--schema`, shape
  `{report: string, complete: boolean}`), writes `report` to `<report-out>`,
  and touches `GARDEN_COMPLETION_SENTINEL` only when `complete` is true and the
  loop exited cleanly. Same deterministic gate, sturdier wire format. A run
  that dies or returns `complete: false` requeues exactly as today.
- **Session continuity, best effort.** LLM logs every exchange to its SQLite
  database and supports continuing a conversation by id (`--cid`). The handler
  derives a deterministic conversation id from the job base (mirroring the
  Claude handler's uuid5 session id) so a requeued job can resume its
  conversation on the same host. Whether `--cid` resume composes cleanly with
  tool loops and schemas is an implementation question to verify in the build
  (§ Open questions); the fallback (fresh conversation against the surviving
  worktree) is already the cross-host behavior of the Claude handler.
- **Tool allowlist, fixed and minimal (v1).** Registered Python tools, no
  general bash:
  - `read_file(path)`: confined to the job worktree plus the garden root,
    read-only.
  - `list_dir(path)`: same confinement.
  - `inbox_read()` / `message_user(text)`: thin wrappers over the existing
    scripts, so a Spark gardener keeps the message-bus discipline.
  - Phase 1 adds `write_file(path, content)` (worktree-confined) and
    `commit_and_push(message)` (a scripted, pathspec-explicit commit plus the
    standard CAS push loop, no free-form git). Phase 0 ships without either
    (§ Phasing).

  There is deliberately no `run_command`. A general shell tool would reopen the
  entire attack surface that the allowlist exists to close, on the model with
  the weaker injection posture.

## What a Spark gardener can and cannot be assigned

The honest capability statement, from the scholar's assessment plus the harness
shape above. Muse Spark has real tool use, so the line is not "text-only"; the
line is drawn by the thin harness, the injection posture, and the trailing
coding capability.

**Can (phase 0, report-shaped work over trusted text):**

- Second-opinion review memos on bot-authored diffs or design documents (read
  the worktree, deliver the opinion as the tada report or an inbox message).
- Drafting and summarizing over garden-internal material: journal digests,
  design-document critiques, copyedit passes delivered as suggestions.
- Structured extraction and classification where `--schema` shines (inventory
  sweeps, consistency audits reported as findings, never applied as edits).

**Can (phase 1, adds scoped writes):**

- Small, self-contained authoring jobs on `main2` whose output is one or two
  files plus a scripted commit and push: a draft skill page, a context page, a
  regenerable index. The panel and the maintainer remain the quality gate.

**Cannot (and this design forbids assigning):**

- **Anything the gardening state machine supervises**: build, fix, gauntlet,
  shepherd, weave, retcon, merge. `garden-pr.sh` and its segments consult
  `claude -p` internally and assume Claude Code's substrate; a Spark supervisor
  would be a hybrid with no owner. Builds also demand the coding capability
  where Spark measurably trails Opus.
- **Any job whose input carries watcher-fed or otherwise untrusted external
  text**: triager comment jobs, mention follow-ups, issue-inbox work, and
  scholar-style ingestion of arbitrary web sources. See § Safety.
- **The ferry**, or any job touching the maintainer's identity or credentials.
  The ferry's authorization model is orthogonal to the harness, but the weaker
  model backstop makes it categorically out of scope.
- **Long unattended autonomous loops** beyond the bounded per-job engagement
  (the attractor-state flag; each Spark engagement is one bounded handler run
  under the existing handler timeout).

## Safety

The garden's Monitoring safety constraint (CLAUDE.md) already governs which
text may enter a model's context; it is model-independent and unchanged. Spark
tightens it in one direction: because Meta's own evaluation says the model's
injection resistance trails the state of the art on some scenarios and that
deployers must supply system-level defenses, **the sender-gated exceptions that
were judged acceptable for the Claude fleet are not extended to Spark in v1.**
Concretely:

- Producers never stamp `harness: spark` on watcher-originated job classes.
  The enforcement point is the producer side (the posting scripts and the
  foreman never emit it), plus a belt in the Spark handler: refuse a job whose
  body carries watcher-provenance markers, report the mismatch, and leave the
  job for the Claude fleet by clearing its own claim path (requeue without the
  sentinel and a maintainer message naming the misroute).
- The tool allowlist above is the "strict tool allowlist" Meta recommend; the
  per-job worktree and the container are the workspace isolation.
- Bounded engagements answer the attractor-state flag: no Spark daemon, no
  Spark watcher, no Spark `claude -p` analog on a timer. A Spark gardener
  exists only for the duration of one claimed job under the standard handler
  timeout.
- The Meta API key is a new secret on bot hosts, provisioned deliberately by
  the maintainer per host (§ Preconditions). Hosts without it simply cannot run
  Spark jobs, and the precondition gate makes that visible instead of silent.

## Fleet integration

- **Claiming.** Unchanged. The board, the CAS push, plan gating, orchestration,
  and the reaper treat a Spark job like any job. `harness:` is body metadata,
  invisible to the claim.
- **Units and pools.** No new unit template in v1 (Option A). The existing
  `garden-gardener@` instances run whichever handler the claimed job resolves
  to. Spark handler processes are light (a Python CLI making API calls), well
  inside the existing per-worker memory budget. Pool sizing is therefore
  untouched; the Spark job volume in v1 is maintainer-routed and small.
- **Leader and follower hosts.** Spark gardeners inherit the gardener rule:
  they run wherever gardeners run, on every host, gated only by per-host
  arming. No new singleton exists (there is no Spark watcher or Spark
  scheduler), so the leader/follower machinery is untouched.
- **Requeue and reaping.** The sentinel protocol, doom counters, and deadline
  overrun all key on handler behavior, not handler identity, and the Spark
  handler honors the same sentinel contract, so the whole failure lifecycle
  carries over without modification.

## Model selection and token spend

- **`harness:` is orthogonal to `model:`.** `resolve_model_tier` and
  `role_default_model` in `scripts/jobs/common.sh` stay Claude-only, and the
  [model-selection](../skills/model-selection/SKILL.md) skill gains a short
  harness section stating exactly that: `harness:` selects the execution
  substrate; `model:` selects a model within the Claude harness; a job naming
  both `harness: spark` and a Claude `model:` is a contradiction the handler
  resolves in favor of the harness (log, ignore the `model:` field). Within the
  Spark handler a private map binds the harness to its concrete model id
  (today `meta-ai/muse-spark-1.1`), the single edit point for a Spark version
  bump, mirroring what `resolve_model_tier` does for Claude ids.
- **No role defaults to Spark.** The standing role policy (designer on Opus,
  builder on Opus, all else fleet default) is untouched. Spark is reached only
  by explicit per-job routing (§ Routing control). If the maintainer ever pins
  a role to Spark, that is one new row in the policy table and one case in a
  future `role_default_harness`, but nothing in this design needs it.
- **Token accounting.** The tada-token-accounting design
  ([tada-token-accounting](tada-token-accounting.md)) meters Claude spend from
  session JSONL under `~/.claude/projects/`. Spark spend lives elsewhere: LLM
  records per-response usage, including reasoning tokens
  (`completion_tokens_details.reasoning_tokens`), in its SQLite log, queryable
  by conversation id (`llm logs --cid <id> --json`). Because the handler's
  conversation id is deterministic from the job base, the same
  ledger-row-keyed-by-base shape carries over: the Spark handler (or the
  `gardener.sh` capture hook) queries the log for the engagement's conversation
  and writes a ledger row tagged `harness: spark`. Rows gain a `harness` column
  so the meter can aggregate per substrate. **Cost remains unmeterable in
  dollars**: Meta publish no pricing, so the ledger records tokens and marks
  cost unknown, which is itself a datum for the garden's coding-agent-economics
  tracking. The pre-charged output-token rate limit also means `max_tokens`
  discipline in the handler is a spend control, not just a correctness knob.

## Routing control

Explicit, opt-in, and top-down in v1:

- **The job field.** `harness: spark` in the job's leading frontmatter is the
  single routing mechanism, set by `post-job.sh --harness spark` and
  `post-plan.sh --harness spark` (new flag, same plumbing as `--role`). No
  dedicated `spark-*` basename convention: the identity of a job is its work,
  not its substrate, and a requeued or re-posted job should be able to change
  harness without changing identity.
- **Who sets it.** The maintainer (through the liaison: "draft X on spark", or
  any phrasing the liaison maps to the flag) and, later, producers explicitly
  taught to. The **foreman does not auto-route work to Spark in v1**: routing
  requires the capability judgment in the can/cannot table above, and a wrong
  route burns a requeue cycle at best. Automatic routing (a foreman that sends
  eligible report-shaped idle work to Spark) is a phase 2+ question, gated on
  observed v1 reliability.
- **Negative control.** Because no role defaults to Spark and no watcher emits
  the field, the absence of `harness:` is always safe: the fleet without any
  Spark arming behaves exactly as today.

## Preconditions (before any build is worth running)

1. **API access.** A Meta AI API key for the garden's team, with
   `meta-ai/muse-spark-1.1` actually enabled (the 429-means-not-enabled preview
   gate). Only the maintainer can obtain this; the garden cannot self-serve.
2. **Key provisioning shape.** Decide where the key lives on a bot host
   (`llm keys set meta-ai` writes under the bot home; `META_AI_TOKEN` in a unit
   environment is the alternative) and record the arming act in a journal
   message, mirroring how other per-host armings are recorded.
3. **Spend ceiling.** With no published pricing, the maintainer should set an
   explicit token budget expectation for the pilot phase, since the ledger can
   meter tokens but cannot price them.

## Phasing (this design does not build)

- **Build 1 (phase 0):** the seam and the read-only pilot. `harness:`
  dispatch in `gardener.sh`; `gardener-spark.sh` with the precondition gate,
  read-only tool set, schema completion contract, and ledger row; `--harness`
  on the two posting scripts; the model-selection skill's harness section; a
  handler test with a fake `llm` on PATH (mirroring
  `gardener-worktree-test.sh`). Pilot job class: second-opinion review memos on
  garden-internal documents.
- **Build 2 (phase 1):** scoped writes. `write_file` and `commit_and_push`
  tools, enabling small self-contained `main2` authoring jobs; extend the
  handler test to the write path.
- **Phase 2 (not committed):** revisit after pilot evidence and a Meta
  GA/pricing announcement: possible dedicated pool with claim filtering
  (Option B), foreman routing of eligible idle work, and whether a Spark juror
  seat adds worthwhile diversity to panel review.

## Open questions (named, not resolved)

1. **Does `--cid` resume compose with tool loops and schemas?** The requeue
   story assumes it does; the build must verify, and fall back to
   fresh-conversation resume if not.
2. **Schema-plus-tools interaction.** Whether one invocation can both run the
   tool loop and end with a schema-shaped final object, or the handler needs a
   two-step (loop, then a schema-forced summarization turn). Willison's
   documentation suggests both features exist; their composition is untested
   here.
3. **Completion fidelity in practice.** The structured contract should beat
   the prose marker, but a model that habitually returns `complete: true`
   prematurely (or never) would burn requeue cycles; the pilot measures this
   before phase 1 grants write tools.
4. **Ledger schema change.** Adding a `harness` column to the usage ledger
   touches the tada-token-accounting builder's work; sequence the two builds so
   the column lands once, not twice.
5. **Identity surface.** V1 gives Spark no `gh` tool and no push capability
   until phase 1's scripted `commit_and_push`, which pins the bot identity the
   same way the worktree git config does. Any wider GitHub surface for Spark
   would need its own review against the fleet-gh-identity design.
6. **Whether the motive holds.** Harness diversity is worth a bounded pilot;
   it is not yet worth a second pool, a second scaler, and a second watcher
   stack. If the pilot's reports are not visibly useful to the maintainer,
   the right phase 2 is to stand it down, and the design's negative control
   (absence of `harness:` changes nothing) makes that free.
