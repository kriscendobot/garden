B1 was already implemented and merged in `kriscendobot/minion.town` commit `3765d98` (#14); no new changes or push were needed.

Verified:
- Pinned Endo checkout `f66505034aaa54ac46294347b2bf0e14655b088a`.
- Real-daemon integration: 3/3 passed, including provide -> write -> read -> restart -> read.
- B1 unit tests and `npm run typecheck` passed.

Follow-up: root `npm test` still treats two nested Node-test files as empty Vitest suites; their own package test command passes 19/19. This is unrelated to B1.

Self-improvement: nothing this time.
