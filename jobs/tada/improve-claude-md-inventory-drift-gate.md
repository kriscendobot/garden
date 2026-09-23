Done. Empty inbox, work pushed.

---

## Completion report — `improve-claude-md-inventory-drift-gate`

**Shipped** (commit `d27cad238`, pushed to `main2` first attempt): a new pre-dispatch grep-gate `scripts/checks/claude-md-inventory-drift/`, following the established `check.sh` + `prompt.md` (+ `README.md`) contract run by `scripts/checks/run-all.sh`.

**What the gate does.** `check.sh` extracts CLAUDE.md's `## Current inventory` section (heading → next `##`), enumerates every `roles/*/AGENT.md` (one level deep — juror seats under `roles/jurors/<seat>/AGENT.md` are excluded, matching the roster's scope) and every `skills/*/SKILL.md` basename, and exits non-zero listing any name absent from that section. On a fire, `prompt.md` routes a focused liaison dispatch to add the missing backticked row(s), purely additively.

**Matching robustness.** A name counts as indexed only as a *whole hyphen-delimited token*, so `builder` is not treated as present merely because `web-builder` is listed, while a bare prose mention (e.g. "the triager") does count. This avoids both false negatives and substring false positives.

**Verified against the live tree** — the gate correctly fires on the real drift it was built for:
- `skills/oauth-use-case-patterns` (the canonical 2026-06-30 scholar-cycle incident), plus
- never-indexed v2 members: roles `foreman`, `mentor`, `proxy`, `watchman`; skills `message-bus`, `schedule`, `self-healing-wrapper`.

**Also updated:**
- `scripts/checks/README.md` — added the gate to the Installed-gates table.
- `.github/workflows/checks.yml` — added the new `check.sh` and test to the shellcheck scope.
- `tests/checks/test_claude_md_inventory_drift.sh` — 9-assertion smoke test (complete roster passes; missing skill/role fires and is named; juror seats not enumerated; substring-of-longer-token not counted; bare prose mention counts; no-CLAUDE.md passes silently). All 9 pass. `check.sh` and the test are shellcheck-clean at `-S warning`.

**CI impact: none.** CI runs the smoke suite (`tests/checks/run.sh`) in isolated scratch repos, not `run-all` against the real tree, so the gate firing on live drift does not redden CI.

**Follow-ups (not part of this job):**
1. The gate is *currently red on `main2`* by design — a liaison should run `scripts/checks/run-all.sh --gate claude-md-inventory-drift` and index the 8 unindexed roles/skills listed above (this is the meta-doc edit gardeners can't perform, which is exactly why the gate exists).
2. Two pre-existing test suites fail in this worktree, **unrelated to this change** (my diff touches none of their files): `test_maintainer_inbox_information_hiding` fires because `roles/COMMON.md` carries an off-allowlist maintainer-inbox token (real pre-existing drift on `main2`), and `test_run_all`'s claude-stub assertion is defeated by the sandbox's real `/usr/bin/claude` shadowing the PATH stub (passes in CI, which has no `claude`). Both worth a separate cleanup.
