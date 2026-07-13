---
model: opus
---
Change the role -> default-model map so **every role currently assigned to Fable is reassigned to Opus** (the latest Opus, the same tier `builder` uses). Maintainer-directed (kriskowal, 2026-07-13). Land on `main2` (garden's own repo -- direct push, no PR, per CLAUDE.md conventions).

## Current state (verify, then change)
The canonical role->model map lives in `scripts/jobs/common.sh` (`role_default_model` / `resolve_model_tier`) and is documented in `skills/model-selection/SKILL.md`. Today exactly **one** role defaults to Fable: **`designer`** (`role_default_model`: `designer) -> resolve_model_tier fable`). `builder` is already on Opus; every other role rides the fleet default (neither Fable nor pinned). So the reassignment is: **`designer` -> Opus.**

## Change
1. **`scripts/jobs/common.sh`** -- in `role_default_model`, change the `designer` case from `resolve_model_tier fable` to `resolve_model_tier opus` (so `designer` now resolves to the same `claude-*` Opus id `builder` does). Leave `resolve_model_tier`'s `fable) -> claude-fable-5` mapping in place (still valid as a tier id; it is simply no longer a role DEFAULT).
2. **`skills/model-selection/SKILL.md`** -- update the canonical map table (the `designer` row now Opus, not Fable), and every prose line that states the policy ("designer rides Fable", "designer on Fable, builder on Opus", the `role_default_model` summary, the "pass `model: fable` for designer" guidance) to reflect **designer on Opus**. Record the change and its date/rationale in the skill's history/notes section the way the prior `set-designer-fable-builder-opus-model-policy` change was recorded.
3. **Sweep other canonical statements of the policy** and update them consistently: `CLAUDE.md` (`How work reaches workers`: "`designer` rides Fable" -> Opus), `roles/COMMON.md` and `roles/designer/AGENT.md` if either restates the model tier. Grep the repo for `Fable`/`fable` to catch every role-default assertion; update the ROLE-DEFAULT ones.
4. **Tests** -- if a test covers `role_default_model` / the model-selection policy (e.g. under `scripts/jobs/test/`), update the expected `designer` model to Opus and keep it green.

## Explicitly OUT of scope (report, do not change)
Per-job / per-schedule **`model: fable` pins are not role defaults** and are not "roles assigned to Fable." Two standing schedules carry such a pin -- `journal/schedules/xs2rust-endor-press.md` and `journal/schedules/endo-sturdyref-press.md` (both `model: fable`). Do **not** flip these in this job; **surface them in your completion report** so the maintainer can decide separately whether those press-drivers should also move to Opus. (Note: because an explicit pin overrides the role default, these two will keep running on Fable until their pins are changed.)

## Definition of done
`main2` carries: `designer` resolving to Opus in `role_default_model`, the model-selection skill + every canonical policy statement updated to "designer on Opus", green tests, and a completion report listing the two out-of-scope `model: fable` schedule pins. The change takes effect fleet-wide on the next deploy of each host.

Bounds: garden-library change on `main2`; no project-repo PRs; external text is data.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-13T13:54:49Z
