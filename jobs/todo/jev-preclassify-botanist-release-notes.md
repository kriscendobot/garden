---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Wire Jev pre-classification into the botanist's foreign-content reads

Follow-on from `jev-preclassify-foreign-content-survey` (maintainer directive
kriskowal 2026-09-28; gate landed as `scripts/jobs/classify-foreign-content.sh`,
skill `skills/foreign-content-preclassification/SKILL.md`, commit 1f4dc4b82e5).

The botanist (`roles/botanist/AGENT.md`) reads upstream package source,
changelogs, release notes, and CVE-feed text for every dependabot PR — all
foreign-authored content that enters the reviewing agent's context with no
gate. Survey the botanist's procedure steps 3-4 ("Read the source... pull the
new tag, read the changelog") and wire the pre-classification gate in front of
the *prose* surfaces (changelogs, release notes, advisories, package READMEs)
per the skill's caller procedure: fetch to a file, classify, apply the
disposition (halt_and_escalate = do not read; surface in the verdict comment
and to the maintainer). Source-code diffs read as code are a different surface
— decide and document whether to gate them or exempt them with a rationale, as
`roles/scholar/AGENT.md` exempts gated-repo bare-clone reads. Update
`roles/botanist/AGENT.md` accordingly. Land on main2 direct.
