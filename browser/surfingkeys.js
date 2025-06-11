/* --------------------------------- Remove default keybindings --------------------------------- */

api.unmap("s");
api.unmap("S");
api.unmap("d");
api.unmap("u");
api.unmap("<Ctrl-h>");
api.unmap("<Ctrl-d>");
api.unmap("<Ctrl-u>");

/* --------------------------------- Create custom keybindings ---------------------------------- */

// Mouse click on any element
api.mapkey("s", "#1Mouse over elements", function () {
  api.Hints.create("", api.Hints.dispatchMouseClick, { mouseEvents: ["mouseover"] });
});

// Open multiple links on unfocused tab
api.map("S", "cf");

// Scroll down page
api.mapkey(
  "<Ctrl-d>",
  "#2Scroll a page down",
  function () {
    api.Normal.scroll("pageDown");
  },
  { repeatIgnore: true },
);

// Scroll up page
api.mapkey(
  "<Ctrl-u>",
  "#2Scroll a page up",
  function () {
    api.Normal.scroll("pageUp");
  },
  { repeatIgnore: true },
);

// TODO: create scroll for search?

/* ----------------------------------- Replace default theme ------------------------------------ */

const hintsCss =
  "font-size: 8pt; font-family: 'JetBrainsMono NF'; border: 0px; color: #1a1b26 !important; background: #0db9d7; background-color: #0db9d7";

api.Hints.style(hintsCss);
api.Hints.style(hintsCss, "text");

// TODO: change default theme
