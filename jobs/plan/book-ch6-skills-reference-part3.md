---
gate: blocked
blocked_on: book-ch6-skills-reference-part2
priority: normal
posted_by: producer
posted_at: 2026-09-30T04:32:47Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Garden book, chapter 6 part 3: Skills reference (34 skills, final)

This is a continuation of job book-ch6 (orchestration garden-book-orch). APPEND to journal/projects/garden-book/ch6-skills-reference.md (land via scripts/jobs/land-journal-edit.sh with --base-blob; whole-file semantics, so read the tip and pass tip-plus-your-sections). Follow the existing entry shape exactly (### `name`, Source link ../../skills/<name>/SKILL.md, Purpose / When it's used / Key mechanics / Gotchas), house style (American spelling, no em dashes, no Latin abbreviations), and read each SKILL.md in full plus grep roles/ and scripts/jobs/ for who invokes it. Add numbered theme sections continuing from 6.5, add your rows to the skill index, and update the "Coverage status" block at the top to mark your skills covered.

Cover exactly these 34 skills (suggested sections: watchers and acknowledgment; fleet infrastructure and operations; project-specific technical skills grouped as Endo/XS, Ironhorse/test262, Agoric, minion.town, web and CSS):

at-mention-surveillance, issue-inbox, reactji-acknowledgment, activity-feed-watcher, github-activity-poll, pages-build-shepherd, gardener-inbox-error-reporting, prompt-on-failure-capture, prompt-section-discovery, pty-context-introspection, self-healing-wrapper, restore, host-disposition-report, aws-administration, claude-usage-dashboard-scrape, node-lts-window-watch, node-parity-test, re-export-deprecation-policy, slog-debugging, xs-debugging, test262-independent-assertions, test-title-spec-spelling, agoric-chain-snapshot, typesafe-ai, oauth-use-case-patterns, url-path-math, minion-town-clip-publishing, minion-town-mcp-playwright-login, emoji-favicon, css-anchor-positioning-and-flip-fallbacks, css-design-tokens-and-theming, css-intrinsic-and-content-sizing, native-customizable-form-control-styling, supports-feature-query-progressive-enhancement.

This is the final part: also re-check  for any skill added since cycle 1 and cover it, and replace the "Coverage status" block with a one-line note that the chapter is complete.
