---
title: "Four Party Partial Orders: distributed join introduces a merge into the message-delivery order"
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

The "On to:" successor of the Grant Matcher Puzzle, defining the *concurrency* problem E's equality operators must solve (the puzzle defined the *security* problem). Partially-ordered message delivery with only **forks** in the order specification yields a *tree* order, which suffices for pure capabilities without equality (Actors, Joule). But E *also* has a distributed equality construct able to do distributed grant matching, and to satisfy the Grant Matcher Puzzle's constraints that construct must introduce a **join** into the specification topology — turning the tree into a general partial order. This is implemented in E with the single special primitive `==` (local immediate sameness) wrapped in an asynchronous `join`. Given `a` and `b`, `def c := E.join(a, b)` *immediately* defines `c` as a promise for a reference that will be acceptable as a valid interpretation of what *both* `a` and `b` meant — valid in the sense that whoever introduced each reference would have no cause for complaint if we used the promised reference instead. Messages may be sent on `c` immediately; they are delivered only if the promise is fulfilled (a mutually acceptable reference was obtained), and discarded under the usual broken-promise contagion if no such reference can be obtained.

This page should be read after *Partially Ordered Message Delivery*.

So far we only have forks in the order specification. This creates only a tree order, not a general partial order. For pure capabilities without equality (as in Actors or Joule), this would be fine. However, E also has a distributed equality construct able to do distributed grant matching. To satisfy the constraints implied by the Grant Matcher Puzzle, this distributed equality construct must also introduce a **join** in the specification topology. Fortunately, this is easily implemented in E, in which the only special primitive is `==` (local immediate sameness):

```e
def join(a, b) :any {
    def [result, resolver] := Ref.promise()
    var hasLeft := false
    var left := null
    var hasRight := false
    var right := null
    var reduce := null
    reduce := def realReduce() :void {
        def done(answer) :void {
            resolver.resolve(answer)
            reduce := def noop() :void {}
        }
        if (Ref.isBroken(left)) {
            done(left)
        } else if (Ref.isBroken(right)) {
            done(right)
        } else if (hasLeft && hasRight) {
            # Eventual equality bottoms out in immediate equality
            if (left == right) {
                done(left)
            } else {
                done(Ref.broken("No join found"))
            }
        }
    }
    Ref.whenResolved(a, def reduceA(aa) :void {
        hasLeft := true
        left := aa
        reduce()
    })
    Ref.whenResolved(b, def reduceB(bb) :void {
        hasRight := true
        right := bb
        reduce()
    })
    result
}
```

The above function is actually predefined as the `join` method of the object named `E`. Given `a` and `b`, `def c := E.join(a, b)` immediately defines `c` as a promise for a reference that will be acceptable as a valid interpretation of what `a` meant, *and* a valid interpretation of what `b` meant. (Valid in the sense that the introducer that sent us each of these references would have no cause for complaint if we use the promised reference instead.) We may immediately start sending messages on this new reference, confident that these messages will only get delivered if the promise indeed gets fulfilled, and therefore a mutually acceptable reference could be obtained. If a mutually acceptable reference cannot be obtained, the promise will become broken and all messages sent to it will be discarded, using the usual broken-promise contagion rules. Note that "eventual equality bottoms out in immediate equality": the asynchronous `join` reduces to the synchronous `==` once both operands resolve and are co-located.

Source: [Four Party Partial Orders](https://erights.org/elib/equality/after-both.html), Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `e9e89167` (byte-identical to the prior Internet-Archive capture).
