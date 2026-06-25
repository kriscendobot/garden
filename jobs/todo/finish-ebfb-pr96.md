# Finish endo-but-for-bots #96 implementation as designed

Maintainer directive on PR #96 (kriskowal, 2026-06-24T20:36Z):
"@kriscendobot Please finish this implementation as designed. I see a comment but
not the corresponding code changes." —
https://github.com/endojs/endo-but-for-bots/pull/96#issuecomment-4793406283

Posted directly by the liaison (the autonomous PR-comment watcher is still being
built). The comment has been reactji-acknowledged (👀 by kriscendobot).

Wear the **builder** role (`roles/builder/AGENT.md`; escalate to fixer detail as
needed). Repo: `endojs/endo-but-for-bots`, PR **#96**.

## Task

The maintainer observes that #96 contains a **comment but not the corresponding
code changes** — i.e. an implementation that was described/stubbed/commented but
not actually written. Read PR #96, its governing **design** (the design doc the PR
implements; trace it from the PR body / linked design under `designs/` on the
relevant branch), and the diff, then **finish the implementation as designed**:

- Find the gap the maintainer flagged: a code comment / TODO / placeholder / prose
  note that stands in for unwritten code, or a designed behavior with no
  implementation. Implement it faithfully to the design.
- Add/extend tests to cover the now-implemented behavior (coverage-driven).
- Keep to the design's intent; if the design is ambiguous or the "finish" requires
  a decision the design does not settle, surface it rather than guessing.
- Commit and push to #96's branch (bot identity; bot-fork PR — no identity switch).
  Reply on the PR summarizing what was finished (standing authorization permits
  commenting).

## After — continue the chain

On success, post `shepherd-ebfb-pr96` to drive CI to green if the change is
non-trivial.

## Definition of done

#96's designed-but-unimplemented code written and tested, pushed to its branch
under the bot identity, with a summary reply on the PR and a shepherd follow-up if
warranted. Report the head SHA and what was finished. If the design is ambiguous or
you cannot locate the intended change, report precisely rather than claiming
completion.

Posted by the liaison on behalf of the maintainer.

