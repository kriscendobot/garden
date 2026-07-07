---
id: auth-vs-notify-events
aliases: [auth events, notify events, auth+notify, authorization events, ES auth event, ES notify event, allow deny event, synchronous ES event, asynchronous ES event]
topics: [endpoint-security, process-monitoring]
---

# auth-vs-notify-events

In Apple's EndpointSecurity framework, an event reaches a client's handler as one of two kinds. An **auth** (authorization) event is synchronous: the framework blocks the operation and waits for the client to respond with an allow-or-deny verdict before the operation proceeds, so an auth-subscribed client is an enforcement point. A **notify** event is asynchronous: it reports that an operation happened (or is happening) with no verdict expected, so a notify-subscribed client is an observer only. The distinction matters for `es_new_descendants_client` because the two roles are split by scope: the client receives **notify only** for the calling process (it can watch itself but not gate itself) and **auth + notify** for every descendant process (it can both observe and allow/deny operations across the subtree it spawned). This is what lets a descendants client act as a supervisor for its process tree while remaining a pure observer of itself.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | Caller gets notify only; descendants get both auth and notify events. |

## See also

- [[es-descendants-client]] — the descendant-scoped ES client whose caller/descendant scoping is expressed precisely through this notify-only vs auth+notify split.
