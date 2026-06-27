---
title: "The Grant Matcher Puzzle: why object identity matters for equality primitives"
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

The puzzle's framing paragraph: many systems designers have wrestled with object identity, and the issue must be resolved to design foundational equality primitives. The open question is whether an object system should provide a means to tell whether two object references refer to the same object **without consulting either of the objects involved** — the *EQ* primitive (named after Lisp). Otherwise-equivalent pure capability systems have answered this differently, and the implications of the different answers were not understood until the Grant Matcher Puzzle.

Many systems designers have wrestled with the notion of object identity. The issues must be resolved to design foundational equality primitives. Should an object system provide a means to tell whether two object references refer to the same object, without consulting either of the objects involved? Following Lisp, we call any such primitive *EQ*. Pure capability systems that are otherwise equivalent have come to different answers. The implications of these different answers were [not understood](https://erights.org/elib/equality/grant-matcher/history.html) until the Grant Matcher Puzzle.

The puzzle is therefore not about a single "right" answer but about *the cost of each answer*: a system with no `EQ` cannot distinguish a transparent forwarder from the object it forwards to (preserving full forwarder transparency, but defeating a naive equality protocol), while a system with address-equality `EQ` can make that distinction (at the cost of forwarder transparency). The Grant Matcher scenario is the concrete problem that makes those costs visible.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html), Mark S. Miller, erights.org (mirrored at [caplet.com](http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html)); ingested from the Internet Archive original-bytes capture, content SHA-256 `d25136c9`.
