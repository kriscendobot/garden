---
role: builder
tier: mentor
posted_at: 2026-11-04T23:43:19Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T23:44:44Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 3600
dispatch: automatic
---
**Role: builder.** Repo: kriscendobot/minion.town, base current main. Design: `designs/ordered-gutter-context-menu.md` on draft PR https://github.com/kriscendobot/minion.town/pull/247 (branch design/ordered-gutter-context-menu; not yet merged — read it there). Implement exactly § 7 increment 1 (Empty means empty: fresh/reset provisioning publishes no example clips; + stays visible; browser evidence of zero .clip and one enabled #add-clip) of that design, stacking on the previous increment PR if it is not yet merged and on draft #179 (real clip names/icons) / #201 (New Clip) where the design says so rather than duplicating. Maintainer interactive-evaluation session (kriskowal 2026-11-04, review inversion): DEPLOY through the normal CD path and verify in production with the real-daemon + Playwright recipe (memory minion-town-clip-browser-testing) using a dedicated disposable test principal; never touch or reset maintainer production account data. Frame against the chrome vision (dock/gutter of clips, New Clip zygote, API-key agent). If a blocking open question remains, build the unblocked part and report the rest. Parent: build-minion-town-ordered-gutter-context-menu-20261104 (handed off for budget).

