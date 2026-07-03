Inbox is empty. The work is complete and pushed to `main2`.

## Completion report

**Job:** Harden `scripts/jobs/scheduler.sh` so a named-but-missing preflight gate (the live `xs2rust-endor-press.md` → `gardening/xs2rust-endor-press-preflight.sh` deploy-lag case on endolinbot2) stops spamming a per-tick WARN and instead diagnoses the pending deploy.

**What I did** (pushed as `3e51f3f35` on `main2`):

1. **De-duplicated the not-found WARN.** Added `note_missing_preflight` / `clear_missing_preflight` helpers backed by a per-`(schedule, resolved-path)` marker under `$GARDEN_STATE/scheduler/preflight-missing/`. The WARN now fires **once per breakage** rather than on every due tick for the whole deploy-lag window. The marker is cleared the instant the gate is found again (e.g. after the host is deployed), re-arming the signal.

2. **Emitted a distinct one-shot deploy-lag signal.** When the missing script is **present on `origin/$GARDEN_MAIN_BRANCH` but absent from the deployed root**, the scheduler now diagnoses deploy-lag (via a bounded best-effort fetch + `git cat-file -e`) and surfaces it once, two ways: a structured note in the deploy state dir (`$GARDEN_DEPLOY_STATE/preflight-deploy-lag-<schedule>`, co-located with the `upgrade-ready` marker the liaison's deploy Monitor watches) reporting deployed→available shas and ahead-by count, **plus** a one-shot message-bus escalation to the maintainer inbox — both pointing at `deploy-garden.sh` as the fix.

3. **Preserved conservative fail-open dispatch** — real work is never starved; every code path still dispatches unconditionally when the gate can't run. The existing `preflight_missing_streak` escalation is untouched and complementary.

**Changed files:**
- `scripts/jobs/scheduler.sh` — the two hardenings, wired into the `[ -x "$pf" ]` else-branch.
- `scripts/jobs/test/scheduler-preflight-deploy-lag-test.sh` — new hermetic test (throwaway journal + deployed root whose `origin/main2` carries the gate its working tree lacks). Verifies fail-open dispatch, WARN-once, deploy-lag note + message, marker contents, and clear/re-arm on gate-present. **14/14 pass.**
- `skills/schedule/SKILL.md` — documented both guards.

**Verification:** `bash -n` clean, no new shellcheck findings, and the end-to-end hermetic test passes all 14 assertions including the best-effort maintainer-inbox delivery.

**Follow-ups:** None required. Once endolinbot2 is deployed (catching up its 61-commit lag), the `xs2rust-endor-press` preflight resolves and the marker/note self-clear on the next tick. Note that a genuine deploy-lag and the existing streak-threshold escalation can both fire one-shot messages for the same breakage; in practice the deploy usually lands before the streak reaches 3 (90 min at 30m cadence), so this is rarely observable and both messages are accurate.
