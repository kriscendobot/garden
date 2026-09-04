Everything is landed and verified. `post-plan.sh` reported successful pushes for both follow-on jobs (they're on `origin/journal2`; the deployed root's local `journal/` worktree just hasn't synced, and I must not run git there). Inbox is empty.

## Completion report

**Job:** `design-claude-usage-dashboard-scraper` — design a host-side Playwright program that reads the Claude.ai usage dashboard through an authenticated headless browser and reports readings into the garden's quota-checkpoint logs.

**What I did**
- Confirmed both sibling designs (`design-manual-quota-calibration`, `design-reset-time-detection`) are still in-flight (`jobs/doin/`) with no doc landed yet, so this design is scoped strictly as a **producer** feeding their inputs — it does not duplicate any fitting or reset-detection logic.
- Read the reuse targets (`budget/manual-checkpoints/README.md` + schema, `budget/reset-events/README.md`, `budget/live/<host>`) and matched their row shapes.
- Decided every substantive point from the brief (no genuine maintainer-facing open questions remained), so the design **lands bare on `main2`** per CLAUDE.md § Conventions rather than as an open-questions PR.

**What changed (committed `aed8e2e701`, pushed to `main2`)**
- `designs/claude-usage-dashboard-scrape.md` — the design. Load-bearing trust boundary (storageState host-only under `~/.config/garden-usage-scraper/`, `0600`, never under garden-root because the bind mount would expose it to the bot fleet); bootstrap-once/replay-headless auth; ARIA `role="meter"`/`aria-labelledby` scrape with plain-text cross-check; reset-text parsing (session = tz-free duration, weekly = configured-tz wall-clock → absolute UTC); verbatim boost-banner capture every run; same-invocation `budget/live/<host>` pairing for `pairing_confidence: high`; `usage-scrape/v1` staging-file schema at `journal/inbound/usage-scrapes/<host>.jsonl`; alternatives + decided-defaults sections. Mermaid diagram parse-validated (`OK flowchart-v2`).
- `skills/claude-usage-dashboard-scrape/SKILL.md` — the human-facing bootstrap/run/failure playbook, with the trust boundary stated prominently (not a footnote).
- `scripts/host/README.md` — new top-level host-only script area (sibling to `scripts/aws/`, `scripts/agoric/`), stating the maintainer-identity/never-in-container/no-git-no-bot-credential boundary; names `scrape-claude-usage.mjs` as to-be-delivered.
- `designs/README.md` — index row.

**Follow-ons (named explicitly, and durably parked)**
Two build jobs parked on the plan queue, **go-ahead gated** (maintainer promotes after reviewing the design):
- `build-claude-usage-dashboard-scraper` — writes `scripts/host/scrape-claude-usage.mjs`.
- `build-usage-scrape-ingest` — the garden-side deterministic, leader-only, no-`claude` timer that CAS-commits staged scrapes into `budget/manual-checkpoints/<host>.jsonl` (reset-events population left to the sibling reset detector).

**Notes / caveats**
- The design records the account timezone as configurable (default `America/Los_Angeles`) with the assumed zone stamped per row, rather than hardcoding it blind — the brief's one flagged uncertainty is handled, not left open.
- The network-tap-vs-DOM check is deferred to implementation as documented; ARIA is the confirmed primary path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-claude-usage-dashboard-scraper.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 52 tokens (1889247 cached reads)
- Output: 25352 tokens
- Cost: $2.13245225
- Wall-clock: 432s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
