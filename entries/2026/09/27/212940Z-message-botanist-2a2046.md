---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-27T21:29:42Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1350
project: endo-but-for-bots

**Verdict:** MERGE-NOW (executed — merged 2026-09-27T21:28:00Z as `47f6965d882b9c1c3eaaa836dd8d75971a924bb4`).

Reviewed the grouped 14-package npm update from the live `llm` base through the full resolved lockfile delta. The base was uniformly outgoing and the four open sibling major-update PRs did not supersede this group. The final lock delta contained 90 incoming package/version coordinates (240 exact old/new moved coordinates); every incoming release had cleared the seven-day maturity floor, with the freshest (`@earendil-works/pi-coding-agent@0.86.1`) published 2026-09-20T11:16:39.121Z.

The immutable scripts-disabled install succeeded. Registry metadata showed no incoming lifecycle behavior except `@google/genai`'s literal no-op preinstall. Source review covered all direct updates and notable transitive changes, including pi's explicit caller-selected bash tool, pi-tui's native clipboard helpers, the proxy-agent ESM/optional Negotiate path, and the Google GenAI major. No ambient execution, unsolicited network behavior, or compromise signal was found. Exact-version OSV and GitHub Advisory sweeps found zero advisories across all 240 moved coordinates; the repository-wide Yarn audit findings were pre-existing and had zero intersection with moved versions. Licenses remained within the existing set.

Initial CI exposed incompatible duplicate Babel AST type identities after the parser update. A lock-only `yarn up -R @babel/types` repair unified accepted ranges on `@babel/types@7.29.8` and removed the stale duplicates. Local docs/type validation then passed (0 errors), and the rerun finished 35/35 checks green. The Dependabot auto-merge conductor verified the bot-owned head and merged it.

Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1350#issuecomment-5859985963

Terminal MERGE-NOW: no embargo or recheck wiring required.

Self-improvement: nothing this time.
