---
title: "E Idioms Quick Reference Card"
source_kind: web
source_url: http://erights.org/elang/quick-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elang/quick-ref.html
source_fetched_via: mirror
source_content_sha256: 4fa42ec7a75e5c4db869a18bedb9fbcfbb5dd84f7b2a3607b3309ae45f3cb6a4
source_authors: [Marc Stiegler, Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. A reference card
  (mostly by Marc Stiegler), consolidated here into one grep-friendly section
  preserving the source's H2 anchors inline rather than mirroring each idiom as a
  separate section (per conventions.md § Sectioning shapes — reference docs).
  Tooling names (`<file:>`, `<swing:>`, `interp.continueAtTop`) are historical E
  surface, not Endo; the value for an Endo reader is the syntax-to-concept map
  and the eventual-send / remote-comm idioms that became `E()` and OCapN.
---

## Abstract

The **E Idioms Quick Reference Card** — a compact catalog of E's most-used
syntax and special characteristics, "mostly by Marc Stiegler." It is the
fastest way to read an E construct's *shape*: variable and object definition,
the expression-based control flow, the four collection types (ConstList,
ConstMap, FlexList, FlexMap with `diverge()`/`snapshot()` between const and
flex), the Java-interface bridge, and — most relevant to Endo's lineage — the
**eventual-send** idioms (`<-`, `when (…) -> {…} catch … finally …`,
`Ref.promise()`, `Ref.whenBroken`) and the **remote-comm bootstrap**
(`introducer.onTheAir()`, `sturdyToURI` / `sturdyFromURI`). The card explicitly
does *not* cover quasi-literals, regular expressions, pattern matching, parse
trees, or Kernel-E. This section keeps the source's headings inline as grep
anchors.

## Simple statements

```e
# set pragmas to the version of E syntax being used
pragma.syntax("0.9")

def a := 2 + 3
var a2 := 4
a2 += 1
def b := "answer: "
println(b + a)
```

The plus sign is interpreted by the object on the left: `b` being a string makes
`+` mean string concatenation. `"b + a"` concatenates without explicit
conversion; `"a + b"` would fail trying to cast string `b` to an integer.

## Basic flow

```e
if (a == b) { println("match") } else { println("no match") }

while (a < b) { a += 1 }

try { 3 // 0 } catch err { println("error: " + err) } finally { println("always") }

for next in 1..3 { println(next) }

for key => value in map { println("got pair") }
```

## Modules (function, singleton object, object maker, delegation, matching)

A **function** and a **stateless singleton object**:

```e
def addTwoPrint(number) {
  println(number + 2)
  return number + 2
}
def twoPlusThree := addTwoPrint(3)

def adder {
  to add1(number) { return number + 1 }
  to add2(number) { return number + 2 }
}
def result := adder.add1(3)
```

**Objects with state** (an object *maker* closing over construction
parameters), and **self-reference during construction** via `def op` + `bind`:

```e
def makeOperator(baseNum) {
  def instanceValue := 3
  def operator {
    to addBase(number) { return baseNum + number }
    to multiplyBase(number) { return baseNum * number }
  }
  return operator
}
def threeHandler := makeOperator(3)
def threeTimes2 := threeHandler.multiplyBase(2)

def makeOp() {
  def op
  def myAlerter := makeAlerter(op)
  bind op { to respondToAlert() { myAlerter("got alert") } }
  return op
}
```

**Delegation** (`extends` auto-delegates unhandled messages) and **matching an
interface like a Java adapter** (a `match [verb, args] {}` catch-all):

```e
def makeExtendedFile(myFile) {
  def extendedFile extends myFile {
    to append(text) {
      var current := myFile.getText()
      current := current + text
      myFile.setText(current)
    }
  }
  return extendedFile
}

def makeUpListener(reactor) :any {
  def upListener {
    to mouseUp(event) { reactor.mouseUp() }
    match [verb, args] {}
  }
  return upListener
}
# upListener meets the Java MouseListener interface
```

## Text file I/O and windowed applications

Text files are normalized to linefeed (`'\n'`) on read and converted to native
end-of-line on write; paths always use `/`; `~` is the home directory on both
Windows and Linux.

```e
def fileA := <file: ~/Desktop/text.txt>
def fileB := <file>["/home/marcs/text.txt"]
def fileC := <c:/windows/desktop/text.txt>
fileA.setText("abc")
def contents := fileA.getText()
for line in contents.split("\n") { println(line) }

def panel := JPanel`$labelA.X $labelB
$textArea.Y > `

interp.continueAtTop()   # after construction and window opening
interp.blockAtTop()      # at end of program
```

## Data structures (ConstList, ConstMap, FlexList, FlexMap)

```e
var a := [8, 6, "a"]          # a[2] == "a"; a.size() == 3
for i in a { println(i) }
a := a + ["b"]                # a(0,2) == [8,6]
def flexA := a.diverge()

def m := ["c" => 5]           # m["c"] == 5; m.size() == 1
for key => value in m { println(value) }
def flexM := m.diverge()

flexA.append(["b"]); flexA.push("b")
def constA := flexA.snapshot()

flexM["b"] := 2; flexM.removeKey("b")
def constM := flexM.snapshot()
```

Strings are ConstLists of char with additional (Java-string-like) methods. Flex
structures respond to all Const messages except the comparison operators
(`<`, `<=`, …). `diverge()` makes a mutable copy of a const; `snapshot()` makes
an immutable copy of a flex.

## Java interface

```e
def frame1 := <awt: Frame>()
def frame2 := <swing: JFrame>()
def panel := <swing: JPanel>()
E.call(frame2.getContentPane(), "add(Component)", [panel])
# E.call() disambiguates an overloaded Java method when arg types are super/sub
def byte := <import: java.lang.Byte>.asType()
def byteArray := byte[300]   # a Java array of primitives
```

**emakers** (capability factories imported by URI):

```e
def uiKit := <import: com.skyhunter.ex.uiKit>
def button := uiKit.newToolButton(iconImage, "tip", buttonFunc)
```

## Eventual sends (the ancestor of Endo `E()`)

```e
abacus <- add(a, b)                       # eventual send; returns a promise

when (def answer := abacus <- add(a, b)) -> {
  println(`computation complete: $answer`)
} catch problem {
  println(`promise broken $problem`)
} finally {
  println("always")
}

def carRcvr := makeCarRcvr <- ("Mercedes")
Ref.whenBroken(carRcvr, def lost(brokenRef) {
  println("Lost connection to carRcvr")
})

def [resultVow, resolver] := Ref.promise()
when (resultVow) -> { println(resultVow) } catch prob { println(`oops: $prob`) }
resolver.resolve("this text is the answer")
```

`<-` is the eventually operator (Endo's `E(target).method(args)`); `when (…) ->`
is the resolved-callback (Endo's `E.when` / `.then`); `Ref.promise()` returns a
`[promise, resolver]` pair (Endo's `makePromiseKit()`); `Ref.whenBroken`
registers a broken-reference handler.

## Remote communication (bootstrap)

```e
introducer.onTheAir()

def makeURI(obj) { return introducer.sturdyToURI(sturdyRef.temp(obj)) }
def makeFromURI(uri) { return introducer.sturdyFromURI(uri).getRcvr() }
```

`sturdyToURI` mints a capability URI for an object; `sturdyFromURI(...).getRcvr()`
turns a URI back into a live remote reference — the same off-machine introduction
the [introducer tutorial](erights--elang-concurrency-introducer--remote-objects.md)
develops, and the conceptual ancestor of OCapN's locators.

## Source

Source: [elang/quick-ref.html](https://erights.github.io/erights-org-website/elang/quick-ref.html) (mirror of `http://erights.org/elang/quick-ref.html`), last modified 1998-10-03, content SHA-256 `4fa42ec7a75e5c4db869a18bedb9fbcfbb5dd84f7b2a3607b3309ae45f3cb6a4`, fetched via the erights.org GitHub Pages mirror.
