# Wildcards in `.claude/settings.json`

Claude Code's rules in `.claude/settings.json` do not use ordinary shell
globbing (though the syntax is similar).  Here is the behavior, inferred by
experiments against Claude Code 2.1.263:

* A rule with no `*` matches only that exact command.
* A rule that ends in `:*`: Those two characters are stripped and the
  remainder is used as a *literal* prefix.  No globbing happens, so a `*`
  that appears earlier in the rule is compared literally and matches nothing.
  A prefix match must end at a word boundary.
  * Example: `Bash(git V:*)` matches `git V`.
  * Example: `Bash(git -* V:*)` matches nothing.
  * Example: `Bash(git checkout:*)` matches `git checkout` and
    `git checkout main`, but not `git checkout-index`.
* A rule that ends in a space plus `*` is tried two ways -- as a literal
  prefix (with the space and star stripped) and as a glob -- and matches if
  either succeeds.  So `Bash(git V *)` matches bare `git V` (as a prefix) and
  `git V ARGS` (as a glob).  A `:*` suffix does not work this way: it is only
  ever a literal prefix.
* A rule that contains `*` and does not end in `:*`: each `*` acts as a glob:
  it matches any run of characters, including spaces and the empty string.
  The pattern must match the command from beginning to end.
  * Example: `Bash(git -* checkout)` matches `git -C DIR checkout` but *not*
    `git -C DIR checkout main`.
  * Example: A `Bash(git V **)` deny rule forbids `git V ARGS` while
    permitting bare `git V`.  Claude treats this as two globs, not as a
    prefix match, so the literal space requires at least one argument.  The
    space is essential: a `Bash(git V**)` deny rule forbids bare `git V` too.
  * Example: `Bash(git -* checkout*)` forbids `git -C DIR commit -m 'fix
    checkout bug'`.  This is safe (as a deny rule), but it may be
    surprising behavior.

Notes:

* `deny` beats `allow` no matter how specific the `allow` rule is.  An `allow`
  entry that is also covered by a `deny` entry is dead text.
* `deny` rules are enforced even when Claude Code is running with permissions
  bypassed.
