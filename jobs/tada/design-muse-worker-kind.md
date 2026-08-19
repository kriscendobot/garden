Design landed on `main2`. Job complete.

## Completion report

**Job:** `design-muse-worker-kind` (designer) — design a new "muse" worker kind for Meta Muse Code / Muse Spark.

**State on re-claim:** clean start; no prior attempt had committed anything (`designs/muse-worker-kind.md` absent, no muse commits in history).

**What I did:** Read the source page (`developer.meta.com/ai/products/muse-code/`) and the required precedents (monk rename, gnome backend-verified provisioning, cleric/hermit reputation, live-budget-admission), then studied the actual registry (`worker_kind_field`, `worker_kinds`, `canonical_worker_kind`, `role_default_model`, `resolve_model_tier`, the two `.tsv` tables, `fireworker`/`mystic` handlers, `set-workers.sh`, the credential handoff). Wrote and landed `designs/muse-worker-kind.md` directly on `main2` (commit `d2a970ae8b`, no PR per CLAUDE.md § Conventions).

**Key decisions in the design:**
- **Integration shape:** integrate via the **OpenAI-compatible Meta Model API through the existing Codex harness** (mirror `fireworker`), *not* the native `muse` CLI. This sidesteps Muse's nested multi-agent orchestration *by construction* and avoids sandboxing a beta `curl | bash` binary. Native CLI retained as a named fallback.
- **Nested orchestration:** garden jobs run **single-agent** Muse; the garden's own board/panel/fix-loop stays the sole orchestrator. Multi-agent mode flagged as an explicit open question, not adopted.
- **Cost/budget:** metered real-dollar spend rides the existing per-call `usage/` dollar ledger (per live-budget-admission §3), same as fireworker/mystic; **no automatic routing**, explicit-`model:`-only, count-0-by-default, provisioning-gated. Defaults to the **Standard** pricing tier (Contributor tier flagged as a data-governance opt-in since it trains on submitted code).
- **Credential gate:** follows `FIREWORKS_API_KEY` shape (provisional `META_API_KEY` + `GARDEN_META_BASE_URL`), backend probe added to `worker_backend_probe`; surfaces **beta access as a real precondition outside garden control**.
- Full concrete registry inventory for the follow-up build, plus 6 explicit maintainer open questions (beta/ToS, pricing tier, exact credential mechanism, base URL, wire model id, agentic tool-calling support) and a 4-phase implementation plan.

**Verified:** no `muse` token/path/unit/role collision in `roles/`, `skills/`, `scripts/`. Push to `main2` succeeded (CAS, first try).

**Follow-ups:** none posted — per the job brief, a build does **not** follow from this design; it awaits maintainer review of the open questions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-muse-worker-kind.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 28 tokens (1082462 cached reads)
- Output: 15693 tokens
- Cost: $1.8113090000000003 (1 engagement(s) unpriced)
- Wall-clock: 258s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
