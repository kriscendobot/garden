---
ts: 2026-06-17T20:05:10Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/17/195920Z-dispatch-liaison-04eddf.md
---

Boatman first-time ferry of bots#435 -> **new upstream endojs/endo#3308**, authored by Mark S. Miller (erights), complete (dispatch `04eddf`).

#3308 https://github.com/endojs/endo/pull/3308 (ready-for-review), branch `erights-immutable-arraybuffer-drop-pseudo-prototype`, head `1b8384d51`, base master a0f5d95ac, MERGEABLE. The 29-commit merged bot-side redesign restaged into a **tight 4-commit logical series**, ALL author `Mark S. Miller <erights@users.noreply.github.com>`, committer `Kris Kowal <kriskowal@kriskowal.com>`:
1. `925a74461` feat(immutable-arraybuffer)!: drop the pseudo-prototype; inherit from ArrayBuffer.prototype
2. `7d6f47d98` refactor(bytes): convert via the prototype method instead of the free function
3. `6d696e686` feat(ses): drop the %ImmutableArrayBufferPrototype% intrinsic and permits
4. `1b8384d51` fix(pass-style): align byteArray brand check with the new immutable prototype shape

Net diff byte-identical to source (4a04d078b..b1eceee2b); zero conflict (no touched file moved on master since the base). No Claude/Generated-with/Refs/Co-Authored trailers anywhere; fresh conventional-commit messages + pr-formation body, no fork-side refs. Garden-side cross-link CREATED on bots#435 (comment 4734718401). CI pending.

**Author-not-committer attribution** (the multi-author salvage shape) executed correctly: commits credit erights as author while kriskowal is committer/pusher. Maintainer-confirmed identity (erights@users.noreply.github.com) and structure (tight series).

**One flag:** `packages/immutable-arraybuffer/DESIGN.md` (carried verbatim from the merged source) contains an oblique allusion to a fork-side predecessor PR ("referenced in the comment whose identifier appears in the project log") - it names no fork number and is part of the reviewed source body, so the boatman left it under net-content-invariance. Harmless (no fork id leaked) but if the maintainer wants DESIGN.md fully fork-free, a one-line follow-up edit on #3308 (or the bot side) would scrub it.
