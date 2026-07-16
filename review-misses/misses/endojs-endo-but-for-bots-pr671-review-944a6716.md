---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr671-review-944a6716
verdict: miss
category: style-convention
pr: 671
cluster: named-imports-over-namespace
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/671#discussion_r3584311079
identity: endojs/endo-but-for-bots#671:review:4700663722
producing_role: builder
producing_job: gauntlet-endo-but-for-bots-pr671-endo-registry-capability
missed_by: stylist / purist — and a pre-push lint-style gate (absent)
severity: minor
---

# Review-miss: freshly-added Node-builtin imports missing the `node:` protocol prefix

On the EndoRegistry-capability PR (#671), the maintainer's review
(`pullrequestreview-4700663722`) left an inline note (see `comment_url` for the
verbatim text) that the newly-added builtin imports in
`packages/daemon/src/bus-daemon-node.js` — `crypto` and the diff's new `zlib` —
should presumably all carry the `node:` builtin-protocol prefix. In paraphrase:
prefix Node-builtin specifiers with `node:`.

## Grounds

**Why this is a miss, not new direction.** This is the second convention already
bundled into the `named-imports-over-namespace` cluster (its pattern line names
"the `node:` builtin-protocol prefix" explicitly), and it is the same shape the
#615 member (`330a01ca`) was recorded under: a **generic, pre-existing,
mechanizable code-hygiene convention** on freshly-authored implementation code.
The `node:` prefix is deterministic (lintable, one correct answer) and is
established Endo-wide house style — by the discriminator's test, *any
Endo-experienced reviewer would have flagged it.* The 19-seat code panel ran over
exactly this diff (the gauntlet `gauntlet-endo-but-for-bots-pr671-endo-registry-capability`,
which added the `zlib` import at this perimeter) and its formal review did not
raise the missing prefix. That makes it a review-process miss on the sensing side.

**Why it is nonetheless not yet enforceable — the gap (encode-first).** As the
#615 record already established, a grep across every juror seat brief and every
skill for named-import / `import *` / `node:` returns nothing: the review
apparatus carries **no encoded rule** for import shape or the `node:` prefix. The
`stylist`/`purist` seats hold nothing on import specifiers, and there is no
lint-style pre-push gate. So this is an encode-the-rule-first situation, not a
sense-and-correct failure against a rule that already bound.

**What in this review is NOT this miss (kept out of the record deliberately).**
The review's *body* asks for a minimum-version-selection regression test (that
the MVS walk is insensitive to new transitive-dependency versions until a direct
dependency upgrades). That is **not** a review miss: the panel *precisely sensed
and articulated* exactly this coverage — the follow-up ledger
`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--671.md` records
"Semver / MVS test-coverage expansion (property-based)" sourced from the
`corner-prober` + `fast-checker` seats (Round 1), with the specific fast-check
property list. The maintainer is pulling one such test from `follow-up` to
must-fix on an explicitly-staged M3 reference milestone — a staging/scope call the
maintainer owns, first stated as blocking in this review; the review demonstrably
caught the gap. The review's other inline asks — capture `registryPowers` at top
scope rather than qualifying powers as `node`-specific, question the
`registry-node-powers.js` stub, rename/consolidate `registry-user.js`, normalize
`Buffer` to `Uint8Array` at the Node bindings, dedup the `gunzipBuffer` helper,
and post a foreman-promotable follow-up plan — are **architecture / platform-
boundary design directions on novel module structure**, owned by the primary
fixer loop (new-direction), not review-process misses.

**Severity: minor.** A missing `node:` prefix is import hygiene / legibility, not
a behavioral defect or a capability leak. Value is reviewer clarity and house
consistency.
