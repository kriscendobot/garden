---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-05T07:43:41Z
job: fu-kriscendobot-minion.town-pr250-gauntlet-fix-4-2
claim: 43eb2af1b1c5086a
---
Fixed ci-wait-merge billing classification when the fleet PAT lacks checks:read.
- Check-run annotation 403s and failed Actions-only fallback runs now produce CI UNKNOWN / needs checks:read (rc 1), not ordinary CI red (rc 3), preventing erroneous shepherd dispatch.
- Confirmed readable billing annotations still produce billing-blocked rc 5, while definite non-billing failures remain red.
- Added regressions for both annotation-forbidden and Actions-only failed-run paths.
- Verification: ci-wait-merge-test.sh PASS=170 FAIL=0; bash syntax and git diff checks passed. ShellCheck reported only pre-existing informational findings.
- Pushed c32bd63c6255b723874dd75650cf766bc16795b7 to origin/main2.
Self-improvement: nothing this time.
