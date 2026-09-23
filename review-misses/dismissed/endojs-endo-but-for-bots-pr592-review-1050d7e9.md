---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr592-review-1050d7e9
verdict: not-a-miss
category: new-direction
pr: 592
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/592#discussion_r3525566890
identity: endojs/endo-but-for-bots#592:review:4631937541:retro
producing_role: builder
severity: minor
grounds: >
  kriskowal's single inline comment on the XS `watchDirectory` fallback in
  packages/daemon/src/bus-daemon-rust-xs-powers.js (paraphrased) asks the author
  to LEAVE A CODE COMMENT recording that, to increase the fidelity of the
  directory watcher here, the garden would need either to get a feature added
  upstream to cap-std or to start a fork of cap-std. This retro judges whether
  the garden review process should have anticipated the ask, and concludes it
  could not have. Grounded in the PR's actual history: #592 factored
  watchDirectory onto @endo/platform; the diff the comment sits on simply drops
  a no-op `cancel: () => {}` from the returned events object and returns `events`
  directly — a correct, intentional simplification, not a defect. The comment
  does not indict that change; it requests a NEW explanatory annotation about an
  inherent host-boundary limitation (cap-std, the crate the Rust XS powers use
  to reach the filesystem, exposes no capability-safe filesystem-watch
  primitive). That is a first-stated documentation/direction request rooted in
  the maintainer's own domain knowledge of cap-std's capability surface — not a
  bug, style violation, missed edge case, or a convention any seat or skill
  demonstrably knows and failed to bind. No review-cycle check could be expected
  to know that a specific downstream crate lacks a watch primitive and to demand
  the author document that fact. The primary loop (review-1050d7e9) already
  handled it correctly: it added the requested comment (c87cb975b) and replied
  on the thread. This is new direction (a first-stated doc request), not a
  garden review-process miss. Recorded as a durable dismissal so the same
  comment is never re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #592 review 4631937541 (retro)

On the XS `watchDirectory` fallback (packages/daemon/src/bus-daemon-rust-xs-powers.js),
where #592 removed a no-op `cancel` and returned the event stream directly, the
maintainer asked the author to add a code comment recording that raising the
watcher's fidelity would require an upstream cap-std feature or a fork of
cap-std. Not a garden review-process miss: the underlying diff is a correct,
intentional simplification, and the ask is a first-stated documentation request
grounded in the maintainer's own knowledge of cap-std's capability surface — no
seat, skill, or standing instruction demonstrably knows that a specific
downstream crate lacks a capability-safe filesystem-watch primitive and could
have flagged its omission. New direction, not a miss. The primary loop already
added the requested comment and replied on the thread. See comment_url for the
verbatim review.
