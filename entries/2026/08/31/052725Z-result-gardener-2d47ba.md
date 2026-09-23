---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-31T05:27:27Z
---
Answered the boot-layout compatibility question from https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5473710104 at https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5474132244.

Disposition: persistent stores and exported containers must survive compatible engine upgrades, so the `SIGN` compatibility contract should include callback-table and boot-derived slot layouts while `VERS` remains the wire-schema discriminator. The response calls for a documented signature-bump rule and a prior-layout refusal lock before release. No source change was requested by this attention job. Later persistence-reachability and SQLite coverage findings already have separate active jobs.

Self-improvement: corroborated the preflight hint against the actual PR timeline instead of treating the automated acknowledgment as resolution.
