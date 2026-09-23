---
title: "A 15 Minute Introduction to E: promises, when-catch, far references, and message ordering"
source_kind: web
source_url: https://erights.org/elang/intro/quickE.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/quickE.html
source_fetched_via: mirror
source_content_sha256: 0a9cec3ff648ad327f7320b47ede7b8be1820c950e0b338f6a19f6ce874a6a55
source_authors: [Marc Stiegler]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [eventual-send]
status: current
notes: |
  Section 3 of 4 from Marc Stiegler's "15 Minute Introduction to E". Promises and the
  when-catch construct, the "far" naming convention as a contract, the partial-order
  guarantee on sends, nested when-catch, and resolving promises to test equality.
  Companion sections: overview-and-conventional-subset,
  eventual-send-and-location-transparency, bootstrapping-remote-references.
---

## Abstract

How E turns the "fire and don't wait" eventual send into composable code: **promises** and the **when-catch** construct. An eventual send immediately returns "a promise for the result of the action" (`def carPromise := carMaker <- new("Mercedes")`); you can make further sends to the promise as if it were the car, but you cannot make immediate calls on it until it *resolves*, which you arrange with `when (promise) -> done(value) { ... } catch e { ... }` ("when the promise becomes done, run the main block; if something goes wrong, catch the error and run the error block"). Only the when-catch waits; the program proceeds. The section captures four further points. (1) The **"far" naming convention**: prefixing a variable `farCar` documents that the object is (probably) remote and the author commits to interacting with it only via sends — "not only a reminder, it can actually act as an important part of the function's contract." (2) The **partial-order guarantee**: messages from one object to one other object arrive and are processed in send order, but there is no ordering across multiple senders or multiple targets. (3) **Nested when-catch** to await several resolutions before computing; the `done(var)` clause "is actually the declaration of a function and a parameter," so each when-catch in a scope needs a distinct `done` name. (4) Resolving a promise inside when-catch is the one way to **test a far object for equality**. Use this to ground claims about E promises, the when-catch resolution construct, the far-reference naming discipline, or E's message-ordering semantics.

## Promises

"When you make an eventual send to an object ... even though the action may not occur for a long time, you immediately get back a promise for the result of the action":

```e
def carPromise := carMaker <- new("Mercedes")
carPromise <- moveTo(2,3)
```

Here `carMaker` is sent `new(name)`; eventually it creates the new car, and "in the meantime, we get back a promise for the car." You can make eventual sends to the promise just as if it were the car, "but we cannot make immediate calls to the promise even if the carMaker (and therefore the car it creates) actually live on the same computer with the program."

## when-catch: resolving a promise

To make immediate calls on the promised object, "you must set up an action to occur when the promise resolves":

```e
def temperaturePromise := carPromise <- getEngineTemperature()
when (temperaturePromise) -> done(temperature) {
    println(`The temperature of the car engine is: $temperature`)
} catch e {
    println(`Could not get engine temperature, error: $e`)
}
println("execution of the when-catch waits for resolution of the " +
        "promise, but the program moves on immediately to this println")
```

Read it as "when the promise for a temperature becomes done, and therefore the temperature is locally available, perform the main action block ... but if something goes wrong, catch the error in variable e and perform the error block." Inside the when-catch the promise is *resolved*. Critically, "only the when-catch construct waits. The program itself does not wait: rather, it proceeds on ... to the next statement following the when-catch." Because the temperature is an integer (an immutable, pass-by-copy), it "is guaranteed to resolve to a local integer object upon which you can make immediate calls, even if the car is remote."

## The "far" naming convention as a contract

```e
def farCar := carMaker <- new("Mercedes")
farCar <- moveTo(2,3)
farCar <- moveTo(5,6)
farCar <- moveTo(7,3)
def fuelPromise := farCar <- fuelRemaining()
```

The `Promise` suffix (as in `temperaturePromise`) is a "notational reminder" that the value is only a promise. The `far` prefix is a parallel reminder "that this car may be (indeed, probably is) executing on a remote machine, and that consequently we can never make immediate calls to it." Technically `carMaker <- new(...)` still returns a promise, but since a promise and the far reference respond identically to sends and identically to calls (both throw on a call), the convention treats it as already resolved to a remote reference and names it accordingly. The deeper point: "by calling the parameter `farCar`, the author of the function is making a commitment to users that nowhere in the function will the author use immediate calls" — so the convention "is not only a reminder, it can actually act as an important part of the function's contract."

## The partial-order guarantee on messages

The `farCar` example shows "another important property of eventual sends: if object A sends several messages to object B, it is guaranteed that those messages will arrive and be processed in the order of sending. This is only a partial ordering, however." From B's view, A's messages may be interspersed with messages from C, D, and so on. From A's view, if A sends to both B and C, there is no guarantee which resolves first, regardless of send order. Despite that, the partial order is enough to guarantee that `fuelPromise` resolves to the fuel remaining *after* all three `moveTo()` operations, performed in sequence. (The document later reuses this guarantee to argue that a variable holding a promise is itself filled with the resolved value once a *later* send to the same object has resolved inside a when-catch.)

## Resolving to test equality, and nested when-catch

"There is one reason to use a when-catch construct to resolve the promise for a far object ... to do a test for equality, i.e., to see whether the promised object is the same object you received from another activity":

```e
when (raceTrack <- getPolePositionCar()) -> done(farPolePositionCar) {
    if (farPolePositionCar == myCar) {
        println("My car is in pole position")
    }
} catch e {}
```

Because remote references are less reliable than local calls, "you will usually want to handle the error case"; but if many pending actions share one remote object, every catch fires on a connection failure, so you may handle the larger problem (loss of connection) in one place and leave others empty.

Because answers from *different* objects can arrive in any order, you "nest when-catch clauses to ensure several of the resolutions have taken place before doing a computation":

```e
def mercedesDistancePromise := mercedes <- distanceToFinishLine()
def chevyDistancePromise := chevy <- distanceToFinishLine()
when (mercedesDistancePromise) -> done(mercedesDistance) {
    when (chevyDistancePromise) -> done2(chevyDistance) {
        if (chevyDistance < mercedesDistance) {
            println("Chevy is in the lead")
        } else {
            println("Mercedes is in the lead")
        }
    } catch chevyE {
        println("Chevy lost")
    }
} catch mercedesE {
    println("Mercedes lost")
}
```

A "very important syntactic note": the `done(variable)` clause "is actually the declaration of a function and a parameter." The operational consequence is that you can (and, in nested when-catch within one scope, *must*) use different names for the `done` function — here `done2` for the inner one — and likewise distinct names for the catch error variables (`chevyE`, `mercedesE`).

## Translation

| quickE (E vat language) | Endo / modern equivalent |
|---|---|
| promise from a send | the handled promise returned by `E(target).method(...)` |
| `when (p) -> done(v) { ... } catch e { ... }` | `E.when(p, v => {...}, e => {...})`; see [[eventual-send]] |
| `farCar` (far-reference naming convention) | a remote presence / far reference reached only via `E(...)` |
| message partial-order guarantee | E-order delivery preserved by CapTP between two parties |

Source: [elang/intro/quickE.html](https://erights.github.io/erights-org-website/elang/intro/quickE.html) via the erights.github.io mirror; content SHA-256 `0a9cec3f`.
