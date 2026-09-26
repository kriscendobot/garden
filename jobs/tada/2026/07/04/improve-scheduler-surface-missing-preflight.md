I've verified the full picture. This job's requested feature is **already implemented and merged on `main2`** — nothing needs building.

Findings:

**The escalation surface the job asks for already exists.** On the missing-preflight branch (`scheduler.sh:326`, the `else` of `[ -x "$pf" ]`), `note_missing_preflight` (lines 165–235) does exactly what the job specifies:
- **Fail-open preserved** — `pf_rc` stays `0`, so the schedule still dispatches (work-present). ✓
- **One-shot deduped escalation to the maintainer inbox** via `alert_maintainer` → `inbox-send.sh maintainer`. ✓
- **Deduped on `<name>+<preflight-path>`** — the marker file is keyed on the schedule name and its *content* is the resolved path (`preflight_missing_marker`, line 140; the guard at line 169 returns early only when both the marker exists *and* its content equals the current resolved path). So it fires once per `(schedule, path)` breakage and re-arms if the path changes — precisely the requested key. ✓
- **Bonus already present:** a deploy-lag vs. typo/never-landed diagnosis (checks whether the script exists on `origin/main2` but not in the deployed root) and a co-located deploy-state note. This is exactly the situation the job's own observation describes.

These landed in commits `6f0e35c05`, `3e51f3f35`, `1e5ccb552` (all confirmed ancestors of HEAD `ca0900703`), plus the WARN-dedup marker.

**The job is a stale / deploy-lag artifact.** The WARN quoted in the job (`preflight '<pf>' not found/executable … treating as work-present`) is the *pre-refactor* wording (the current WARN at line 171 is expanded). The specific gate it names, `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh`, is **present and executable** on `main2`, and the `xs2rust-endor-press.md` schedule already points at it. The empty `033634Z` tick and the WARN were emitted by a **deployed host running behind `origin/main2`** — classic deploy-lag, which the now-merged escalation path would itself diagnose (once that host runs the current scheduler, it either has the gate script — WARN gone entirely — or, in the interim, fires exactly one deploy-lag escalation naming the pending deploy).

No code change made; fabricating one would only churn already-correct code.

**Follow-up (not a code task):** deploy the host that observed the WARN (`scripts/jobs/deploy-garden.sh` on it). Once current, both the gate script and the escalation logic are present and the silent-dispatch loop is closed.
