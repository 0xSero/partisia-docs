document.addEventListener("DOMContentLoaded", function () {
  show_toc_left();
});

function show_toc_left() {
  try {
    document
      .querySelectorAll(".md-nav .md-nav--secondary")[0]
      .setAttribute("style", "display: block;");
    document.querySelectorAll(".md-nav .md-nav--secondary label")[0].remove();
  } catch (err) {
    console.log(err);
    document.querySelector(".md-sidebar--secondary").setAttribute("style", "display: none;");
  }
}
