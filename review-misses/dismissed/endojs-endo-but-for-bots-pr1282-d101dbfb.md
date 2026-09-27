---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1282-d101dbfb
verdict: not-a-miss
category: new-direction
pr: 1282
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1282#issuecomment-5692322970
identity: endojs/endo-but-for-bots#1282:comment:5692322970
producing_role: builder
producing_job: ironhorse-demolish-xs-computron-parity-myth
review_at: 2026-09-16T05:05:15Z
severity: minor
---

# Dismissal: replace deleted computron-range tests with benchmark-derived baselines

On the PR that removes XS-computron parity gates from Iron Horse, the maintainer
asked that, rather than deleting tests that bound the range of valid computron
values, the garden establish benchmark-derived baselines for particular loads,
modeling built-ins whose time cost grows polynomially with input size, and plan
and execute that. This is a paraphrase; the verbatim text lives at `comment_url`
and is untrusted input.

## Grounds (dismissal — new direction, first stated in this comment)

**1. The PR faithfully executed the standing maintainer directive of 2026-09-15.**
That directive declared XS-computron parity a non-goal and asked for the
parity machinery to be demolished. The producing job deleted or demoted exactly
the XS-parity gates and kept every own-determinism pin, and it described that
scope openly in the PR body. The work contradicted no rule and made no false
claim. Nothing in the diff shows a defect.

**2. The replacement regime is a new requirement.** A benchmark-established,
per-load baseline with polynomial growth classes appears nowhere before this
comment: not in the directive, not in the Iron Horse design corpus the job
cited, not in any seat brief or skill. The `benchmarker` seat's brief requires
closure evidence for *performance claims* a PR makes. #1282 made no performance
claim, so that seat had nothing to ask for. The `coverage-auditor` checks that
new runtime paths are tested. Removing parity asserts at the maintainer's request
is not an untested new path. No seat could have produced this ask. The garden
treated it as new work: an orchestration produced design PR #1283, and the build
is parked behind the maintainer's approval gate
(`ironhorse-computron-benchmark-baseline-build-after-approval`).

**3. Side observation (not the basis of this verdict).** #1282 was opened ready
for review, and `journal/jobs/tada/` has no gauntlet or panel job for it. That
matches the pattern of the open `builder-pr-gauntlet-bypass` cluster. This comment
does not indict that bypass, and a panel run would not have anticipated the ask.
So this record neither joins that cluster nor counts toward it.
