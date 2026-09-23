---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-10T20:54:09Z
---
# scholar-ingest-unum — jcorbin/unum (tangled.org) ingested

Maintainer-directed one-off ingest of jcorbin's `unum` monorepo, hosted on
**tangled.org** (an atproto git forge, not GitHub). Cloned via
`git clone https://tangled.org/jcorbin.tngl.sh/unum` (redirects to a knot1.tangled.sh
DID host); provenance pinned by ordinary per-file `git log` commit shas.
Read for a **token-spend-tracking** through-line. Repo HEAD `1834aba` (2026-07-09).

## Key token-spend finding
unum has a **fully-built per-run attributed cost ledger** — the piece the garden's
own fleet-spend machinery lacks. `evoke/costs.jsonl`: one JSON line per agent run,
captured from the Claude CLI terminal `result` event (raw 4-class token counts +
CLI-computed `total_cost_usd` + wall-clock + host rusage), tagged with
session/trigger/channel/task/model, written O_APPEND best-effort to a gitignored
CoordRoot file. Read-time aggregation only (`invoke cost --by task|day|model`,
sorted by dollars desc); three surfaces — the on-demand table, an idempotent
per-task `## Cost` stanza baked into the `TADA/` archive, and a live operator chip.
Contrast with the garden's `scripts/jobs/usage-meter.sh`, which is a fleet-wide
weekly QUOTA GATE with no per-job/role/model attribution and no persisted record —
so unum's ledger is the exact complementary layer. Captured as concept
[[cost-ledger]]. Secondary spend patterns: per-persona **model tiers** ([[model-routing]])
and the **vigil-charge** initiative budget ([[vigil-charge]] — health-gated proactive
spend: accumulate "charge" only over verified-quiet rounds, spend at threshold;
decrement-not-reset on housekeeping so a busy fleet doesn't starve its own initiative).

## Library paths written (new source-slug `unum`, source_kind repo)
- sources/unum.md (source index; sibling-implementation)
- sections/unum--overview.md (agent-fleet-orchestration)
- sections/unum--token-cost-ledger.md (coding-agent-economics)
- sections/unum--cost-attribution-and-aggregation.md (coding-agent-economics)
- sections/unum--per-persona-model-tiers.md (coding-agent-economics)
- sections/unum--vigil-charge-initiative-budget.md (agent-fleet-orchestration)
- concepts/cost-ledger.md (new), concepts/vigil-charge.md (new)
- Rows added: topics/coding-agent-economics.md (+3), topics/agent-fleet-orchestration.md (+2),
  concepts/coding-agent-spend.md (+2), concepts/model-routing.md (+1)
- Indexes: sources/README.md (sibling-implementations row), concepts/README.md (+2),
  keywords.md (+26 lines)

## Filed under EXISTING homes (no new topics — deliberate reuse)
Topics `coding-agent-economics` and `agent-fleet-orchestration` already existed
(the Allen-Pike spend essay + OpenAI Symphony ingests), and framed exactly the
"read against the garden as an independent convergent design" lens unum fits. No
taxonomy proliferation; two new concept pages only.

## Integrity gate (step 8) — PASSED
- library-link-check.sh --changed: OK — the `unum` cluster's 5 section targets all
  resolve to committed files; no dangling rows.
- regenerate-topics-counts.sh --check: STALE counts (informational; no missing topic
  page — the blocking condition — since both topics pre-existed). Made current by the
  step-9 --land below.
- Landed all 15 content files via land-journal-edit.sh; then regenerated
  sections/README.md (regenerate-sections-index.sh) and topics/README.md counts
  (regenerate-topics-counts.sh) as the final landing step — both landed current.

## Self-improvement routed to liaison
Message `role/liaison` `20260710T205306Z-7093b4`: propose a garden per-job attributed
cost ledger (keyed by job base, written on doin->tada, aggregatable by job/role/model/day,
optionally a `## Cost` block on the tada report), to complement — not replace — the
fleet quota gate. A job-lifecycle/control-surface change, so left for the maintainer.

## Follow-on
Posted `scholar-ingest-unum-remainder` for the rest: `LORE/` (~70 lessons, consolidate
hard), `devoker/DESIGN.md` + refinery/staging/vigil subsystems, `notify_server`, the
make/user systemd resource quota, `STANDARDS/` + persona/soul config. `ref/kris_garden/`
(vendored garden snapshot) excluded.

Self-improvement: The three per-source-kind schema variants in conventions.md
(repo/paper/web/comment-fragment) had no slot for a **non-GitHub git forge** (tangled.org).
I handled it as `source_kind: repo` with a `source_url` to the tangled page and a
frontmatter note that tangled exposes no stable per-file blob-permalink, so footers
cite repo-URL+path+short-sha and the commit sha is the anchor. If more tangled/atproto
or self-hosted-forge sources arrive, conventions.md could gain a one-paragraph note
blessing this "repo source, no blob-permalink, sha-anchored, link the repo root" shape
so the next scholar doesn't re-derive it — a candidate for a future conventions touch by liaison.
