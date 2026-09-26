Implemented and pushed `02513cd130f` to `main2`.

- Removed `gardener` as a worker kind; monk is the sole Anthropic kind.
- Retired legacy handler, setter, migration scripts, compatibility/cutover tests, and legacy unit template.
- Installer now disables/removes `garden-gardener@.service`; local unit check shows only `garden-monk@.service`.
- Updated scaler, count schema, bulletin, defaults, state paths, and regression coverage.
- Confirmed live host records are zeroed/absent for `gardeners:`.
- Passed worker-spine, installer, and scaler regression tests.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/expunge-gardener-worker-kind.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 600s

<!-- garden-usage-end -->
