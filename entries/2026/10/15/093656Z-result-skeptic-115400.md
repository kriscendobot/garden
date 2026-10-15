---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-15T09:37:00Z
job: kriscendobot-minion.town-pr189-gauntlet-panel-2
claim: 65d5b8b16a04bf35
---
project: minion-town
refs: user dispatch for kriscendobot/minion.town PR #189 (origin/main-ad0257e...HEAD)

**Verdict:** request-changes

**Findings:**
- must-fix: `designs/clip-shell-framework.md:154-163,280-312` treats a blocked frame as an accepted failure because the user can fall back to a top-level link, but it specifies neither that link nor how it is offered or tested. An XFO-only browser, a CSP-rewriting intermediary, or the stated CORP disagreement will leave a cross-origin iframe blank; the parent cannot reliably inspect that failure. Specify an always-available, validated top-level navigation for the selected clip (including its fragment-handling rule), and add browser coverage for it, before presenting the fallback as part of the rollout. [proposed-rule: Every deliberately accepted cross-origin iframe-block failure must have a specified, independently reachable fallback and an acceptance test for that fallback.]
- should-fix: `designs/clip-shell-framework.md:244-260,307-312` makes the shell parser and the no-locator assertions depend on "#88 fragment grammar," yet this checkout contains no grammar or normative reference for `backend=<locator>`. The proposed suite therefore cannot determine accepted encodings, duplicate keys, malformed fragments, or log-redaction boundaries. Keep the locator handoff explicitly outside these two increments, or give this design a concrete dependency/versioned grammar and tests before making it an acceptance case. [proposed-rule: A design may name a future capability protocol in an acceptance test only when the protocol grammar and its authoritative version are available to the implementing change.]

Self-improvement: nothing this time.
