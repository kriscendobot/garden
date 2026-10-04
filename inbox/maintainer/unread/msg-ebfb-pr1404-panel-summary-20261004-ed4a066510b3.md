from_host: endolin-garden-ece02cb4
from: gardener:ebfb-pr1404-panel-summary-20261004
reply_to: ebfb-pr1404-panel-summary-20261004
msg_key: msg-ebfb-pr1404-panel-summary-20261004-ed4a066510b3
notice_count: 1
first_seen: 2026-10-04T04:53:33Z
last_seen: 2026-10-04T04:53:35Z
sent_at: 2026-10-04T04:53:35Z
---
endojs/endo-but-for-bots#1404 (guest neither produces nor consumes identifiers/locators): merge-decision summary

State: draft, MERGEABLE on frozen base llm-80054c3. Head f1db6fff93. CI is GREEN on that head (all required legs pass; the ironhorse legs are skipped as unrelated). The gauntlet stopped at review-budget-reached after 6 rounds.

Panel coverage: the latest head has NO panel coverage. Round 6 (review 5400129834) reviewed 8c37912e9f. Fix round 6 then added 8 commits, +114/-67 in daemon/src/directory.js. That refactor is security-relevant: all six guest path ops now come from one makePathOperations walked through lookupGuestOwnHub. I read the diff and it matches the fix-round claims. One side effect nobody has reviewed: host readText/writeText through a path now reach the hub via amplifyNameHub, not lookupTailNameHub. That is consistent with host authority.

Round-6 must-fixes, after fix round 6:
- Closed in code, but no panel has re-reviewed them: the PR body headings and trim; guest remove/readText/maybeReadText/writeText refused through another guest (purist, wire-watcher, the real escalation, with a regression test); floot tool-registry locate moved to the host side, plus listMessages fromNames (migrator); floot rollback AggregateError (saboteur); the jaine channelName rename and its first AVA suite (stylist, integrator, prover); the interfaces.js comment (archivist).
- Still open:
  1. warden: guest move/copy through a reachable directory facet "recovers identify/storeIdentifier". Fix round 6 rebutted this instead of changing code. Its argument: the walk only reaches hubs the guest already names, the facet's own lookup/copy/move/remove/text methods reach the same entries, ids never leave the daemon, and copied-out values are narrowed again. A test was added to pin it. Class: taste/noise if you accept the rebuttal. I think it holds in ocap terms, since there's no new authority, only same-holder plumbing. Nobody has re-reviewed it, so it is your call.
  2. corner-prober: TOCTOU in fae ask(). The binding is now re-checked after the send, but a name that is rebound and then restored between the two checks still gets through. That gap is documented, and closing it needs send-by-formula-identity, which guests can't do by design. Class: follow-up-worthy. It's narrow, the actor is the model's own powers, and a real fix is a design question.

Should-fix / comment items from round 6, not addressed:
- breaker: guest-redaction namesForLocator wraps idFromLocator in try/catch but not reverseIdentify. If it ever throws, one bad correspondent breaks listMessages for the whole inbox. Class: follow-up-worthy (a one-line wrap, unreachable today).
- warden: guest reverseLookup unwraps a guest-supplied facet. It only answers a same-store name query. Follow-up-worthy.
- curator: fae SUBAGENTS.md interface sketch omits the new verify(name), and its "whole of the authority" claim is now inaccurate. Follow-up-worthy (docs).
- locksmith: confinement rests on "worker code cannot import guest-amplification.js", which no test asserts. Follow-up-worthy.
- corner-prober: the new mapCancelableIterator has no direct unit test. Follow-up-worthy.
- spec-keeper: GuestPathOperations is on the exported directory type with no guard. archivist: help.md arrow normalization. prover: claude-sandbox scratch-name cleanup isn't asserted. All taste/noise.

Maintainer decisions the PR body raises (not panel defects): (a) loadContent still fetches magnet ws= web seeds for the guest; withholding it is a one-line follow-up if you count it as an escape hatch. (b) This conflicts with the endojs/endo-but-for-bots#1332 Minion Town guest-locator federation design, which assumes guest invite/accept. (c) Remaining consumers (workflow, chat/spaces profiles, cli --as, docs) are deferred to job ebfb-guest-designation-consumers.

Bottom line: MERGE AS IS, provided you accept the warden rebuttal (item 1) and are fine deciding endojs/endo-but-for-bots#1332 / loadContent afterward. The real escalations the panel found across 6 rounds (copy/move/remove through another guest, floot locate breakage) are fixed and tested, and CI is green. The open items are hardening and docs, small enough for one follow-up fixer job (reverseIdentify wrap, SUBAGENTS.md verify, an import-boundary test, a mapCancelableIterator test). If you want the unreviewed directory.js refactor on f1db6fff93 seen by a panel before merge, a single targeted confirm round is the cheap option, not a redesign.
