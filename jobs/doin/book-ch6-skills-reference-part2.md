---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Garden book, chapter 6 part 2: Skills reference (33 skills)

This is a continuation of job book-ch6 (orchestration garden-book-orch). APPEND to journal/projects/garden-book/ch6-skills-reference.md (land via scripts/jobs/land-journal-edit.sh with --base-blob; whole-file semantics, so read the tip and pass tip-plus-your-sections). Follow the existing entry shape exactly (### `name`, Source link ../../skills/<name>/SKILL.md, Purpose / When it's used / Key mechanics / Gotchas), house style (American spelling, no em dashes, no Latin abbreviations), and read each SKILL.md in full plus grep roles/ and scripts/jobs/ for who invokes it. Add numbered theme sections continuing from 6.5, add your rows to the skill index, and update the "Coverage status" block at the top to mark your skills covered.

Cover exactly these 33 skills (suggested sections: planning and design intake; testing, verification, and review analysis; the library and documentation; prose and code style; security and trust surfaces):

pr-dependency-graph, pr-dependency-topo-sort, design-dependency-walk, design-to-pr-pipeline, gap-revealing-build, ownership-map, sibling-family-sweep, build-vs-buy, adversarial-tests, saboteur-adversarial-review, coverage-driven-testing, regression-evidence, review-retrospective, review-queue-poll, ci-failure-classification-loop, context-library, library-lookup, journalism, self-improvement, liaison-reports, mermaid-validation, em-dash-style, no-latin-shorthand, no-comment-banners, relative-paths, rename-discipline, typist-friendly-code-points, changeset-discipline, american-english-normalization, botese-normalization, gricean-maxims, foreign-content-preclassification, fully-qualified-github-urls.

The remaining 34 skills belong to the parked job book-ch6-skills-reference-part3, which is blocked on this job and promotes automatically when it completes; do not cover them.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:39:32Z
