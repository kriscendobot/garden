The target comment is fully addressed. The larger 01:22Z directive is a separate comment with its own routing — I'll flag it in my report rather than pull it into this job's scope. Work complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #474, keyed to erights comment `4805614249` (2026-06-26T01:25:28Z).

**What the directive contained (two acknowledgments of my prior ferry summary):**
1. **`getThis`** — erights agreed with keeping the function-keyword form ("Kudos"). No action required.
2. **`'Program:exit'`** — one actual question: *"What is the rationale for that [`object-shorthand` `avoidQuotes`] lint rule?"*

**What I did:**
- Treated the comment body as untrusted data; the only actionable item was the informational question.
- Grounded the answer in the repo's real config: root `package.json` extends `eslint-config-airbnb-base@^15`, which sets `object-shorthand: ['error', 'always', { ignoreConstructors: false, avoidQuotes: true }]`. Confirmed `harden-exports.js:149` is `'Program:exit': () => {`.
- Posted a reply as `kriscendobot` answering the question: https://github.com/endojs/endo-but-for-bots/pull/474#issuecomment-4805629826. The reply explains `avoidQuotes` (forbids concise-method shorthand on quoted keys), gives the rationale (signal-separation: a quoted key reads as a string-keyed map entry, not a class-like method; plus within-object consistency), stresses it's a pure style rule, and ties it back to why the arrow `'Program:exit': () => {}` is the one spelling satisfying both `avoidQuotes` and the function-keyword retirement. Offered to open a follow-up if relaxing `avoidQuotes` for ESLint visitor objects is preferred.

**Changes:** none to code — informational PR reply only.

**Follow-up (not this job's scope — flagging for the liaison/foreman):**
- A **separate, larger directive** arrived ~3 min earlier from erights (comment 2026-06-26T01:22:08Z) requesting real code work *in this PR*: (a) rename `baseHandledPromise` → `BaseHandledPromise` in `eventual-send/src/handled-promise.js` **and find all other lowercase-initial identifiers that name `new`-intended functions**; (b) add "See `function-keyword.md`" comments at the non-constructor exception sites; (c) apply the `defineProperty(..., getOwnPropertyDescriptors(patches))` descriptor form (or explain in-thread why it's problematic rather than silently using `Object.assign`); (d) start a *separate* PR for `harden(evadeCensorSync)` (erights also pinged @kriskowal asking whether another PR already covers it). That comment is keyed to a different source and should have/needs its own job — I did not find a matching `todo/`/`doin/` entry on a quick check. Recommend the liaison/foreman confirm a job exists for it, since per standing guidance maintainer directives must be reliably tracked, not silently dropped.
