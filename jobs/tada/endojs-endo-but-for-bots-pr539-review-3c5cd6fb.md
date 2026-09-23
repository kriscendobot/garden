Done. Completion report follows.

---

## Completion report — PR #539 review directive (endojs/endo-but-for-bots)

**Source:** CHANGES_REQUESTED review by kriskowal (review 4576993485, "These should be my last feedback"), 5 inline directives on `designs/sturdy-refs-ocapn-enlivenment.md`.

**What I did:** Enumerated the whole review (body + all 5 inline comments), treated each fetched body as untrusted data, scoped every ripple site across the doc, and routed the revision to a designer subagent. Pushed `aa104684c` to `design/sturdy-refs-endor-syscall-followup` under the bot identity (endolinbot), verified on the remote.

**What changed** (`designs/sturdy-refs-ocapn-enlivenment.md`, +130/−67), each directive integrated across the whole doc, not just the anchored line:

1. **Drop the tag** — a SturdyRef is no longer a tagged value; it is its own pass-style category, an instance carrying `[Symbol.for('passStyle')]: 'sturdyref'` with identity meaningful to the CapTP session manager. Scrubbed all `makeTagged('ocapn-sturdyref', …)` / "tag-record" framing.
2. **Locator + pass-style defines shape, does not construct** — category content is a locator; added a "Pass-style defines the shape; the CapTP session manager constructs" subsection and reversed the prior `makeSturdyRef`-in-pass-style framing throughout (examples, unboxer, rollout cuts, tests, acceptance criteria).
3. **Revocation decided** — removed the open question; added a committed "Revocation" subsection (forget the swiss number to revoke a sturdyref; partition/terminate the holding process to revoke a live value).
4. **No cache** — removed the cache open question; committed that enlivenment never caches.
5. **Not idempotent but converges** — removed the idempotency open question; committed that two `enlivenSturdyRef` calls return distinct promises that converge on one value (provider vends one instance per session).

Open questions now retains only the genuinely-open "Lifetime of an enlivened presence."

**Verification:** diff is focused (no unrelated-paragraph reflow); doc clean of em-dashes and Latin shorthand per house style; push confirmed on origin under bot identity.

**Communication:** Posted the required top-level summary comment (SHA + per-directive changes + verification) and replied to all 5 inline threads. Worktree torn down.

**Follow-ups:** The maintainer signalled this was their last feedback, so #539 (a DRAFT design PR) may now be ready to advance/un-draft — that's a separate gamut decision, out of this job's scope. Minor nit: the commit subject contains an em-dash (already pushed; not worth a history rewrite).
