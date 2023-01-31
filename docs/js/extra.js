document.addEventListener("DOMContentLoaded", function () {
  show_toc_left();
});

function show_toc_left() {
  try {
    document
      .querySelectorAll(".md-nav .md-nav--secondary")[0]
      .setAttribute("style", "display: none;");
    document.querySelectorAll(".md-nav .md-nav--secondary label")[0].remove();
  } catch (err) {
    console.log(err);
    document.querySelector(".md-sidebar--secondary").setAttribute("style", "display: none;");
  }
}
  function d3ize(elem) {
    var par = elem.parentElement;
    d3.select(par).append('div').graphviz().renderDot(elem.innerText);
    d3.select(elem).style('display', 'none');
  }
  console.log(document.getElementsByClassName(".language-dot"));
  var dotelems = document.getElementsByClassName("language-dot");
  for (let elem of dotelems) {
    d3ize(elem);
  }