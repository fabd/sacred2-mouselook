# Sacred2MouselookDEV2

A Autohotkey v2 script to enhance Sacred 2 Remaster mouse and keyboard controls.

The script includes a user friendly GUI to configure the hotkeys and toggle options.

The main script is `main.ahk`.

## Tech Stack

This is a small app with NO build step. Do not use any npm packages.

- Autohotkey v2
- WebViewToo (already downloaded in the folder `lib/WebView2/` )
- JSON library (`lib/JSON.ahk`)
- For the GUI, DO NOT use Tailwind CSS, Bootstrap or any other CSS library
- Standard Javascript

## Coding Standards

- Use 2-space indentation for CSS, JS and AHK. Never use Tabs

### AHK

- Opening braces on the same line as the block header (`if (...) {`, `FuncName(...) {`).
- Variable names: PascalCase for globals and GUI controls, camelCase for locals.
- Comments use `;` (single-line only in AHK).

### JS

- when creating ids, and passing values from JS to AHK, use kebab-case identifiers, for example `key-look-left`, ideally matching the variable in the AHK script eg. `Key_LookLeft` should be named `key-look-left` in the HTML and JS code

### CSS

- prefix CSS classes with `ko-` (eg. `ko-Dialog` for a `Dialog` component)
- use the pattern `ko-(component name)-(descendant)--(modifier)` (eg. `ko-Dialog-title`)
- BEM modifier `--` for component variants, eg. `ko-Dialog--small`
- use `is-` prefix for runtime state (eg. `is-active`)


## Documentation

You can read example usage of WebViewToo in the github repo.

If you need

| When you need to create | read this example |
| --- | --- |
| Interactive Page | https://github.com/G33kDude/WebViewToo-Starter-Kit/blob/main/Examples/3.%20Interactive%20Page.ahk |
| Custom Title Bar | https://github.com/G33kDude/WebViewToo-Starter-Kit/blob/main/Examples/4.%20Custom%20Title%20Bar.ahk |
