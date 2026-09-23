---
title: Common confusions
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "124-210 (CALLSITE_ELLIPSIS_PATTERN1/2 + CALLSITE_PACKAGES_PATTERN + CALLSITE_FILE_2SLASH_PATTERN + shortenCallSiteString)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The middle section of `tame-v8-error-constructor.js` defines four
  regex patterns that *shorten* kept stack-frame strings in concise
  mode. Each pattern encodes one ad-hoc rule for which path-prefix to
  drop. The rules are *deliberately heuristic* — concise stacks are
  optimized for human readability rather than completeness — and each
  is documented with a worked before/after example. Two of the four
  comments link to `agoric-sdk#2326#issuecomment-773020389`, the
  cross-thread where the patterns were originally argued. The four
  patterns and the `shortenCallSiteString` function pair with the §1
  filename-censor mechanism: filename-censoring decides *whether* a
  frame is kept; pattern-shortening decides *how much path* to show in
  the kept frame's stringification.
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns
---

- **"The four patterns are too ad-hoc."** They are *deliberately* ad-hoc — concise stacks are optimized for human readability, not formal correctness. A formal grammar for *path-likely-to-shorten* would be over-engineered for the use case. The patterns serve the common cases (Node monorepos, file://-prefixed paths, ellipsis conventions) and fall through cleanly when they don't apply.
- **"The order of the patterns matters — that's fragile."** It does, but it's the *intentional* order: more specific patterns first, more general patterns later. The order is part of the design, not an implementation accident.
- **"`/packages/` is specific to lerna."** The comment names this — *Note that `/packages/` is a convention for monorepos encouraged by lerna*. The pattern works for any monorepo using the convention (yarn workspaces, pnpm workspaces, nx, turborepo all default to `packages/`). The pattern *doesn't apply* to non-`packages/`-rooted monorepos (e.g. `apps/...` or `services/...`), but the fall-through to unchanged-string is the right outcome there.
- **"`file://` vs `file:///` distinction is fragile."** It is *VS-Code-specific* and *empirically discovered*. The author documents the workaround honestly. If VS Code's URL detection changes, this pattern might need adjustment — but that's a known sensitivity, not a hidden bug. Other terminals (e.g. iTerm2) might treat both forms uniformly; the workaround is conservative.
- **"`agoric-sdk#2326#issuecomment-773020389` is a brittle link."** GitHub issue URLs are *long-lived but not immortal*. The link preserves the design-discussion-thread for as long as the issue exists. If the issue moves or is archived, future maintainers would need to follow the redirect or check the comment-archive. The link is *worth-having-even-if-fragile* — better than no record.
- **"The TODO about lockdown options is just deferred work."** It is — and the deferral is *deliberate*. Until a concrete use case demands user-configurable censor/pattern lists, the hardcoded defaults serve. The TODO records that the design surface is *known* to be limited and *intentionally* limited until the use case arrives.
