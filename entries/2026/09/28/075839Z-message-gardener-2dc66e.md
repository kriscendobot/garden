---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-28T07:58:43Z
---
# Authorization record: Jev foreign-content pre-classification (autonomous)

Recording, in the monitoring-surface-widening pattern (CLAUDE.md § Monitoring
safety constraint), the maintainer authorization for wiring TypeSafe Jev into
an AUTONOMOUS flow: kriskowal, 2026-09-28, directive in job
`jev-preclassify-foreign-content-survey` — "establish a practice of using Jev
to classify suspicious external documents before ingesting them with a full
LLM agent. We should be watching for prompt injection attacks or mis-aligned
opinions."

Scope: Jev as a content pre-classifier on fetched foreign documents before
they enter an agent's context (first consumer: the scholar's fetch-source.sh
acquisitions). Implementation: scripts/jobs/classify-foreign-content.sh;
taxonomy/policy/authorization detail:
skills/foreign-content-preclassification/SKILL.md § Authorization; design
addendum: designs/typesafe-jev-classification.md (commit 1f4dc4b82e5 on
main2). Sending fetched text to TypeSafe rides the retention/training terms
the maintainer accepted in that design. The rejected autonomous-muster path
is NOT reopened. Follow-on surfaces posted as
jev-preclassify-botanist-release-notes and
jev-preclassify-trusted-sender-quoted-text.
