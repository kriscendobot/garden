---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
kind: probe (gap-revealing-build, skills/gap-revealing-build/SKILL.md)

Repo: endojs/endo-but-for-bots, based on `master`. Related: Bun probe PR https://github.com/endojs/endo-but-for-bots/pull/1516.

Goal: learn whether running the Endo test suite in real WebKit (Safari's engine) is economical. Maintainer finding: Bun (JavaScriptCore) is a weak Safari proxy because `URLSearchParams.prototype.length` is Bun-only (Safari returns `undefined`), so we want a direct WebKit signal.

Task (time-boxed; "don't try too hard"):
1. Run a slice of the suite in Playwright's WebKit build (e.g. ses, a few pure-JS packages): lockdown in WebKit, then tests. Choose a mechanism that fits what exists (see the repo's existing browser-test setup and the Chromium bundled-browser notes; browser-test.yml). Report what worked.
2. Record any SES/lockdown failures specific to WebKit/JSC and whether they need permits or are real bugs. Any permit proposal must pass: innocuous value, cannot share state or communicate between compartments.
3. Note whether Ava can run there or a different harness is needed; estimate the cost of wider coverage; note coverage options for WebKit (likely none via V8 coverage).
4. Optionally a CI job (advisory, non-blocking) if cheap.

Deliver a structured gap report in the DRAFT PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-21T05:27:44Z
