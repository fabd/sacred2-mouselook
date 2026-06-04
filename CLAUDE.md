# Better Mouselook Controls for Sacred 2 Remaster

A Autohotkey v2 script to enhance Sacred 2 Remaster mouse and keyboard controls.

The script includes a user friendly GUI to configure the hotkeys and toggle options.

The main script is `main.ahk`.

## Tech Stack

This is a small app with NO build step. Do not use any npm packages.

- Autohotkey v2
- WebViewToo (already downloaded in the folder `lib/WebView2/` )
- JSON library (`lib/JSON.ahk`)
- TailwindCSS (standalone compiler)
- Standard Javascript

The user runs the standalone tailwindcss compiler while working on the project, which watches for changes to the main stylesheet and compiles it to `gui/style.build.css`:

`tailwindcss -w -i gui/style.css -o gui/style.build.css`

## Project structure

```
docs/                        example code for AHK v2 features
gui/                         files for the WebView2 interface
  img/                       all images go here
  index.hml                 
  style.build.css            output from tailwindcss, ignore
  style.css                  the main stylesheet
lib/
  WebView2/                  the WebViewToo ahk library and its dependencies
  JSON.ahk                   thqby's JSON library
```

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
