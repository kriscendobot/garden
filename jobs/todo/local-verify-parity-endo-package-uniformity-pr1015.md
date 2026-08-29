---
role: gardener
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Close local verification coverage for Endo package-uniformity CI

PR endojs/endo-but-for-bots#1015 failed CI because `node scripts/check-package-uniformity.mjs` rejected a tracked `src/types.d.ts`. The generic `scripts/jobs/gardening/local-verify.sh` runs the repository root `lint` script, but Endo CI runs `yarn test:package-uniformity && node scripts/check-package-uniformity.mjs` as an additional parallel lint check, so the local gate would not have caught this failure.

Add a durable, tested local-verify mechanism that covers the Endo package-uniformity check before a PR push without duplicating that check inside CI's existing `yarn lint` leg. Update the local-verify skill documentation and tests as needed. This is the parity follow-up required by `skills/ci-failure-classification-loop/SKILL.md`.
