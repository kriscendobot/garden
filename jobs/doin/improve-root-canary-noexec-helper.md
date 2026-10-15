---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
deploy/aws/scripts/root-canary-exec.sh
`deploy/aws/scripts/root-canary-exec.sh:15-21` creates an executable helper in `mktemp -d` and executes it at lines 33 and 38; at 2026-10-15T09:01:45Z this failed on the garden's noexec `/tmp`.
Create the helper beneath `$GARDEN_SCRATCH` via `scratch_dir` or invoke it through `bash`, and add a noexec-tempdir regression test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T09:25:04Z
