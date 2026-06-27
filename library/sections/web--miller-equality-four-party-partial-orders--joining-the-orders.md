---
title: "Joining the Orders: c is a fork of both a and b, with delivery and partition rules"
source_kind: web
source_url: https://erights.org/elib/equality/after-both.html
source_content_sha256: e9e8916b7f39f7b94ab2b8a624b71841848627cf0c61811c40208038c1356184
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, eventual-send]
status: current
---

How the `join` produces the *merge* node in the message-delivery partial order. If `c := E.join(a, b)` resolves, then `c` is simultaneously a *fork of `a`* and a *fork of `b`* — and that double-fork is exactly where the join in the ordering comes from. The delivery constraints couple the two source references' message streams through `c`: a message sent on `c` may be delivered only after the messages that preceded the join on *both* `a` and `b`. The page also states the failure and partition behavior precisely: if `a` and `b` do *not* designate the same object, every ordering rule still holds except that the post-join message on `c` must *not* be delivered, and `c` must eventually resolve to BROKEN; and under a partition that loses a message, the dependent forks must never be delivered and the affected references must eventually break — "as implied by `c` is a fork of `b`."

In fact, `c`, if it resolves, is a fork of `a` *and* a fork of `b`. This is where the join in the ordering comes from. Given the following sequence of actions:

```e
a <- u()
b <- v()
c := E.join(a, b)
a <- w()
c <- x()
b <- y()
```

if `a` and `b` are independent references to the same object, and assuming no partition occurs, then:

- `u()` and `v()` may be delivered in any order.
- `w()` may only be delivered after `u()` is delivered.
- `x()` may only be delivered after `u()` is delivered, as implied by "`c` is a fork of `a`".
- `x()` may only be delivered after `v()` is delivered, as implied by "`c` is a fork of `b`".
- `y()` may only be delivered after `v()` is delivered.
- `w()`, `x()`, and `y()` may be delivered in any order.
- All these messages are delivered at most once.

If `a` and `b` do *not* designate the same object, then all the above statements hold except that `x()` must **not** be delivered. In addition, `c` must eventually resolve to BROKEN.

Should a partition occur, all the above statements continue to hold anyway, but not in the obvious way. For example, should `v()` be lost in a partition, never to be delivered, then `x()` and `y()` must never be delivered, and both `b` and `c` must eventually become BROKEN, as implied by "`c` is a fork of `b`".

Source: [Four Party Partial Orders](https://erights.org/elib/equality/after-both.html) § Joining The Orders, Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `e9e89167` (byte-identical to the prior Internet-Archive capture).
