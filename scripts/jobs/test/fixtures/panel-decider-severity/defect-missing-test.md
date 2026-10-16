**Verdict:** request-changes

**Findings:**
- `src/retry.js:20` — the PR changes the retry policy from three fixed attempts to exponential backoff capped at 30 seconds, but no test covers the new backoff schedule or the cap; the existing test still only exercises the success path. Add a test pinning the delays and the cap. [rule: skills/coverage-driven-testing/SKILL.md]
