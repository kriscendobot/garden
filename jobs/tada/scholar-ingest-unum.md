All work landed and verified by the lander's push-guard. The ingest is complete.

## Completion report — `scholar-ingest-unum`

**What I did.** Ingested jcorbin's `unum` monorepo from **tangled.org** (an atproto git forge, not GitHub) into `journal/library/`, read for a token-spend-tracking through-line. `unum` is cloneable (`git clone https://tangled.org/jcorbin.tngl.sh/unum`), so I pinned provenance by ordinary per-file `git log` shas (repo HEAD `1834aba`, 2026-07-09) and excluded the vendored `ref/kris_garden/` garden snapshot.

**Key token-spend finding.** `unum` has a **fully-built per-run attributed cost ledger** — exactly the layer the garden's own spend machinery lacks. `evoke/costs.jsonl`: one JSON line per agent run, captured from the Claude CLI terminal `result` event (four raw token classes + CLI-computed `total_cost_usd` + wall-clock + host rusage), tagged with session/trigger/channel/task/model, `O_APPEND` best-effort under CoordRoot. Read-time aggregation only (`invoke cost --by task|day|model`, dollars-descending); three surfaces — an on-demand table, an idempotent per-task `## Cost` stanza baked into the `TADA/` archive, and a live operator chip. The garden's `usage-meter.sh` is by contrast a fleet-wide weekly **quota gate** with no per-job/role/model attribution — so `unum`'s ledger is the exact complementary piece. Secondary spend patterns: per-persona **model tiers** (→ `[[model-routing]]`) and the **vigil-charge** initiative budget (→ `[[vigil-charge]]`: health-gated proactive spend, decrement-not-reset so a busy fleet doesn't starve its own initiative).

**Library paths written** (new source-slug `unum`, `source_kind: repo`):
- `sources/unum.md`; sections `unum--overview`, `unum--token-cost-ledger`, `unum--cost-attribution-and-aggregation`, `unum--per-persona-model-tiers`, `unum--vigil-charge-initiative-budget`.
- New concepts `cost-ledger`, `vigil-charge`. Rows added to existing `coding-agent-economics` (+3), `agent-fleet-orchestration` (+2), `coding-agent-spend` (+2), `model-routing` (+1). Indexes: `sources/README.md`, `concepts/README.md` (+2), `keywords.md` (+26). Filed under **existing** topics (no taxonomy proliferation) — both pre-existing topics already framed the "read against the garden as convergent design" lens `unum` fits.

**Integrity gate (step 8): passed.** `library-link-check.sh --changed` OK (the `unum` cluster's 5 targets all resolve, no dangling rows); `regenerate-topics-counts.sh --check` reported stale counts (informational — no missing topic page). All 15 content files landed via `land-journal-edit.sh`; then `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` landed the two projected indexes current.

**Self-improvement routed to liaison** (`role/liaison` `20260710T205306Z-7093b4`): propose a garden per-job attributed cost ledger keyed by job base (written on doin→tada, aggregatable by job/role/model/day, optionally a `## Cost` block on the tada report) to complement — not replace — the fleet quota gate. Left for the maintainer as a job-lifecycle/control-surface change.

**Follow-ups.** Posted `scholar-ingest-unum-remainder` for the rest (`LORE/` ~70 lessons, `devoker/DESIGN.md` + refinery/staging/vigil, `notify_server`, the make/user systemd resource quota, `STANDARDS/`/persona config). Journaled result `entries/2026/07/10/205408Z-result-gardener-a61db0.md`.

Self-improvement: `conventions.md`'s source-kind schemas had no slot for a non-GitHub git forge; I handled tangled.org as a sha-anchored `repo` source with a "no blob-permalink, cite repo-root" note in frontmatter — a candidate one-paragraph blessing in `conventions.md` if more tangled/self-hosted-forge sources arrive.
