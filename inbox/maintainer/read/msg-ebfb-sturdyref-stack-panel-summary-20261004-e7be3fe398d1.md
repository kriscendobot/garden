from_host: endolin-garden-ece02cb4
from: gardener:ebfb-sturdyref-stack-panel-summary-20261004
reply_to: ebfb-sturdyref-stack-panel-summary-20261004
msg_key: msg-ebfb-sturdyref-stack-panel-summary-20261004-e7be3fe398d1
notice_count: 1
first_seen: 2026-10-04T04:50:46Z
last_seen: 2026-10-04T04:50:51Z
sent_at: 2026-10-04T04:50:51Z
---
SturdyRef stack, layers 3/4/6/7 (endojs/endo-but-for-bots endojs/endo-but-for-bots#1392 → endojs/endo-but-for-bots#1393 → [endojs/endo-but-for-bots#1394 L5] → endojs/endo-but-for-bots#1396 → endojs/endo-but-for-bots#1397): open panel objections, for a merge decision.

All four PRs are drafts with CI green (33 checks, 0 failing). Each stopped at the 6-round budget. Panel coverage of the latest head: none of the four heads was re-paneled after its last fix push. The unreviewed changes are small and low-risk: endojs/endo-but-for-bots#1392 has 4 commits (re-entrancy guard, dead membrane branch removed, spaces-util render case, wording); endojs/endo-but-for-bots#1393 has about 70 non-test lines (SR type param on Passable, CapTP refuses to export a SturdyRef); endojs/endo-but-for-bots#1396 adds an 8-line JSDoc re-export; endojs/endo-but-for-bots#1397 is docs only.

Stack hygiene comes before any merge. Layers 1 and 2 (endojs/endo-but-for-bots#774, endojs/endo-but-for-bots#1391) are still drafts underneath, and the frozen bases have drifted. endojs/endo-but-for-bots#1392 sits on a stale snapshot of endojs/endo-but-for-bots#1391 (8 commits ahead, 2 rewritten). endojs/endo-but-for-bots#1393 and endojs/endo-but-for-bots#1394 each sit 22 commits behind their predecessor's head. endojs/endo-but-for-bots#1397's base is 25 commits behind endojs/endo-but-for-bots#1396 with 6 rewritten. Each layer needs a weave once the one below it lands.

endojs/endo-but-for-bots#1392 L3 pass-style: merge as is.
- Follow-up: no XS run of the brand check (the deferral is disclosed; this is repo-wide test:xs work).
- Follow-up: first-wins trust of a correctly shaped fake SturdyRef global installed before the shim. The shape checks bound it; it belongs to load-order/lockdown work.
- Follow-up (optional small fix): one line in the pass-style changeset warning TS users that adding 'sturdyRef' to PassStyle breaks exhaustive switches.
- Taste: property tests; the Proxy-global throw changes only the error message; rank-less type is spelled two ways (marshal/patterns).

endojs/endo-but-for-bots#1393 L4 marshal: merge after a retcon.
- Must-fix (mechanical): about 26 rework commits need regrouping (integrator). Do it together with the weave onto the landed endojs/endo-but-for-bots#1392, and drop the "Layer 4 of 9"/garden-arc text from the body at the same time.
- Follow-up: stricter $/& slot-index parsing (predates this PR, not exploitable today); XS run; spaces-util render tests.
- Taste: Pattern excludes SturdyRef only at the top level of the type (runtime rejects it at any depth).

endojs/endo-but-for-bots#1396 L6 captp construct: merge as is, after endojs/endo-but-for-bots#1394.
- Follow-up (cheap, optional before merge): CTP_DROP still accepts 'l-0' (inert today; one line).
- Follow-up: the locator is a bare Far with a hand-written argument check, where the house idiom is an exo with an interface guard; required fields can be read through the prototype chain (data is local, not peer-controlled); isByteArray uses instanceof.
- Taste: SturdyRefData names different shapes in captp and ocapn; extra tests; body length.

endojs/endo-but-for-bots#1397 L7 ocapn enliven: merge as is.
- The only must-fix from the last round (NonceLocator doc claiming "printable ASCII") was fixed in the docs-only head commit.
- Follow-up: mint-time byte aliasing (makeSturdyRef keeps the caller's array; predates this PR); string secrets enliven at home but can't cross the wire for non-ASCII (predates this PR); lookupSecretBytes thaw path is unverified on XS (disclosed); add a comment on the narrow RangeError catch.
- Taste: async wrapper, naming, bare Error.

Which layers can land first: endojs/endo-but-for-bots#1392 lands first, as soon as endojs/endo-but-for-bots#774 and endojs/endo-but-for-bots#1391 land. endojs/endo-but-for-bots#1393 follows after the retcon and weave. endojs/endo-but-for-bots#1396 and endojs/endo-but-for-bots#1397 have no code blockers, but they wait on endojs/endo-but-for-bots#1394 (L5, already un-drafted). No layer needs a redesign, and none needs another full panel; a scoped re-panel of only the post-panel deltas would be optional. No PR was touched and no gauntlet was staged.
