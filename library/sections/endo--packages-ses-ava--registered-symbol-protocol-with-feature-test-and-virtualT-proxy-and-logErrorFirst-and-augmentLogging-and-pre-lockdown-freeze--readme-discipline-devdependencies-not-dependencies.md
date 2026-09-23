---
title: "§README discipline: §devDependencies-not-dependencies"
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

The README explicitly directs users to install `@endo/ses-ava` as a `devDependency`:

> @endo/ses-ava itself depends on AVA as a regular dependency, so it you include @endo/ses-ava as a regular dependency, bundlers might bundle your code with all of AVA.

§Borrowable-pattern: §when-a-test-library-has-AVA-as-a-regular-dependency, §the-consuming-application-must-treat-the-test-library-as-a-devDependency-to-avoid-bundle-bloat. §The-package-maintainer-cannot-control-the-consumer's-bundling-choice; §the-best-they-can-do-is-document-the-correct-discipline.

§Sibling to cycle 200 worker-rust-xs's §named-bundling-implication and cycle 218 familiar-chat-weblet-hosting's §`@host`-explicitly-labeled-development/trusted-only.
