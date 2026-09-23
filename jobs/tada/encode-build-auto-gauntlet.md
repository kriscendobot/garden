Done. Report follows.

## Completion report: encode-build-auto-gauntlet

**Pushed to `main2`:** `cc425cbf44de2c0454f931347cfa49f7624e9f15` (rebase CAS, first attempt).

**Behavioral verification first (per the job's guard clause):** I confirmed the auto-handoff is genuinely wired before touching prose, so this is a doc-only gap, not a behavioral one:
- A `build` job is worked through the gardening state machine `scripts/jobs/gardening/garden-pr.sh`, which the gardener supervises.
- `scripts/jobs/gardening/panel.sh` **terminates by un-drafting** on a clean panel (`panel.sh:6,175-176,225-237`, default `GARDEN_PANEL_UNDRAFT=true` → `gh pr ready`).
- The probe path (`skills/gap-revealing-build/SKILL.md:13-14,192-200`) explicitly **skips** the cleaner/panel/fixer/un-draft chain and stays draft.

No behavioral gap found, so no `message` to `liaison` was needed.

**Files touched (3):**
- `roles/liaison/AGENT.md` — new operating norm: a `build` (and `design`-then-`build`) auto-runs the gauntlet under the supervising gardener; the liaison must never tell a maintainer a build "won't auto-run the gauntlet" or that they must separately gauntlet a build-produced PR. States that `run the gauntlet #N` is for non-build-produced PRs or on-demand re-runs, with the probe (`gap-revealing-build`) stays-draft exception called out explicitly as the one carve-out.
- `README.md` § Key vocabulary — rewrote the **build** row, added a **probe** row, and rewrote the **run the gauntlet #N** row to encode the same distinction.
- `CLAUDE.md` § Orchestrator vocabulary — same clarification on the **build**, **probe**, and **run the gauntlet** rows for consistency with the brief.

**Style compliance:** all new prose avoids em-dashes (`em-dash-style`) and Latin shorthand (`no-latin-shorthand`) — verified by grep over the added lines. Legacy em-dashes in surrounding text were left untouched (sweep is out of scope).

**Follow-ups:** none. The clarification is a tight doc fix; no new machinery was added and no redundant auto-gauntlet mechanism was introduced.
