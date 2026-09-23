---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr7-review-c543864f
verdict: not-a-miss
category: new-direction
pr: 7
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/7#pullrequestreview-4724638414
identity: kriscendobot/minion.town#7:review:4724638414:retro
producing_role: builder
producing_job: minion-town-endo-root-host-bootstrap
severity: minor
---

# Dismissal: minion.town #7 review 4724638414 (retro)

kriskowal (the repo owner and maintainer) submitted a CHANGES_REQUESTED review on
PR #7 — a `feat(endo)` build adding the out-of-band root-host bootstrap +
guest→host promotion mechanism against the accepted `designs/mcp-endo-guest.md`.
The review body is EMPTY; it carries exactly two inline comments (paraphrased —
verbatim at `comment_url`):

1. On `src/endo/root-ctl.ts` — shorten the new CLI's name (`endo-root-ctl`) to
   `endoctl`.
2. On `src/endo/root-host-memory.ts` — move this file into the test directory
   under a leading-underscore helper name (`test/_root-host-memory.js`) to signal
   it is a test helper rather than shipped source.

**Grounds — not a review miss (both comments are maintainer taste/direction on
otherwise-correct, freshly-introduced artifacts; no standing convention bound at
authoring time).**

- *Comment 1 (CLI naming).* This is a subjective naming preference for a
  brand-new CLI the PR introduces. No juror-seat brief, skill, gate, or
  `roles/COMMON.md` / minion.town standing instruction prescribes a CLI naming
  shape, and nothing made `endo-root-ctl` wrong — it is a descriptive, spelled-out
  name. Notably it runs *opposite* to the one naming rule the garden does enforce
  (the `avoid-name-abbreviations` cluster / `spell-out-identifiers` gate, which
  pushes names to be spelled out in full): the maintainer here wants a *shorter*
  name, so even the standing naming check would not — and should not — have flagged
  it. A panel cannot anticipate a maintainer's specific preferred short form for a
  new tool; this is taste first stated in the comment.

- *Comment 2 (test-helper placement).* The author placed `root-host-memory.ts` in
  `src/endo/` and described it in the PR body and the build record as an in-memory
  "local-dev/test backend, mirrors the socket adapter's contract" — a legitimate,
  dual-use real backend, not merely a test fixture. The repo has **no established
  `test/_*.js` helper convention** to violate: every file under minion.town's
  `test/` is a `*.test.ts` (verified read-only against `main`), and the repo is
  TypeScript throughout, whereas the maintainer asks for a leading-underscore
  `.js`. The maintainer is *deciding the artifact's role* (this is a test helper,
  not a shipped backend) and importing the Endo-ecosystem `test/_` helper idiom
  into a repo that did not yet have it — a code-organization direction first stated
  in the comment, not a convention that bound at authoring time. No packager/curator
  seat brief mandates "in-memory backends must live under test/," and no panel ran
  against this project-repo build in any case (it was a direct ready-for-review
  build, not a gauntlet).

Same class as the prior minion.town dismissals: #3/#6 (approve-and-`conduct`
directives), #4 (rewrite-in-JS-against-the-repo's-bash-convention language
steer), and #8 (maintainer decisions answering a design doc's open questions).
In each, the maintainer redirects *already-correct work* on naming / language /
organization / scope taste, first stated in the comment — never work a panel got
wrong. The distinguishing test holds here too: neither comment names a defect,
spec breach, missed edge case, or standing convention that failed to bind.

**Boundary note (auditable calibration, not a miss).** Recorded as a durable
dismissal so this review is never re-litigated. No cluster minted; no threshold to
evaluate; no improvement job. (Process aside, out of the prosecutor's lane and left
for the mentor loop: the CHANGES_REQUESTED review landed at 17:07:55Z and the PR
merged at 17:10:16Z — ~2.5 min later — so the feedback went unaddressed on a closed
branch; that is a merge/review-timing machinery concern, not a review-anticipation
miss.)
