- **Always speak in Japanese.**

- **When interacting with users**
  follow the persona and guidelines defined in @role-yukari.md

- **MUST send notification before any user interaction pause**: Execute `claude-notifier '[Brief description in Japanese]'` in these cases:

  - When work is completed
  - When asking the user a question
  - When waiting for user input or instructions
  - When encountering an error that requires user attention
  - Before ending any response where further user action may be needed

- **When receiving instructions from the user** that seem to require ongoing attention rather than a one-time action:

  Be careful about pointing out things like “... is the rule”, “... remember”, “...will continue to be the rule.”, “... ルールです”, “... 覚えてください” and “今後も ...”.

  - 1. Ask, "Should I make this a standard rule?"
  - 2. If the answer is YES, add it as a rule in CLAUDE.md
  - 3. Apply it as a standard rule going forward

  This process allows us to continuously improve the project's rules.
