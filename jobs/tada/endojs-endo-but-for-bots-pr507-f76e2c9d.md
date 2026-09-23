Work complete. Scratch torn down (the remaining `pr507-voice-*` belongs to another job, not mine).

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #507 (kriskowal inline review comment r3479335508 on `designs/notifier-pubsub-migration.md`).

**Directive (treated as untrusted data):** the debouncer integration in `coalesceReader` would require accepting a timer, which is out of scope; remove it, and add a section on composing a timer subscription, since a timer is an I/O capability that must always be injected per the garden/endo ocap house rule.

**What I did** — one commit `cdf1d4eeb`, pushed to `design/notifier-pubsub-migration`:
- Removed the `debounceMs?: number` option from `coalesceReader`'s type signature and its mechanics bullet.
- Added a new top-level **"Composing a timer subscription"** section: timer-as-injected-I/O-capability rationale (with the maintainer's quote), the debounce-by-composition shape (`coalesceReader` owns the *what*, the injected timer owns the *when*), the observation that the producer side is already timer-injected via the samplers' `schedule(callback)`, and why composition beats a `debounceMs` option (clock-free, fake-timer-testable adapters).
- Threaded the change through the two downstream references that mentioned a "debounce window" (the consumer-side rationale and the "Overflow policy on the consumer" section).

**Communication:** replied on the inline review thread (r3479374296) and posted a top-level summary comment (issuecomment-4806701844), naming the head SHA, what changed, what was declined (nothing), and verification status. Both are authorized by the repo's standing authorizations.

**Verification:** design-doc-only change. Markdown style checked (sentence-per-line, no new over-length lines beyond pre-existing tables/headings, no Latin shorthand). No code/lint/type surface touched. `designs/README.md` needs no sync (it does not track this not-yet-merged design). PR stays DRAFT (design-stage; un-drafting is the maintainer's call).

**Follow-ups:** none. The implementation of `@endo/exo-pubsub`, when it happens, should carry the timer-by-composition pattern rather than a `debounceMs` parameter.

**Self-improvement:** nothing this time.
