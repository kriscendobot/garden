---
kind: result
role: fixer
host: endolin-garden2-5bcdff64
at: 2026-09-12T04:50:46Z
---
Scribe seat, code panel on kriscendobot/minion.town#100 (dispatch
`minion-town-pr69-followup-hardening`; head `eaff0585`, base `13ef072`, diff
`HEAD~1...HEAD`). Verdict: request-changes.

Surfaces walked: PR #100's own comments/reviews (all three endpoints empty — a
first-round draft with one commit), the dispatching job body's six numbered
items, and the parent PR #69's review threads, whose deferrals this PR carries.

Note-this / directive asks and their closure state:

- `#discussion_r3939501084` (kriskowal, #69: "We will need to retire
  `storeIdentifier` and `identify` on Guest agent facets ... Please fix. Above
  and below. Search this change for similar opportunities") -> CLOSED on-thread.
  Reply `#discussion_r3995015734` posts the sweep disposition ("declined for
  now") and names PR #100; the same disposition is restated in #100's body.
  Correct closure shape: the record lives where the ask lives.
- `#discussion_r3938944656` ("How is this not a pet name?") -> CLOSED in #69 by
  `#discussion_r3939467722` plus the `powerName` rename. Not #100's work.
- Job item 6 (post the sweep result / decline note) -> CLOSED, same reply.
- Job's "Maintainer question (do not act without an answer)" on renaming the
  public MCP parameter `confirmPublicBuiltIn` -> CLOSED as a gardener/maintainer
  message: `inbox/maintainer/unread/msg-minion-town-pr69-followup-hardening-6a04ef086ece.md`
  (2026-09-12T03:44Z) states the question, the options, and that work proceeds
  meanwhile; restated in the PR body. Not renamed unilaterally, as directed.
- Completion-summary surface -> CLEAN this round. No directive-responding push
  has landed on #100, and the PR body carries the SHA-level account, the two
  declines with reasons, and verification status (370 passed / 5 skipped,
  typecheck clean). The PR body's claim that the daemon-side owner-conflict
  rollback branch is "already covered" is accurate
  (`test/gateway/daemon-site-registry.test.ts:519`, asserting
  `rollbackRegistration` at :536).

Open (findings raised):

1. The PR body asserts the two live-daemon residuals (job item 2's operator-cap
   `E(sites).directory(id)` -> `lookup('front')` anchor; job item 4's B1 ordinary
   pet-name publish) are "flagged for a follow-up done on a host with
   `ENDO_CHECKOUT`", but no carrier exists: nothing in `jobs/plan/` or
   `jobs/todo/`, and minion.town's open issues are #74 and #65, both unrelated.
   #69 set the precedent by naming a durable job (this one) in its summary.
2. The residuals and the new register-anchoring invariant are absent from
   `designs/clip-ocap-synthesis.md` § 9 ("Deferred / open residuals", "Units 4-5
   landed"), this repo's living record — the repo has no CLAUDE.md/AGENTS.md, so
   § 9 is the standing-orders surface. `4e5b982`, `ddb13cb` and `754c552` each
   updated it in the same commit; #100 touches no design file.
3. `test/gateway/property-hardening.test.ts` embeds two literal NUL bytes
   (lines 64-65, the `assertPowerName` NUL cases), so git classifies the file as
   binary (`git diff --numstat` -> `- -`) and GitHub's `pulls/100/files` reports
   `additions=0, patch=ABSENT`. The centerpiece evidence for job item 3 is
   unreadable in the PR diff, to this panel, to the maintainer, and to any later
   `git log -p` / `git blame`. `"a\0b"` / `"\0"` escapes keep it textual.

Self-improvement: the seat's brief frames the primary surface as maintainer
"note this" comments on the PR under review. #100 had none — it is a
deferred-findings follow-up whose enumerable asks live in the dispatching job
body and the PARENT PR's threads. Reading both is what surfaced every real
closure item here, and it is worth naming in `roles/jurors/scribe/AGENT.md` as an
explicit third primary surface. Second: when a repo has no CLAUDE.md/AGENTS.md,
the knowledge-capture target is the design doc the surface's prior commits
actually edited; `git log --stat` over the touched sources identifies it
mechanically.
