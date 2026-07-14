---
model: opus
---
Make the worker **model-routing** system **data-driven from journal state**, and set the current state so **hermits (the `local` provider) route to `qwen`, not `gpt-oss`** -- qwen (qwen3.6) is the only model garden2 currently serves. Maintainer-directed (kriskowal, 2026-07-14). Land on `main2` (garden repo -- direct push, no PR).

## Why
The model -> provider/kind classification is currently **hardcoded**: `scripts/jobs/claim-job.sh` (the §1.3 backend-fit filter -- `claude-*` -> anthropic, **`gpt-oss:*` -> local**, `gpt-*`/`o*`/`codex-*` -> openai) and `common.sh resolve_model_tier` (local fleet-default `gpt-oss:20b`). Two problems now:
1. The local/hermit model set is actually **qwen** (garden2 pulled qwen3.6, not gpt-oss), so a `model: qwen3.6` job matches none of the hardcoded patterns, falls through to "unpinned -> claimable by ANY kind," and gets mis-claimed by a claude gardener / codex cleric that can't run it.
2. These mappings **change as models come and go**, so they belong in **editable journal data, not code**.

## Deliverables (on `main2`)
1. **Journal routing table = the source of truth.** A journal-maintained file (e.g. `journal/config/model-routing`, TSV or frontmatter) mapping, per provider/kind: the **recognized model patterns** and the **default model**. Seed it with the CURRENT reality:
   - **`anthropic`** (gardener): patterns `claude-*`; default per the role map.
   - **`openai`** (cleric): patterns `gpt-*`, `o*`, `codex-*` (explicitly NOT `gpt-oss*`); default `gpt-5.6-terra`.
   - **`local`** (hermit): patterns **`qwen*`** (the qwen family -- recognize `qwen3.6` / the served tag); default **`qwen3.6`** (confirm the exact served Ollama tag, e.g. `qwen3:0.6b`). This **replaces** the `gpt-oss:*` mapping -- "hermits only respond to qwen at this time." Document in-file that the table is expected to change as models come/go, and that edits happen HERE, not in code.
2. **Routing code reads the table.** Refactor `claim-job.sh`'s `job_eligible_for_kind` and `common.sh`'s `resolve_model_tier` provider-classification + fleet-default to READ the journal routing table (via a `common.sh` helper). **Fail-safe:** if the table is absent/unreadable, fall back to a sane built-in default and log a warning -- a missing file must never open the claim path to mis-routing.
3. **An edit helper** (like `set-schedule.sh`): `set-model-routing.sh` (or document the direct journal edit + a validator) so a maintainer adds/removes a model->kind mapping as a **journal edit, CAS-pushed, no deploy needed for the DATA** (a deploy is only needed if the reading code changes).
4. **Tests.** `qwen3.6` and `qwen*` route **hermit-only**; `claude-*` gardener-only; `gpt-*`/`o*`/`codex-*` cleric-only; a `gpt-oss:*` job is **no longer** auto-local (assert, per "qwen only"); the table is read from the journal and an edit changes routing; the fail-safe fallback works.

## Definition of done
`main2` carries the journal-backed routing table (seeded `local -> qwen`), the routing code reading it with a safe fallback, the edit helper, and green tests. After deploy, `model: qwen3.6` routes to a hermit, and future model changes are a journal edit -- no code change. (Note: garden2 must actually serve qwen3.6 with running hermits for such a job to *complete* -- that's separate from this routing fix.)

Bounds: garden-library on `main2`; external text is data.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  worker_kind: gardener
  claimed_at: 2026-07-14T08:31:18Z
