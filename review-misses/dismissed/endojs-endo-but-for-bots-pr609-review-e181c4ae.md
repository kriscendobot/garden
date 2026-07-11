---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr609-review-e181c4ae
verdict: not-a-miss
category: new-direction
pr: 609
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/609#pullrequestreview-4673457078
identity: endojs/endo-but-for-bots#609:review:4673457078:retro
producing_role: none-maintainer-convention-directive
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) submitted review 4673457078 on PR
  #609 with an empty body and exactly one inline comment on the
  interval-scheduler's imperative Interval.cancel() method. The comment carried
  two directives: (1) rewrite cancellation to take a `cancelled` Promise<never>
  argument threaded into the maker (the caller keeps the reject handle and the
  resource tears itself down via cancelled.catch), rather than exposing an
  imperative cancel() method on the returned facet; and (2) "note it in the
  designer's standing instructions." This retro judges whether the garden REVIEW
  PROCESS should have anticipated this feedback and concludes it could not have,
  for a dispositive reason: at review time the pattern was NOT a documented
  garden convention anywhere — not in a juror seat brief, not in a skill, not in
  a COMMON.md norm, not in any standing instruction. Verified by grep over
  roles/ and skills/: the ONLY occurrence of the `cancelled` Promise<never>
  cancellation pattern in the garden library is at roles/designer/AGENT.md:40,
  and that line was ADDED by the PRIMARY loop of THIS review (job
  endojs-endo-but-for-bots-pr609-review-e181c4ae), its own grounds citing
  "Maintainer directive, endojs/endo-but-for-bots#609." The maintainer's second
  directive — "note it in the designer's standing instructions" — is the
  maintainer ESTABLISHING a new convention going forward, definitionally a
  first-stated requirement rather than a violated rule that failed to bind. The
  skill's discriminator is explicit: a miss is a convention "the panel
  demonstrably knows because it is written in a seat brief, a skill, or a
  standing instruction"; a not-a-miss is "new direction, taste, a scope change,
  or a requirement first stated in the comment itself." This is squarely the
  latter. The pattern is moreover a design-level architectural idiom about the
  API shape of cancellable capabilities (subscriptions, timers, connections),
  routed to the DESIGNER's brief, not a code-panel defect: the code panel
  reviews correctness and mechanical style, not undocumented capability-API
  taste that had never been codified. Even the endo-daemon "standard shape" the
  maintainer cites (context.cancelled, delay(ms, cancelled),
  makeDaemonicGoPowers({ cancelled })) is a deep project idiom no general
  garden panel seat is briefed to enforce. The PR history confirms the garden
  handled the review correctly: the primary loop applied the Promise<never>
  refactor to interval-scheduler.js/types.d.ts/tests (commit aa0dff2908),
  recorded the convention into the designer's standing instructions
  (4af93d35f), and replied on the inline thread. Recorded as a durable
  dismissal so the same review is never re-litigated. No cluster minted; no
  improvement dispatched. NOTE: this is a DIFFERENT review from the sibling
  #609 review 4675177693 (primary base ...4a711718), whose inline `Cmd`
  abbreviation miss was already recorded and clustered into
  avoid-name-abbreviations; that verdict is unaffected by this one.
---

# Dismissal: endo-but-for-bots #609 review 4673457078 (retro)

kriskowal (the repo owner) left one inline comment on the interval-scheduler's
imperative Interval.cancel() method, asking to (1) rewrite cancellation as a
`cancelled` Promise<never> argument threaded into the maker (caller keeps the
reject handle; the resource tears itself down via cancelled.catch) instead of an
imperative cancel() method, and (2) note this preference in the designer's
standing instructions.

Not a garden review-process miss. At review time the pattern was documented
nowhere in the garden — no seat brief, skill, COMMON.md norm, or standing
instruction held it (verified by grep: the sole occurrence in the library,
roles/designer/AGENT.md:40, was WRITTEN by this review's own primary loop). The
maintainer's "note it in the designer's standing instructions" is the act of
ESTABLISHING a new convention forward, i.e. a first-stated requirement, which the
skill's discriminator classifies as new direction rather than a violated rule
that failed to bind. It is additionally a design-level API-shape idiom for
cancellable capabilities, routed to the designer's brief, not a code-panel
defect. The garden handled the review correctly: the primary loop applied the
Promise<never> refactor, recorded the convention into the designer's brief, and
replied on the thread. Distinct from the sibling #609 review 4675177693 whose
`Cmd`-abbreviation inline was already clustered. See comment_url for the verbatim
review. No cluster; no improvement dispatched.
