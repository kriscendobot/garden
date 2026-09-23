---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 6e8ceb
dispatch_root: dispatches/fixer--6e8ceb
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP 0xpatrickdev's inline comment on PR #290
(https://github.com/endojs/endo-but-for-bots/pull/290#discussion_r3453444108,
comment id 3453444108, 2026-06-22T15:24:48Z):

> @kriscendobot please use these instead:
> https://github.com/endojs/endo-but-for-bots/blob/0458d1fbd5359bd2544b21e44eca5f4036ecdb3c/yarn.lock#L986-L1016

The referenced llm yarn.lock range names `@earendil-works/pi-agent-core`
and `@earendil-works/pi-ai` at version `^0.79.0` as the package set
the llm branch already consumes transitively. The PR's
`packages/lal/package.json:50-51` still lists
`@mariozechner/pi-agent-core` and `@mariozechner/pi-ai` at `^0.73.1`.

The user authorized this RSVP at 2026-06-22T23:05Z (the specific
comment URL was named in the dispatch directive). The second
patrickdev ask (vendoring restoration on comment 3453545144) was
NOT authorized and stays out of scope.

Fixer brief: swap the two `@mariozechner/pi-*` dependency entries
in `packages/lal/package.json` to `@earendil-works/pi-*` at the
versions llm uses, update any imports in `packages/lal/src/` that
named the old package, regenerate yarn.lock, run lal tests, force-
push.
