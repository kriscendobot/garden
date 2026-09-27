---
slug: filler-phrase-concision
category: style-convention
status: closed
count: 3
members:
  - endojs-endo-but-for-bots-pr825-review-18fde0da
  - endojs-endo-but-for-bots-pr1281-25caefdb
  - endojs-endo-but-for-bots-pr1304-review-96879182
prs: [825, 1281, 1304]
improvement_job: review-improve-filler-phrase-concision
improved_by: 7bd312a6379 roles/builder/AGENT.md, roles/fixer/AGENT.md, roles/jurors/pruner/AGENT.md, skills/panel-hints/probes/C-pruner.sh, scripts/jobs/gardening/pre-push-gates.sh, scripts/jobs/test/filler-phrase-concision-probe-test.sh
---






Garden-authored prose carries empty filler phrases the maintainer asks struck; no seat enforces concision on prose bodies.

**Threshold rationale:** Hold at the default floor: the cluster now contains two minor misses across two
distinct PRs, but K=2 is below the required K>=3 and no major-severity standing-rule
bypass applies. Do not dispatch a review-improve job. Independent remediation from
the #1281 parent directive is already landed at garden commit e21884be41: the
curated Botese grep prevents known phrases from passing silently, the thesaurus
seat supplies durable panel sensing, and the deslopper supplies the fix loop.

**Threshold rationale:** # Dispatch rationale: filler-phrase-concision

The default floor is met: count=3 across distinct PRs 825, 1281, and 1304. All
three are minor, but they share one review failure rather than a one-PR cascade:
bot-authored project prose made the reader spend attention on words that did not
add information, and the review cycle did not prune it.

Dispatch one improvement round. The existing Botese detector addresses known
stock phrases and caught the narrower #1281 recurrence, but it cannot catch the
#1304 shape, where a bespoke multi-line comment accurately narrates an obvious
standard idiom. Prevention must bind builders and fixers to the existing Gricean
authoring rule; sensing must extend the pruner's explicit scope to added code
comments and add a loose panel hint where the historical diff supports one.
