# gardener: honor a per-job model selection (so a job can request Fable)
Garden-infra gap: `scripts/jobs/handlers/gardener-claude.sh` invokes `claude -p` with the DEFAULT model
(line ~219, no `--model`), so a job cannot request a specific model. The maintainer wants some jobs
(e.g. the README tutorial) to run on **Fable** (`claude-fable-5`).
Task: teach the gardener handler to read a **`model:`** field from the claimed job's `.md`
(YAML frontmatter — e.g. `model: fable`) and pass it through as **`claude -p --model <value>`** (map
short names fable→claude-fable-5, sonnet/opus/haiku→their ids per the environment). When the field is
ABSENT, behavior is UNCHANGED (current default model). Keep it minimal + robust (bad/unknown value →
fall back to default + log, never crash the tick). Add a test (job with `model: fable` → `--model
claude-fable-5` in the invocation; no field → no `--model`). Relate to `skills/model-selection`. Land on
`main2` via an isolated worktree off origin/main2.
