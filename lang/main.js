fetch('grammar.pegjs').then(response => response.text()).then(text => {
  let parser = peg.generate(text);
  document.getElementById("btn").onclick = e => {
    try{
        let root = parser.parse(document.getElementById("textIn").value);
        console.log(root.html);
        document.getElementById("divOut").innerHTML = ["<ul>",root.html,"</ul>"].join("");
      }catch(e){
        document.getElementById("divOut").innerHTML = ["<ul>",e.message,"</ul>"].join("");
      }
  };
});