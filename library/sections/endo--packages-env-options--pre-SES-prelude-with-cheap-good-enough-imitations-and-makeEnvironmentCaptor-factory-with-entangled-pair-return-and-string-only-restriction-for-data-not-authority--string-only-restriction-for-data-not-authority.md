---
title: §String-only-restriction-for-data-not-authority
source: endo packages/env-options/{src/env-options.js,README.md,index.js}
source-slug: endo--packages-env-options
ingest-cycle: 207
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-init-and-lockdown (cycle 183: SES bootstrap that env-options serves; ses lockdown reads environment via makeEnvironmentCaptor)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling; env-options also avoids @endo/ses-ava and any SES-dependent imports)
  - endo--packages-immutable-arraybuffer (cycle 201: §capture-before-scuttled sibling — env-options destructures globalThis intrinsics at module load with named comment)
  - endo--packages-evasive-transform (cycle 205: §source-transform sibling — both packages serve SES bootstrap layer)
  - endo--packages-panic (cycle 197: §ponyfill-vs-shim distinction sibling; env-options is more like a shim that imitates SES utilities pre-SES)
keywords:
  - pre-SES-prelude with cheap good-enough imitations
  - named end-prelude marker (`// end prelude`)
  - cannot-depend-on-SES discipline
  - makeEnvironmentCaptor factory with entangled-pair return
  - getCapturedEnvironmentOptionNames as diagnostic surface
  - three-tier API (getEnvironmentOption / getEnvironmentOptionsList / environmentOptionsListHas)
  - optOtherValues exhaustive allowed-strings list (throws on unrecognized)
  - default-binding-via-makeEnvironmentCaptor(localThis, true) for simple-case
  - string-only-restriction-for-data-not-authority (named in README)
  - three-namespace-parameterization-frame in README (global / import / host hooks)
  - compat-note-pointing-to-existing-issue (Agoric/agoric-sdk#8096 for DEBUG colon-split)
  - test-migration-note (tests moved to @endo/ses-ava to reduce cyclic dependencies)
  - SES-Lockdown-warns-named-environment-variables (example in README)
  - localThis-aliased-globalThis with eslint-disable
  - destructure-intrinsics-at-module-load (Object/Reflect/Array/String/JSON/Error)
  - uncurryThis via Reflect.apply (different shape than cycle 199 trampoline's bind.bind.bind.call)
  - Node-process-env-precedent for option lookup
  - dropNames parameter for simple-vs-tracking-mode
  - cycle 207 chat-lane
  - twenty-second-member of small-files-with-large-knowledge-density family
  - forty-first consecutive designs/chat alternation cycle 166-207
parent: endo--packages-env-options--pre-SES-prelude-with-cheap-good-enough-imitations-and-makeEnvironmentCaptor-factory-with-entangled-pair-return-and-string-only-restriction-for-data-not-authority
---

```js
typeof optionValue === 'string' ||
  Fail`Environment option named ${q(optionName)}, if present, must have a corresponding string value, got ${q(optionValue)}`;
```

The README names this as §a-security-constraint:

> In either case, reflecting Unix environment variable expectations, the resulting setting must be a string. This restriction also helps ensure that this channel is used only to pass data, not authority beyond the ability to read this global state.

§Strings-can't-carry-capabilities. §If-an-environment-variable-could-be-an-object, §the-environment-could-be-a-back-channel-for-authority-transfer. §The-string-only-restriction is §a-named-security-invariant.

§Borrowable-pattern: §string-only-restriction-for-data-not-authority as §a-named-security-invariant for §global-state-readers.

§Sibling-pattern to cycle 197 panic's §default-erroneous-exit + no-ambient-normal-exit asymmetry (both designs §name-the-security-rationale-for-an-API-restriction) and cycle 196 endoclaw's §object-capability-vs-ambient-authority distinction.
