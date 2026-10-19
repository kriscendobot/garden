---
slug: botese-in-pr-metadata
category: style-convention
status: closed
count: 1
members:
  - endojs-endo-but-for-bots-pr1403-review-1cfc544e
prs: [1403]
improved_by: 78f9dacc938 scripts/jobs/gardening/seat-gate-thesaurus.sh, scripts/jobs/gardening/thesaurus-cliche-grep.sh, skills/botese-normalization/cliches.tsv, scripts/jobs/test/thesaurus-cliche-grep-test.sh
---


A Botese cliché (notably bare "seam") ships in a PR title or description because the thesaurus seat and its grep scanned only the diff, never the PR metadata.

**Threshold rationale:** Below the floor (count=1, one PR, minor, no severity bypass), so no review-improve job is dispatched. Remediation already landed outside this loop in garden commit 78f9dacc938: the thesaurus seat gate now feeds the live PR title and body into thesaurus-cliche-grep.sh as pr-metadata rows, with a metadata-only bare "seam" entry. Replaying the grep on #1403's original title and body flags both. The cluster is closed against that commit so a later post-fix miss counts as a recurrence.
