Implemented and pushed scheduler timeout passthrough to `main2`.

- Validates and propagates schedule `handler-timeout`.
- Preserves it across rewrites and schedule edits.
- Set `xs2rust-endor-press` to `handler-timeout: 7200`.
- Tests passed: 8 timeout checks; 13 anchored-cadence regressions.

Follow-ups: none.
