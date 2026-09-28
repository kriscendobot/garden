---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-28T23:55:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement the design landed by job `design-npm-minion-town-dev-registry` —
read that job's `jobs/tada/` report for the exact design PR URL(s) and
repo(s) it landed in before starting.

Build the npm-protocol-compatible registry-serving capability, and the
minion.town deployment surface, that the design specifies, so that
https://npm.minion.town can:
  (a) accept `npm publish --tag dev-YYYY-MM-DD` for endo-but-for-bots
      packages, and
  (b) serve `npm install`/`yarn install` against that registry, including
      full transitive dependency resolution,
exactly as the landed design describes.

Open one draft PR per repo the design specifies — most likely one on
endojs/endo-but-for-bots for the registry-serving logic, and one on
kriscendobot/minion.town for hosting/deploy/DNS-TLS wiring. Do not combine
design and implementation in one PR
(`skills/pr-creation-flow/SKILL.md` § Designs versus implementations — this
is a pure implementation job, base each PR on the project's normal
implementation base, not the design's roadmap branch).

Every PR you open MUST be opened DRAFT
(`skills/pr-creation-flow/SKILL.md` § Draft discipline) and stops there — no
gauntlet runs automatically under the manual-gauntlet-trigger regime; a
follow-up job drives that.

In your completion report, list every PR URL you opened, one per line,
unambiguously (e.g. `Opened: https://github.com/<owner>/<repo>/pull/<N>`) —
a follow-up job parses this report mechanically to find them, so do not bury
the URLs in prose.
