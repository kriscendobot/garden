Both halves and the re-litigation test are landed, and the cluster is closed. Everything is verified.

---

## Completion report

**Job:** `review-improve-stale-related-design-direction` — improve the garden so a build/panel can't proceed on a related design PR whose maintainer direction has gone stale (cluster `stale-related-design-direction`, member `kriscendobot/minion.town#48`).

**Landed on `main2`** (commit `6e982cd422`), cluster closed on `journal2`.

### (a) Prevention — build boundary
- **New deterministic helper `scripts/jobs/gardening/related-design-state.sh`** (no-LLM): given a repo and a change's *declared* related design PRs (explicit `--related`, or a `<!-- garden-related-design: N -->` marker in the change's own PR body), it re-fetches each related open design PR's live `reviewDecision`, latest-review timestamps, and head state and emits grep-able `related-design pr=… relation=outstanding|satisfied|none …` lines plus `related-design-verdict=attention|clear` (exit 10 attention / 0 clear / 3 surfaced-infra-error, never silently clear). Relatedness is *declared, never invented*, so unrelated PRs don't block; a later-approved changes-requested review reads `satisfied` and doesn't block.
- **`skills/design-dependency-walk/SKILL.md`**: added a horizontal **§0 Related-design review-state gate** (a hard build-prep input) and a fifth verdict **`reconcile-or-redirect`** that overrides `start-here`/`stack-on-PRs`. The build must show it still composes with every outstanding direction (in the PR body) or redirect behind the design, and carry the `garden-related-design` marker forward.
- **`roles/builder/AGENT.md`**: new operating norm requiring the helper at build preparation and forbidding declaring a slice independent from a design document while a related PR carries outstanding changes-requested direction.

### (b) Durable review-cycle sensing — panel boundary
- **`scripts/jobs/gardening/panel.sh`**: a deterministic **related-design pre-pass** runs the same helper each panel invocation (so staged re-panels re-fetch live state), rediscovers the related set from the PR-body marker, and on `attention` **forces the integrator seat in** and hands it the live evidence via `GARDEN_PANEL_RELATED_DESIGN_EVIDENCE` — firing toward review, never silently inferring independence. Best-effort/non-fatal; skippable with `GARDEN_PANEL_RELATED_DESIGN=:`.
- **`roles/jurors/integrator/AGENT.md`**: new **current-related-design reconciliation** inquiry axis + must-fix criterion (semantic composition judgment stays with the seat).
- **`skills/panel-hints/SKILL.md`**: documented the integrator's non-diff PR-history signal and its sensor (no diff probe needed — the pre-pass is the mechanization and the seat is always-on).

### Re-litigation test (`scripts/jobs/test/related-design-sensing-test.sh`, +3 committed stubs)
Hermetic, against the real timestamps. **21/21 pass:**
- **Build-time:** declared PR 47 → `attention`, recording `changes_requested_at=2026-08-17T23:22:53Z`, and it fires *despite the direction predating PR 48's first commit* (`newer_than_impl=no`) — the case a naive "is it newer than my head?" test misses.
- **Panel-time:** `panel.sh` pre-pass rediscovers PR 47 from PR 48's body marker, forces the integrator into a deliberately-trimmed seat list, and delivers `verdict=attention` evidence.
- **Negative control:** a satisfied related design (PR 50) and an undeclared unrelated changes-requested design (PR 99) both stay `clear` and are never fetched.

**Verification:** `bash -n` + shellcheck clean on all new/changed scripts; existing `panel-parallel-fanout-test` (16/16) and `panel-run-record-test` (27/27) still green (they use non-git worktrees, so the pre-pass no-ops).

**Follow-up (out of scope, pre-existing):** `tests/checks/run.sh` → `test_maintainer_inbox_information_hiding.sh` already fails on `origin/main2` because `roles/scholar/AGENT.md` was granted a maintainer-authorized `message-user.sh` capability (standing 2026-08-14) but the gate's `INBOX_ALLOWLIST`/`FREE_STANDING_ROLES` was never updated. My change introduces no restricted token; this stale-allowlist gate drift is a separate, security-adjacent fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-stale-related-design-direction.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (8715190 cached reads)
- Output: 69623 tokens
- Cost: $7.785806999999999
- Wall-clock: 1013s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
