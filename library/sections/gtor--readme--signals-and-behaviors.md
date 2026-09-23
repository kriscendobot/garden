---
title: gtor — signals and behaviors (discrete pushed changes vs continuous polled latest; the changes/latest duality)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation, streams]
status: current
---

> Abstract: gtor's distinction between **signals** and **behaviors**, which is the conceptual root of the "changes vs latest" duality that recurs in `@endo/pubsub` (`makeChangeTopic` vs `makeLatestTopic`) and `@agoric/notifier` (lossless vs lossy). Both are unlike streams: a stream transports the *entirety* of a collection with pressure, but signals and behaviors deliberately *skip irrelevant states*, and both are well-adapted to multiple producers and consumers. A **signal** is a discrete value that changes only in response to events and is **pushed** — the output side is an **observable** whose `forEach` subscribes an observer to every change; signals do not support pressure ("a signal can only push; the consumer cannot push back"). A **behavior** is a continuous (or higher-frequency-than-needed) value that has no inherent resolution and so must be **polled/pulled** at whatever interval the consumer finds meaningful — only the most-recently-sampled value matters. The crucial bridge: an observable *also* implements `next`, returning an iteration capturing the most-recently-dispatched value, "which allows us to poll a signal as if it were a behavior." Changes and latest are therefore two faces of one signal, not two unrelated mechanisms.

## Two contracts beyond streams

Streams have a specific contract — transport the whole collection, in order, with pressure — that makes pressurization necessary. But "there are other contracts that lead us to very different strategies to avoid over-commitment, and they depend entirely on the meaning of the data in transit."

Two motivating examples:

- A **thermocouple** polled once per second, consumed by a visualization that redraws sixty times per second. The visualization wants only the *most recently sampled* value. The temperature changes **continuously**; sampling below the display rate means it is sufficient to remember the last value and redisplay it, and if sampled above the display rate the transport may *forget* old values as new ones arrive.
- A **scrollbar position**, which is **discrete**: it changes only in response to an observable scroll event. Each event is placed on the setter side; any number of consumers subscribe to the getter side and each is *pushed* a notification.

Unlike a stream, both cases suit multiple-producer / multiple-consumer scenarios, and crucially one **pushes** while the other **polls**. (A stream's pressure is a combined push-and-pull: data pulled toward the consumer by a vacuum, producers pushed back when the vacuum fills.)

> The discrete event pusher is a **Signal**. The continuous, pollable is a **Behavior**.

| Interface          | Role  | Discipline |
| ------------------ | ----- | ---------- |
| Signal Observable  | Get   | Push       |
| Signal Generator   | Set   | Push       |
| Signal             | Value | Push       |
| Behavior Iterator  | Get   | Poll       |
| Behavior Generator | Set   | Poll       |
| Behavior           | Value | Poll       |

## Signals and observables

A **signal** is a value that changes over time — asynchronous and plural like a stream, but with multiple producers and consumers. Its getter side is an **observable**; `observable.forEach(fn)` subscribes `fn` to receive a push on every change. Its setter is a signal generator implementing `yield` — but, unlike a stream writer, `yield` returns no promise, because **signals do not support pressure**: the consumer's callback does not return a promise either, so it cannot push back. A signal can only push.

Not every observable needs a paired signal generator: an external observable such as a **clock** emits the current time at a regular period and offset; signals may also correspond to platform signals (keyboard, mouse, sensors) or be dispatched to processes (a `SIGHUP` asking a daemon to reload).

## The changes/latest bridge

The load-bearing sentence for the whole change-propagation cluster: *"Observables also implement `next`, which returns an iteration that captures the most recently dispatched value. This allows us to poll a signal as if it were a behavior."*

So a single signal exposes two getter disciplines: subscribe-to-every-change (`forEach`, the **changes** face) and sample-the-latest (`next`, the **behavior/latest** face). A **behavior** proper has no setter at all — "it produces values on demand" from a function of time (an asynchronous behavior returns promises), and must be polled because it has no inherent resolution. This is exactly the duality `@endo/pubsub` makes concrete as two topic factories over one underlying mechanism. See [[changes-versus-latest]].

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Observables / Observables and Signals / Behaviors).
