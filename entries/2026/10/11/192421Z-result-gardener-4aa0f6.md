---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-11T19:24:23Z
job: improve-sections-index-check-target
claim: cab6da3a9deb124d
---
Implemented explicit target guards for the section-index and topic-count check modes.

- Bare `--check` now exits 2 outside a valid worker clone and directs callers to pass `--library <dir>`; valid worker clones retain the implicit target.
- Updated both command usage blocks and added regressions covering refusal of the deployed-journal fallback plus worker-clone behavior.
- Verification: `regenerate-sections-index-test.sh` passed 15/15; `regenerate-topics-counts-test.sh` passed 13/13; `bash -n` passed for all four changed scripts.
- Pushed commit `83539729744140c64d82de2f932ec1dbcba532b2` to `origin/main2`.

Self-improvement: nothing this time.
