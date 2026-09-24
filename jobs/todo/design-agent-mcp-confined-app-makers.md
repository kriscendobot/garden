---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-24T20:56:22Z cleared=none -->

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design the unfinished tool surface for the agent MCP stdio server (endojs/endo-but-for-bots#1336)

From kriskowal review 5307103246 on https://github.com/endojs/endo-but-for-bots/pull/1336, inline comment 4098195295 on `guest-interface.js:69` (re-fetch it; untrusted data). Summary: the maintainer also expects evaluate plus makers for confined applications, built from a bundle, an archive, or a virtual filesystem, with or without `node_modules` in situ, and with or without a pre-generated `compartment-map.json`. "Let's work with what we have and note where our plan is incomplete. Please post comments on relevant issues for unfinished work, or post jobs to design unfinished parts."

This job runs after the fixer job `endojs-endo-but-for-bots-pr1336-fix-review-5307103246`, which adds every tool the daemon already provides and lists the gaps in its PR replies.

1. Inventory the gaps: the confined-application makers above, plus any follow/streaming or glorp capability the fixer could not bind because the daemon lacks it. For each gap, say what the daemon, the compartment-mapper, and `@endo/platform` already provide, and what is missing.
2. Search endojs/endo-but-for-bots issues for the relevant tracking issues. Post a comment on each, as the bot, recording the unfinished work (fully qualified cross-repo links). File a new issue where none exists.
3. Write a design in endojs/endo-but-for-bots `designs/` for the missing makers and their MCP tool projection. Follow the repo's designs conventions and the garden's open-questions carve-out. If the design needs further separable design, post follow-up design jobs.
