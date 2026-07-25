model: gpt-5.6-terra
role: fixer
Fix the final Kimi K3 Mystic model-selection mismatch in kriskowal/garden. Official Kimi Code 0.29.1 docs and live evidence show KIMI_MODEL_* synthesizes an in-memory temporary model, but the handler then passes `--model k3`, which overrides that selection and fails because no config.toml alias exists. The Moonshot /v1/models endpoint exposes wire id `kimi-k3`, not `k3`. A secret-safe direct probe succeeds with KIMI_MODEL_NAME=kimi-k3 and no --model argument. Change kimi-provider/handler wiring to set KIMI_MODEL_NAME=kimi-k3 and omit --model for fresh and resume invocations. Preserve garden routing/reputation id kimi-k3. Add regressions asserting no --model override and exact wire id; run Mystic, worker-spine, completion, routing tests; push main2 directly and report deploy readiness. Do not use live credentials or requeue canaries.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-25T00:35:23Z
