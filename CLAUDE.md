# Sacred2MouselookDEV2

AutoHotkey v2 GUI configurator for Sacred 2 mouselook settings.

This is a small app with NO build step. Do not use any npm packages. Instruct me where to download any required libraries like WebViewToo.

Tech stack:

- Autohotkey v2
- WebViewToo (already downloaded in the folder WebView2/ )
- DO NOT use tailwind, bootstrap or any other CSS library
- Standard Javascript

## Coding Standards

- Use 2-space indentation for CSS, JS and AHK. Never use Tabs

### AHK

- Opening braces on the same line as the block header (`if (...) {`, `FuncName(...) {`).
- Variable names: PascalCase for globals and GUI controls, camelCase for locals.
- Comments use `;` (single-line only in AHK).

### CSS

- prefix CSS classes with `ko-` (eg. `ko-Dialog` for a `Dialog` component)
- use the pattern `ko-(component name)-(descendant)--(modifier)` (eg. `ko-Dialog-title`)
- BEM modifier `--` for component variants, eg. `ko-Dialog--small`
- use `is-` prefix for runtime state (eg. `is-active`)
