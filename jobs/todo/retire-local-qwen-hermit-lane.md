---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener

Retire the local qwen inference lane.

Maintainer decision 2026-09-13 (muster): DROP the lane. Accept `hermits: 0`. The
current local default `qwen3:0.6b` is too small to be obviously useful, and
promoting to the 35B-A3B MoE would cost tens of GiB of disk on hosts whose budget
is already being watched. Origin: report `qwen-model-watch-20260728-180502`,
echoed by `fu-qwen-model-watch-20260728-180502-1-20260728-223502`.

Task: retire the hermit/local-qwen lane cleanly.
1. Inventory every reference first and report it before changing anything:
   `scripts/jobs/common.sh` (the local-inference block around the
   GARDEN_LOCAL_OLLAMA_URL definition, the `hermit)` worker-kind case, and the
   `garden-hermit@` unit mapping), the systemd unit templates under
   `scripts/systemd/`, the model-selection skill, any role or doc that names the
   hermit kind, and any journal config that sets a hermit count.
2. Decide, and state, whether to remove the lane outright or leave the worker kind
   inert with its count pinned to 0. Prefer OUTRIGHT REMOVAL if nothing else
   depends on the kind; prefer inert-at-zero if removal would churn the worker
   spine. Justify the choice.
3. Apply the change on main2, keeping `ls roles/ skills/` and the CLAUDE.md
   inventory consistent if anything there names the lane.
4. Make sure no host is left with an enabled garden-hermit@ unit afterwards, and
   say what each host's state was.

Do NOT run git in $GARDEN_ROOT. This is a garden-library change: main2 direct, no
PR, per CLAUDE.md conventions.

Skills: skills/model-selection, skills/rename-discipline, skills/local-verify.
