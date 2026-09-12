---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/local-verify.sh
Add an overrideable repo-root TypeScript-program check with sufficient Node heap, matching CI, so JavaScript test type errors cannot pass local verification in packages with `checkJs: false`.
