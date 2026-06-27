<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-06-27T12:48:11Z -->

# follow-up PR: harden exported function literals (evasive-transform first)

Map: **build/design** → start a *separate* PR on endojs/endo-but-for-bots.

Origin: erights directive on endojs/endo-but-for-bots#474
(https://github.com/endojs/endo-but-for-bots/pull/474#issuecomment-4805600465),
bullet 4. erights: "agreed, not in this PR. Please start a separate PR with that
change." Attn @kriskowal was pinged on whether to do it and whether another PR
already covers it.

State at parking time (2026-06-26): no open PR on endojs/endo-but-for-bots or
endojs/endo covers this. The narrow change is `harden(evadeCensorSync)` at
packages/evasive-transform/src/index.js (evadeCensorSync line 65, evadeCensor
line 129 are exported arrow `const`s, currently un-hardened). erights framed the
better form as a trailing "harden-all-exported-literals" PR (repo-wide).

Gate (go-ahead): the maintainer (@kriskowal) must scope this before work runs —
narrow (just the two evasive-transform exports) vs repo-wide (harden every
exported function literal, which interacts with the `@endo/harden-exports`
eslint rule). erights authorized a separate PR; kriskowal scopes its breadth.

On promotion: dispatch a builder (or designer first if repo-wide) to open a new
DRAFT PR on endojs/endo-but-for-bots with the agreed scope, then run the gamut.
The authorization to open the cross-repo PR is carried by erights's directive
above.
