# #178: answer the Tor-port question, then conduct to the `llm` branch (maintainer APPROVED)

Maintainer APPROVED **endojs/endo-but-for-bots #178** (`refactor(daemon): introduce locator
scheme with @-delimited connection hints`, head `refactor/daemon-locator-v2`, NOT draft) with
review `4575958591` (kriskowal, 2026-06-26T00:31Z): body **"Please conduct to the llm branch."**
plus one inline question. Bot repo, bot identity, in scope. Address both, in order.

## 1. Inline question (resolve first)

`designs/daemon-locator-reference.md:44` (kriskowal): **"Do Tor addresses include a port
number?"** Confirm the fact and reply on the thread. (For reference: **Tor v3 `.onion`
addresses are host-only** — a 56-char base32 service id + `.onion`, with **no port** in the
address; the port is carried separately at the connection/SOCKS layer.) If the locator design
doc conflates `host:port` for Tor hints or otherwise needs correcting in light of this,
**amend `designs/daemon-locator-reference.md`** to state how a Tor connection hint carries its
port (separately / default), then reply citing the fixing SHA. If the doc is already correct,
just reply with the answer. Do not block the merge on a trivial clarification.

## 2. Conduct to the `llm` branch

Then **conduct #178 to the `llm` branch** — merge it with **`llm` as the target/base branch**
(the maintainer's explicit instruction), NOT master. Wear the **conductor** role; follow the
conductor's own merge-method norm (do not let this prompt dictate the method). Confirm mergeable
+ green before merging.

## Close-out

Post a **top-level summary comment** on #178 (the Tor-port answer + any doc amendment SHA, and the
conduct-to-llm result) per the standing PR-summary-comment norm.

## Definition of done

#178's Tor-port question answered on the thread (doc amended only if warranted), then #178
conducted to the **`llm`** branch, with a top-level summary comment. Report the merge result and
the Tor-port answer. If it is not mergeable/green, report why instead of forcing it.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 60
  claimed_at: 2026-06-26T00:45:25Z
