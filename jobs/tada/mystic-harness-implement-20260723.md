Implemented and pushed `8a65020da0` to `main2`.

- Replaced Codex/Moonshot path with official Kimi Code CLI Mystic harness.
- Added isolated per-job KIMI_CODE_HOME, resume, sentinel gating, cleanup, and secret-safe configuration.
- Enforced explicit `model: kimi-k3`, blocked unpinned and builder/designer Mystic jobs, and kept capacity disabled.
- Added official CLI image install and focused offline tests.

Tests passed: Mystic harness (14), worker spine (103), model routing (29), foreman routing (10).

Follow-up: rebuild/deploy the garden image before deliberately enabling any Mystic capacity.

Self-improvement: nothing this time.
