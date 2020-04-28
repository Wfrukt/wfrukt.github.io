fetch('grammar.pegjs').then(response => response.text()).then(text => {
  let parser = peg.generate(text);
  document.getElementById("btn").onclick = e => {
    try{
        let sent = parser.parse(document.getElementById("textIn").value);
        console.log(genHtml(sent));
        document.getElementById("divOut").innerHTML = ["<ul>",genHtml(sent),"</ul>"].join("");
      }catch(e){
        document.getElementById("divOut").innerHTML = ["<ul>",e.message,"</ul>"].join("");
      }
  };
});

function genHtml(sent){
  let html = [];
  rekHtml(sent,html,null)
  return html.join("");
}

function rekHtml(sent,html,ctx){
  html.push("<li>");
  if(sent.type == "noun"){
    addWord(sent.word,html,ctx);
    if(sent.lsAdj && sent.lsAdj.length){
      html.push("<ul>");
      sent.lsAdj.forEach(e => rekHtml(e,html,null));
      html.push("</ul>");
    }
  } else if(sent.type == "verb"){
    addWord(sent.word,html,ctx);
    if(sent.lsArg && sent.lsArg.length){
      html.push("<ul>");
      sent.lsArg.forEach((e,i) => rekHtml(e,html,i+1));
      html.push("</ul>");
    }
  } else if(sent.type == "adj"){
    html.push(sent.word);
  } else throw "unknown type: "+sent.type
  html.push("</li>");
}

function addWord(word,html,ctx){
  if(ctx) html.push(word + " ("+ctx+")");
  else html.push(word);
}