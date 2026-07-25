Implemented capability-scoped Rust/XS directory watching and opened draft PR [#1](https://github.com/kriscendobot/endo-but-for-bots/pull/1).

- Added poll/diff backend, BSD/macOS kqueue wakeups, XS watch handles, JS async iterator, tests, and daemon changeset.
- Validation passed: focused Rust tests, 31 AVA watch/conformance tests, TypeScript, Prettier, staged gates.
- Full local gauntlet is blocked by non-executable dependency shims and an unrelated agentry evaluation failure; CI is running.

Follow-up: monitor CI and macOS kqueue coverage.

Self-improvement: nothing this time.
