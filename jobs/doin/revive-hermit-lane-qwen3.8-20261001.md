---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Revive the local `hermit` (on-box Ollama) lane, upgraded to qwen3.8

Maintainer directive (kriskowal, liaison session 2026-10-01): "let's try to
upgrade and validate that the ollama gardeners can do work." This is the
standing `qwen-model-watch` schedule's reassessment trigger finally firing on
a real upstream release: `ollama.com/library/qwen3.7` never shipped (still
404), but `ollama.com/library/qwen3.8` is live (published ~2026-09-25, tags
`27b`/`27b-mlx`/`latest`, "substantial gains across coding, … long-horizon
agentic tasks"). See the standing watch's last notice,
`journal/inbox/maintainer/read/msg-fu-qwen-model-watch-20260728-180502-1-20260930-162006-c2728cdbeb52.md`
(now archived from unread).

## Background — why the lane is currently inert

The `hermit` worker kind (a codex/claude harness against an on-box Ollama
`/v1` endpoint, provider `local`) was pinned to **inert-at-zero** on
2026-09-13 by `retire-local-qwen-hermit-lane` (landed `93b5a5a573` on
`main2`) — **not because qwen3.6 failed its bounded mentor-tier trial**, but
as an operational pause (see that job's `jobs/tada/2026/09/13/` report and
`designs/qwen3.6-mentor-tier-trial.md`). The kind was deliberately **kept
registered** (not removed) specifically so it could be un-retired later
without spine churn. Read both of those before touching anything.

## Task

**1. Revert the inert-at-zero clamp, scoped to the code the retirement job
itself changed** (diff against `93b5a5a573` to find every site precisely —
do not guess from this summary):
   - `install-units.sh` `scale()`: remove the hard clamp-to-0 for `hermit`.
   - `set-hermits.sh`: remove the nonzero-count refusal.
   - `common.sh` `worker_kind_field hermit` case: remove the RETIRED
     annotation (or update it to reflect the revived state — your call on
     wording).
   - `skills/model-selection/SKILL.md`: remove/update the "RETIRED
     (2026-09-13)" language for the local Qwen/hermit lane.
   - Docs retirement banners added in `starting.md`,
     `local-inference-amd/README.md`, `qwen-mentor-trial.md` — remove or
     update each to reflect the revived, upgraded lane.

**2. Upgrade the pinned model from `qwen3.6` to `qwen3.8` everywhere it's
referenced** (the inventory row, probe/pull defaults, docs) — **do not just
flip the string**: confirm the exact tag to pin (`qwen3.8` default tag vs.
`27b`) and look up its real `pull_bytes` against the live
`ollama.com/library/qwen3.8` page or an actual `ollama pull`/`ollama show`
probe — `model-tier-inventory.tsv` requires a **reviewed, non-blank** size
before the sysop `local-model` op will pull it closed-by-default
(`scripts/jobs/model-tier-inventory.tsv` header comment explains the
contract). Update the `local	qwen3.6	minion	23938333577` row to the new
model/size. Leave the tier at `minion` — this is an upgrade of the existing
reviewed row, not a promotion; promotion still requires the evidence bar in
`designs/qwen3.6-mentor-tier-trial.md`.

**3. Decide what to do with the existing bounded-trial design
(`designs/qwen3.6-mentor-tier-trial.md`, marked on-hold).** Don't silently
repurpose it for 3.8. Either: (a) land a new, separately-dated
`designs/qwen3.8-mentor-tier-trial.md` that is explicitly the SAME bounded
mechanics re-armed for the new model (fresh slot/attempt counters — the old
trial's consumed slots/demerits do not carry over to a different model), and
mark the 3.6 doc superseded/closed; or (b) if you judge the 3.6 trial never
actually reached its stop condition and its remaining slots are still valid
evidence-gathering capacity for the *lane* generally, say so explicitly and
justify re-using it unmodified. Make a real decision and record it — this
repo's own convention (CLAUDE.md § Conventions) is direct-to-`main2`, no PR,
for garden-library changes like this.

**4. Run the test suites the original retirement job touched** (find them by
grepping for `hermit`/`qwen` across the test tree and by diffing
`93b5a5a573`'s test-file changes) and confirm all green after your revert +
repin. `bash -n` every script you edit.

## Explicitly NOT in scope for this job (liaison will handle, in-session)

Do **not** pull the model, arm a nonzero hermit count, or admit any real
trial/canary job yourself — those are host-level, human-watched operations
(the model pull is tens of GiB via the attested sysop `local-model` op; the
maintainer wants to watch capacity get armed and the first real job get
claimed, not have it happen unattended inside your job). Your job is done
once the code is reverted/upgraded, tests are green, and it's pushed to
`main2`. In your completion report, state plainly: (a) the exact model
tag + reviewed pull_bytes you landed, (b) which of the two trial-doc options
above you chose and why, and (c) the exact follow-up commands the liaison
should run post-deploy to pull the model, arm one hermit, and admit a first
validation job (cite the real script names/flags, e.g.
`send-host-op.sh <host> op=local-model authorized_by=kriskowal`,
`set-workers.sh hermit 1`, and the trial-admission form from whichever trial
doc you landed) — don't make the liaison re-derive them.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=24 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T21:22:34Z
