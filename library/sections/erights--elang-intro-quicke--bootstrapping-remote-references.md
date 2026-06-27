---
title: "A 15 Minute Introduction to E: bootstrapping the first remote reference"
source_kind: web
source_url: https://erights.org/elang/intro/quickE.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/quickE.html
source_fetched_via: mirror
source_content_sha256: 0a9cec3ff648ad327f7320b47ede7b8be1820c950e0b338f6a19f6ce874a6a55
source_authors: [Marc Stiegler]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: |
  Section 4 of 4 from Marc Stiegler's "15 Minute Introduction to E". The bootstrapping
  question (how a program gets its FIRST off-machine reference), URI encoding of object
  references, makeURIFromObject / getObjectFromURI, the introducer onTheAir primitive,
  the security note that passing URIs is the one security problem E cannot solve for you,
  and the closing "promise architecture" summary plus the "topics beyond" list.
  Companion sections: overview-and-conventional-subset,
  eventual-send-and-location-transparency, promises-when-catch-and-far-references.
---

## Abstract

The bootstrapping problem the rest of the intro deferred: every earlier example "started out with a reference to at least one remote object" and reached others by asking that object — so "how does a program acquire its very first reference to an object on a different computer?" The answer: in E "the reference to an object can be encoded as a Universal Resource Identifier string, known as a uri" (the Web URL is one kind of uri). A uri can be passed around many ways — saved to a file, PGP-encrypted and emailed, sent over ssh, even "read off over a telephone," or, on a trusted LAN, left in a shared-filesystem file. The primitives `makeURIFromObject(object)` and `getObjectFromURI(uri)` (detailed in the *E Quick Reference Card*) perform the transformations; each program "needs to invoke the primitive `introducer onTheAir` before starting any remote connections, including the making or using of uris." The section also captures the document's pointed **security note** — "the passing of the uris from machine to machine is the main security issue that E cannot address for you," so encrypting uris is crucial for a "seriously secure distributed E system" — and the closing argument that "the promise architecture ... is the heart of what makes E different": no threads, no synchronize statements, no critical sections, no deadlocks, yet all the distributed behaviors conventional architectures allow. Use this to ground claims about how E bootstraps off-machine connectivity (uri / introducer), where E places the residual trust-establishment problem, or E's no-threads/no-deadlock concurrency thesis.

## The bootstrapping question

"We end this introduction by answering a last, critical question: How does a program acquire its very first reference to an object on a different computer?" Every previous example assumed at least one remote reference in hand and reached others by asking it (a remote `carMaker` for a new car, and so on). The unanswered question is where the *first* reference comes from.

## URIs and the introducer

"In E, the reference to an object can be encoded as a Universal Resource Identifier string, known as a uri (the familiar url of the Web is a type of uri)." The uri string "can be passed around in many fashions." Ways the document names:

- Save it to a text file, encrypt and sign it with PGP, and send it in email ("one good secure way").
- Send the uri over an ssh connection.
- Read the uri off over a telephone ("less securely").
- On a local area network with no security concerns (using E "simply because it is simpler, safer, and more maintainable for distributed computing"), store uris in files on a shared file system and read them directly as programs start up.

The transforming primitives: "The functions `makeURIFromObject(object)` and `getObjectFromURI(uri)` detailed in the E Quick Reference Card perform the basic transformations you need to hook up objects on multiple computers." And the activation step: "Each program that expects to work with remote objects needs to invoke the primitive `introducer onTheAir` before starting any remote connections, including the making or using of uris." A worked example of these functions together "can be found in the Securit-Echat system."

## Where E places the residual security problem

The document is explicit that uri distribution is the one thing E hands back to the developer: "If you wish to run a seriously secure distributed E system, encrypting the uris is crucial: indeed, the passing of the uris from machine to machine is the main security issue that E cannot address for you." Everything downstream of holding a uri is secured by E (unguessable references, secure links); establishing who legitimately receives a uri in the first place is the residual trust-establishment problem left to PGP, ssh, or out-of-band channels.

## The promise architecture thesis and the "topics beyond" list

The closing argument: "The promise architecture described here is the heart of what makes E different. There are no multiple threads, no synchronize statements, no critical objects, no deadlocks. Yet the promise architecture allows the construction of all the different distributed programming behaviors that more conventional architectures allow." The consequence is that distributed E systems "are more robust and easier to work with — once you have grasped the implications of promises," though "most people will find it takes more time and more thought to fully appreciate the ramifications." The recommended next steps are the *E Quick Reference Card* (a compact introduction to all of E's features) and the *Securit-Echat* system (a small but full-featured, heavily documented teaching example).

The intro also names a recognizable failure mode and its remedies: new users of a promise architecture "often have a sense of breathlessness, a feeling that once they have started a series of remote computations, they have lost control of the action," which can become panic when accompanied by "a sense of lost understanding." It points at "multiple techniques and patterns for 'reining in' the remote computations," several found in the *Securit-Edesk* program: `promiseAllDone`, the `vowsMonitorMaker`, the `Sequencer`, and the "summoning pattern."

Finally, the page lists *Topics Beyond the 15 minute intro, for the full concurrency chapter* — recursion for multiple when-catch resolutions (computing the lead car without knowing how many cars are racing), the `promiseAllDone` example (loop and recursion forms), the summoning pattern, "Breathless E" (the need for `blockAtTop` and `continueAtTop` for a windowed application), the `whenBroken` construct (a promise can only be broken once, but a remote reference can become broken any time through loss of the connection), the subtlety that it is objects outside the *vat* (not outside the computer) that need a remote reference, and the rare data-lock possibility. These name where the full concurrency chapter would go beyond the 15-minute tour.

## Translation

| quickE (E vat language) | Endo / modern equivalent |
|---|---|
| uri encoding of an object reference | a captp/ocapn locator or a sturdyref for an object |
| `makeURIFromObject` / `getObjectFromURI` | export/import of a reference across a connection (CapTP); see [[eventual-send]] |
| `introducer onTheAir` | bringing the vat / connection layer online before remote use |
| vat (concurrency boundary) | the vat / event-loop boundary; see [[vat-and-compartment]] |
| `whenBroken` | rejection / disconnect handling on a far reference's promise |

Source: [elang/intro/quickE.html](https://erights.github.io/erights-org-website/elang/intro/quickE.html) via the erights.github.io mirror; content SHA-256 `0a9cec3f`.
