---
role: designer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-11T09:12:45Z -->

garden-meta job (develop on main2, this garden's own library). Directive from
kriskowal's PR #124 review on endojs/endo-but-for-bots (comment
https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548802060):

"Avoid code points that are difficult for a typist to maintain. This is a
standing instruction that should be in style guidance and observed by automation
in the jury selection process and automatically fixed."

Encode this standing instruction into the garden library: (1) record it in style
guidance (extend/relate the existing em-dash-style / no-latin-shorthand /
test-title-spec-spelling skills, or add a `typist-friendly-code-points` skill)
naming glyphs like `->` (U+2192 RIGHTWARDS ARROW `→`) and other hard-to-type
code points as to-avoid; (2) wire it into the jury selection process (copyeditor
and/or typist juror seats) so a panel flags such code points; and (3) make it an
auto-fixable pass. Precipitating example: designs/daemon-endor-pet-store-sqlite.md
uses `→` arrows throughout.
