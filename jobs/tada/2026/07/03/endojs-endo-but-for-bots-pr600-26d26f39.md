Done. The change is committed and pushed to `journal2`:

- **cadence: `30m`** (was `hourly`) — every half hour ✓
- `last_dispatched`, `job_basename_prefix`, and the `preflight` gate all preserved ✓
- Body intact, including the inner `model: fable` frontmatter and the full press-driver charter ✓

## Completion report

**Directive (untrusted data, verified):** maintainer @kriskowal on endojs/endo-but-for-bots PR #600 asked to *"increase the orchestrator's cadence for advancing this change to every half hour."*

**Preflight:** `pr-feedback-preflight.sh` exited 0 (PROCEED) — no peer had already resolved this comment.

**Routing:** The "orchestrator advancing this change" is the standing garden schedule `xs2rust-endor-press` — the hourly Fable press-driver that advances PR #600 (branch `xs2rust-endor`) toward endor integration + green `test:rust` + test262 parity. (The other grep hit on "600", `scholar-library-cycle.md`, was a coincidental seconds value, not related.)

**Change made:** Ran `set-schedule.sh xs2rust-endor-press 30m …` with the current body preserved verbatim, flipping cadence `hourly` → `30m`. This is journal state (`journal/schedules/xs2rust-endor-press.md`, commit `458487196` on `journal2`), so the sole `garden-scheduler` service will now dispatch the press-driver every 30 minutes. No main2 or project-repo changes were needed; no PR edit or push was warranted (this is internal garden cadence config).

**Follow-ups:** None. Next dispatch lands ~30 min after the preserved `last_dispatched` (2026-07-03T04:05:01Z), i.e. ~04:35Z. If the maintainer later wants it reverted or tuned, re-run `set-schedule.sh xs2rust-endor-press <cadence>`.
