---
title: The takeFocus / blur widget contract
source: README.md
source_repo: gutentags/kamera
source_commit: 09b81cc16b40ce22f09337f5bba6a66fbd1bdc8c
source_date: 2015-09-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [focus-management, html-modules]
status: current
---

Abstract: A widget participates in single-focus enforcement by holding the shared kamera as `this.attention` (read from `scope.attention`) and calling `this.attention.takeFocus(this)` from its own `focus` method. `takeFocus` implicitly calls `component.blur` on the prior focal component, so a widget's `blur` method — which undoes whatever `focus` did — is invoked whenever another component takes the focus. The contract is thus two methods per widget (`focus` calls `takeFocus`; `blur` reverses `focus`'s effects) and one shared singleton.

Each widget in the application may use `attention.takeFocus(this)` in its focus method to ensure that `component.blur` is called on the prior focal component whenever it takes the focus:

```js
function Widget(body, scope) {
    this.attention = scope.attention;
}

// ...

Widget.prototype.focus = function focus() {
    this.element.classList.add('focus');
    this.attention.takeFocus(this);
};

// This can be called manually, or implicitly called by the focus method of
// another component by way of attention.takeFocus.
Widget.prototype.blur = function blur() {
    this.element.classList.remove('focus');
};
```

Source: [README.md](https://github.com/gutentags/kamera/blob/09b81cc16b40ce22f09337f5bba6a66fbd1bdc8c/README.md) at commit `09b81cc`.
