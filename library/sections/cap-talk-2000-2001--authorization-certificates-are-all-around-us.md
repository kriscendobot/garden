---
title: "Authorization certificates are all around us (bearer tokens in everyday life)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2001-August/
source_snapshot: http://web.archive.org/web/20130603010258id_/http://www.eros-os.org/pipermail/cap-talk/2001-August.txt.gz
source_content_sha256: 76388b8abdee87e25b4efc43ce3744974b559f981abf285fc3ae805e6aa7687b
source_authors: [David L. Nicol]
source_date: 2001-08-21
thread_subject: "Authorization Certificates Are All Around Us"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original message."
---

Abstract: David L. Nicol's August 2001 essay answers the "authorization certificates are new and experimental" objection he met when proposing them for the iCalendar standard by cataloguing the bearer/authorization certificates people already use every day. His running distinction is the one at the heart of the capability model: an authorization certificate designates (proves you are *authorized*) without authenticating (proving *who you are*). A credit card number authorizes a purchase, so lending it to someone makes them your honest designate rather than an impersonator; an ATM PIN, by contrast, is an authentication secret. The section is a memorable illustration of capabilities-as-bearer-tokens, adjacent to the corpus's [card-keys](../concepts/card-keys.md) concept.

## Designation, not authentication

Nicol adopts the calendar term "designate" for what SPKI calls a "delegate," and organizes the essay around designation versus authentication. The sharpest example: "An argument could be made for Credit Card Number falling under the definition of SPKI Authorization certificate: by presenting the number, a designate is authorized to purchase things ... Credit card number is not an authentication system. When I give Ellen my credit card to buy things, Ellen does not misrepresent herself as me when she does that: she honestly represents herself as my designate." He draws the line at the ATM PIN: "These are an authentication system, and are supposed to be kept secret."

## The everyday catalogue

- **Mailing-list confirmation and removal**: recipient-verification uses a one-time bearer certificate; EZMLM's removal uses a Variable Envelope Return Path (VERP) bearer certificate.
- **Multiplexing handle IDs**: NFS and the Linux NBD protocol use a call ID; TCP/IP itself treats the source-address / source-port / destination-address / destination-port / sequence-number tuple as "a certificate that authorizes the payload ... to be added to a particular buffer (thus the possibility of TCP spoofing attacks)."
- **HTTP session cookies**: "a certificate that authorizes the presenter to, for instance, add merchandise to a virtual shopping cart," with hidden fields and path-info as equivalent carriers.
- **Trouble tickets, order numbers, dry-cleaner tickets, waiting-room numbers, TV channel numbers**: each authorizes the bearer to receive a specific thing without proving identity ("the counter help does not care who I am, only that I demonstrate that I am authorized to pick up a particular lunch order").

The catalogue makes the ocap point that the bearer-token pattern is not exotic; it is the default in the physical and network world, and capability systems only make it first-class, unforgeable, and delegable. It also foreshadows the web-key discipline (an unguessable URL as a bearer capability) that Waterken and later ocap-on-the-web work formalize.

Source: [cap-talk 2001-August archive](http://www.eros-os.org/pipermail/cap-talk/2001-August/) (Internet Archive original-bytes snapshot `web/20130603010258id_/.../2001-August.txt.gz`, sha256 `76388b8a`), message by David L. Nicol, 2001-08-21.
