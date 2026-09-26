Inbox empty. Work complete.

---

## Completion report

**Job:** `design-garden-telemetry-and-anomaly-response` (role: designer). Produced a Proposed design doc and landed it on `main2` — no runtime behavior changed, as specified.

**What I did**
- Inventoried the existing substrate before designing (the directive's central warning): read `usage-append.sh`/token-cost-ledger (the CostRecord fact table), `watchdog-notice.sh` (coalescing/`notice_count`/`--recovered`), `root-repo-guard.sh` (its three invariants — confirming worktree-cleanliness is *not* one, matching incident #4), `send-host-op.sh` (the closed sysop vocabulary + issuer-gate/attestation), the bulletin Pages app, and `mentor.sh` (the existing LLM self-healing responder).
- Wrote `designs/fleet-telemetry-and-anomaly-response.md`.

**What changed**
- One new file: `designs/fleet-telemetry-and-anomaly-response.md`. Committed as `e3d6897042`, pushed to `origin/main2` (CAS loop, clean on first attempt).

**The design, in brief**
- **Metrics are derived, not a new store** — recomputed from `usage/`, `reputation/`, the board, and host state (the `cnf-backlog-triple` precedent). Explicit reconcile table of what becomes substrate vs. what's untouched; nothing superseded.
- **Collection is a `garden-vitals` systemd timer, not a gardener job** (because `gardener.sh` exits before its bus read under drain — the fix for going blind on the exact collapsed hosts that matter, #1).
- **Three tiers, bounded footprint**: host-local raw ring buffer (unpublished) → one rewrite-in-place per-host heartbeat → one leader `vitals/fleet.json`. No per-tick journal bloat; trend via bounded in-snapshot bucket arrays.
- **Nine vital signs**, each justified by the specific 2026-08-01/04 incident it catches (#1–#9), plus adjacent page-only synthetic external probes for #10.
- **Five-rung response ladder** with a ceiling: record → coalesced `watchdog-notice` → bounded one-per-condition remediation job → closed-vocab non-destructive `sysop` op → page. An `incidents/open/` worker-readable registry kills the 8-gardener rediscovery (#7).
- **Explicit boundary** (§ What must NOT be automated): code, external surfaces, the deployed tree, and identity are detect-and-page only.
- **Detector self-verification** (heartbeats + watchdog-watchdog + synthetic canary + a new `root-repo-guard` worktree invariant) so a silent detector can't masquerade as health (#4, #6).
- Leader/follower placement table, drain-safety per rung, public-journal privacy analysis (digest precedent, ratios-not-dollars), non-goals, considered-and-rejected, and a **four-phase build split** (phases 3–4 flagged for their own review).

**Follow-ups named in the doc (not done here, correctly out of scope):** the two-field CostRecord widening (`applied_budget_s`, `park_signature`); correcting the `deadline-overrun` signature classifier (#3); the `panel.sh` PR-reference fix (#5); and the four implementation phases.

Inbox drained (empty). One design was the right size given the phased split proposed inside it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-garden-telemetry-and-anomaly-response.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 23 tokens (618345 cached reads)
- Output: 24352 tokens
- Cost: $1.5373014999999999
- Wall-clock: 396s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
