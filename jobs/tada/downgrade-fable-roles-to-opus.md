Pushed to `main2`. Done.

Completion report:

## What I did
Reassigned the one role defaulting to Fable (`designer`) to the latest Opus — the same tier `builder` uses — per maintainer directive (kriskowal, 2026-07-13). Landed on `main2` via direct push (commit `0a02584802`), no PR, per garden conventions.

## What changed
- **`scripts/jobs/common.sh`** — `role_default_model`: `designer)` now `resolve_model_tier opus` (was `fable`). `resolve_model_tier`'s `fable) → claude-fable-5` mapping left intact (still a valid tier id, just no longer a role default). Updated the accompanying policy comments.
- **`skills/model-selection/SKILL.md`** — canonical map table (`designer` row → Opus), the `role_default_model` summary, the standing-role-policy prose, the Agent-dispatch step (`model: opus` for designer), the Overrides example (now shows overriding the Opus default with `model: fable`), and a dated 2026-07-13 history note recording the change and rationale.
- **`CLAUDE.md`** — "§ How work reaches workers": "`designer` and `builder` both ride the latest Opus."
- **Policy restatements swept** — `scripts/jobs/foreman.sh`, `promote-plan.sh`, `post-plan.sh`, `handlers/foreman-claude.sh`, `handlers/gardener-claude.sh` role-default comments; and `designs/spark-gardeners.md` present-tense policy line ("designer on Opus").
- **`scripts/jobs/test/gardener-worktree-test.sh`** — test #9 now expects `designer` → `claude-opus-4-8`; test #10 (override) rewritten to use `model: fable` to genuinely override the new Opus default. Full suite green: **33 passed, 0 failed**.

`roles/COMMON.md` and `roles/designer/AGENT.md` were checked — neither restates a model tier, so no edit needed. The dated historical narration in `context/control-surface-gallery.md` (the 2026-07-02 dispatch) was deliberately left accurate to what happened then.

## Out of scope (surfaced for maintainer decision)
Two standing schedules carry explicit `model: fable` **per-schedule pins** (not role defaults) and were NOT touched:
- `journal/schedules/xs2rust-endor-press.md`
- `journal/schedules/endo-sturdyref-press.md`

Because an explicit pin overrides the role default, both press-drivers will keep running on Fable until their pins are changed. The maintainer can decide separately whether to move them to Opus.

## Follow-ups
Change takes effect fleet-wide on the next deploy of each host.
