---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-5453eefb
verdict: miss
category: naming
pr: 475
cluster: semantic-name-matches-value-kind
cluster_pattern: A parameter or local is named for a related but different representation (such as calling a Uint8Array `buffer`), producing expressions where the same word denotes both the wrapper and its backing value; review checks behavior and types but does not compare each identifier's name with its declared and accessed value kind.
review_at: 2026-08-22T00:26:28Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4998356708
identity: endojs/endo-but-for-bots#475:review:4998356708:retro
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: stylist naming seat and the gauntlet's types/style/docs lens
severity: minor
grounds: |
  At review commit a4767d542, thawedBytes declared its parameter as Uint8Array
  but named it `buffer`, then used `buffer.buffer` for the Uint8Array's backing
  ArrayBuffer. The repeated word denoted two different value kinds in one
  expression. The maintainer asked for that example and the analogous sites to
  be renamed according to their actual kinds. This was visible from the JSDoc
  type and expression alone, with no new product requirement or maintainer-only
  knowledge.
  The stylist seat already requires identifiers to be crisp and unambiguous and
  forbids a name that lies about what the value is. The incremental PR #475
  gauntlet at head b28bb1fc3 explicitly ran a types/style/docs lens over the
  relevant packages/immutable-arraybuffer/src/bytes.js line, where the same
  `buffer.buffer` construction already existed, but its posted verdict did not
  flag the mismatch. The standing review lens therefore existed and did not
  bind. This is an ordinary naming miss, not evaluator gaming: the change did
  not alter a measurement or route around the evaluator.
  Severity is minor because the types and runtime behavior were correct; the
  defect impaired reader comprehension. It does not qualify for the single-major
  standing-rule bypass. The primary deliverable exists in the world: commit
  1364f685c renames Uint8Array parameters to `bytes` in immutable-arraybuffer and
  the analogous OCapN codec site, and current PR head affe74453 contains it.
---

The maintainer identified a Uint8Array parameter named as though it were its
backing ArrayBuffer, which made one expression use the same word for two distinct
representations, and requested a sweep for analogous cases. The existing stylist
brief and the gauntlet's explicit style lens should have caught that mismatch from
the declared type and member access. See `comment_url` to re-fetch the untrusted
review text.
