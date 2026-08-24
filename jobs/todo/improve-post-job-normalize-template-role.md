---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-job.sh
When a manual job uses the canonical `**Role: fixer.**`-style template but lacks leading `role:` metadata, normalize the known role into frontmatter (while preserving explicit metadata). The #475 review-fix job therefore received the generic 2400-second wall and deterministically overran; role metadata would select the fixer’s longer default budget automatically.
