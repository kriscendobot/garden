PR #1340 can enter the gauntlet: it is open, has not been superseded, and the need behind it still holds.

**Facts:** The PR is open and still a draft. Base is the frozen `llm-6726b0f`; head is `design/agent-confined-application-makers` @ `f871ea6737`. It adds a single file, `designs/agent-confined-application-makers.md` (263 lines). Tracking issue #1339 is open.

Deciding question: Has `llm` gained its own makers for confined applications (a bundle, archive or tree maker for hosts, guests or MCP) or a design that replaces this one, or has the maintainer abandoned the request this design answers?

Evidence:
- **The need is current.** The request came from a maintainer review comment on #1336, which merged 2026-09-25. Today (2026-09-30, 20:44–20:49Z) kriskowal left a changes-requested review ("rsvp") with five inline comments. All five steer the design's direction (hoisted mode for mounts, keep every option reachable, live tree references, guests may make guests, check what has changed on `llm`). None of them asks to drop or close it.
- **The bot has already answered the review.** At 21:09Z the bot replied to every comment, citing `f871ea6737`, and turned the four open questions into decisions.
- **Nothing on `llm` displaces it.** A code search found no `makeFromBundle`, `makeTreeReadPowers` or `agent-confined-application-makers` in the repo. However, GitHub code search normally covers only the default branch, so this is weak evidence about `llm`. The stronger evidence: `llm` is 143 commits past the frozen base, and none of their titles touches makers, `makeFrom*`, or confined applications. The only matches were two #713 daemon fix commits whose titles use "bundle" in another sense. The `designs/` listing on `llm` has only prior-art docs (`daemon-make-archive.md`, `ARCHIVE.md`, `platform-range-and-tree-reads.md`), which the PR builds on rather than being replaced by.
- **One nearby change is already handled.** Guests inviting guests (`EndoGuest.invite`/`accept`) has landed on `llm`, but it only narrows scope. The PR now marks that part out of scope.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170590 cached reads)
- Output: 1619 tokens
- Cost: $0.414602
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
