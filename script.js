document.addEventListener("DOMContentLoaded", () => {
  let md = window.markdownit();
  load("text/grammar.md", text => {
     document.getElementById("divOut").innerHTML = md.render(text);
  });
});


