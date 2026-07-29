---
title: ShadowRealm explainer — the security triage: integrity yes, availability no, confidentiality partial
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/explainer.md
source_content_sha256: 4842a1efb89d6b281962be7db9f9b5d4b863bdc6f75137abfc5a44a78031eca9
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
ingested: 2026-07-29
ingested_by: scholar
topics: [capability-security, module-harmony]
status: current
---

Abstract: The explainer's own honest scoping of what ShadowRealm protects, stated in the vocabulary of Agoric's *taxonomy of security issues* essay and reduced to one line: **✅ integrity, ⛔️ availability, ⚠️ confidentiality**. Integrity holds, but only against programs that "might inadvertently step on each other's feet", writing to the same global variable; the worked example is Google AMP, where each vendor enhances its sub-app by running code in a ShadowRealm exposed to a well-defined API set. Availability is explicitly *not* protected, and the reason is the same design choice that makes the API useful: sharing a heap and a process is what allows synchronous communication, so code in a ShadowRealm can exhaust resources or over-allocate memory and prevent the incubator realm from proceeding (the worked example is a plugin doing heavy matrix computation that blocks the main UI thread even though its result is awaited asynchronously). Confidentiality cannot be fully guaranteed: side channels such as Meltdown and Spectre let code inside infer another realm's secrets from timing differences, and the APIs available inside can be used for fingerprinting. The constructive framing the explainer offers is that ShadowRealm is a **building block** toward confidentiality when combined with inescapable mechanisms that prevent duration measurement and remove fingerprinting surfaces. This is the section to cite whenever a design proposes a ShadowRealm as a sandbox for untrusted code: the proposal itself says it is "a bad choice for some code execution use cases" and is "not a full spectrum mechanism against security issues when evaluating code".

## The frame

> It is useful to look at this from the lenses of [the taxonomy of security essay](https://agoric.com/blog/all/taxonomy-of-security-issues/), which formalizes a framework to explain security and modularity issues in various systems.
>
> Based on the essay linked above, we can say that the ShadowRealm proposal provides a very limited protection:
>
> ✅ integrity ⛔️ availability ⚠️ confidentiality

The introduction states the same boundary up front: the API "is not a full spectrum mechanism against security issues when evaluating code. As such, it makes it a bad choice for some code execution use cases (e.g., spreadsheet functions blocking the main UI thread)."

## ✅ Integrity

> This proposal can be a good complement to integrity mechanisms by providing ways to evaluate code across different object graphs (different global objects) while maintaining the integrity of both realms. The integrity guarantee of the ShadowRealm API only extends to code that might inadvertently step on each other's feet (e.g. writing to the same global variable).

The concrete example is Google AMP: Google News creates multiple sub-apps; each sub-app runs in a cross-origin iframe communicating with the main app by post-message; each vendor can enhance the sub-app displaying its content by executing its code in a ShadowRealm that provides access to a well-defined set of APIs, preserving the sub-app's integrity.

The Third Party Scripts use case sharpens the same scope: the target is "multi-libraries and building blocks from different authors that can conflict with each other", and it is explicitly "not aiming to defend against malicious code or xss injections".

## ⛔️ Availability

> A ShadowRealm shares the same process with its incubator Realm. While direct cross-realm object access is prevented via the callable boundary, the ShadowRealm API was design to share a heap and thus a process. This is what allows the synchronous communication between the incubator realm and the ShadowRealm instance. This means all those resources are shared, preventing the ShadowRealm or the incubator realm from providing any guarantees in terms of liveness or progress. In other words, code running in a ShadowRealm can produce resource exhaustion, or excessive allocation of memory that can prevent the incubator realm from proceeding.

The worked example is a plugin system implementing heavy matrix computations: each plugin carries on a computation task, the task can be written asynchronously given the nature of the computation, and the main UI thread remains blocked during the heavy computation even though the result is expected asynchronously.

## ⚠️ Confidentiality

> Confidentiality, also known as Information Hiding or Secrecy, cannot be fully guaranteed by the ShadowRealm API. On the Web, two good examples of confidentiality violations are fingerprinting, and privacy violations.
>
> To provide Confidentiality, no one can infer information they are not supposed to know. The most pernicious threats to confidentiality are side channels like Meltdown and [Spectre](https://leaky.page/), where code running inside a ShadowRealm can infer another realm's secrets from timing differences. The APIs available in a ShadowRealm may also be used to infer information about the environment of the user, which is commonly known as fingerprinting.
>
> The ShadowRealm API can however be used as a building block towards providing confidentiality protections, for example when combined with inescapable mechanisms that prevent the measurement of duration, and remove fingerprinting surfaces.

## The library's reading

The triage matches the Hardened JavaScript position exactly: a realm boundary (or a compartment boundary) buys *integrity* between mutually suspicious programs sharing a heap, and buys neither availability nor confidentiality, because both of those need a boundary the shared heap and shared thread do not draw. Availability wants a separate process or agent (Workers, cross-origin iframes, which the explainer calls complementary); confidentiality wants the timing and fingerprinting surfaces removed on top. Reach for a ShadowRealm to keep cooperating-but-conflicting programs from stepping on each other, not to contain an adversary.

Source: [proposal-shadowrealm/explainer.md](https://github.com/tc39/proposal-shadowrealm/blob/main/explainer.md) at content sha256 `4842a1ef`. Stage 2.7; retrieved 2026-07-29.
