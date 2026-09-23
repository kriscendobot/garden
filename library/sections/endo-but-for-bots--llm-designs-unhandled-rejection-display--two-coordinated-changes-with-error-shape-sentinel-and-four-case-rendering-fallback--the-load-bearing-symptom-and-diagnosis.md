---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §load-bearing-symptom-and-diagnosis
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

The §What-is-the-Problem-Being-Solved paragraph names the
exact mechanism:

> *When a CapTP `CTP_DISCONNECT.reason` carries an `Error`
> instance, the JSON-encoded form on the wire is the empty
> object `{}` because `Error`'s own properties (`message`,
> `stack`, `name`) are non-enumerable and therefore invisible
> to `JSON.stringify`.*

The §non-enumerable-Error-properties-and-JSON.stringify
collision: `Error.prototype` defines `name`, `message`, and
`stack` as *non-enumerable* properties. `JSON.stringify`
*only* iterates enumerable own properties. Result: any
`Error` instance encodes as `"{}"`.

The §receiver-prints-empty-curly downstream effect: the
daemon's unhandled-rejection trap prints
*`CapTP <name> exception: {} ''`* — *literally* the empty
object. The §triage-failure consequence: *triage cannot
distinguish a `socket has been ended` race from an
`assert.fail` in a guest formula*.

The §repro-test-pins-both-sides observation: PR #174's
regression test exercises both the wire round-trip (Error
becomes `{}`) and the receiver-side display (formatter prints
empty braces).
