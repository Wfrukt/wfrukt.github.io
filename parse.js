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

let hintArg = "^";

function rekHtml(sent,html,ctx){
  html.push("<li>");
  if(sent.type == "noun"){
    addWord(sent.word,html,ctx);
    if(sent.arg || isLoad(sent.lsAdj)) html.push("<ul>");
    if(sent.arg) rekHtml(sent.arg,html,"^");
    if(isLoad(sent.lsAdj)) sent.lsAdj.forEach(e => rekHtml(e,html,null));
    if(sent.arg || isLoad(sent.lsAdj)) html.push("</ul>");
  } else if(sent.type == "verb"){
    addWord(sent.word,html,ctx);
    if(isLoad(sent.lsArg) || isLoad(sent.lsPglg)) html.push("<ul>");
    if(isLoad(sent.lsArg)) sent.lsArg.forEach((e,i) => rekHtml(e,html,hintArg+(i+1)));
    if(isLoad(sent.lsPglg)) sent.lsPglg.forEach((e,i) => rekHtml(e,html,null));
    if(isLoad(sent.lsArg) || isLoad(sent.lsPglg)) html.push("</ul>");
  } else if(sent.type == "adj"){
    html.push(sent.word);
    if(sent.arg) html.push("<ul>");
    if(sent.arg) rekHtml(sent.arg,html,hintArg);
    if(sent.arg) html.push("</ul>");
  } else if(sent.type == "pglg"){
    html.push(sent.word);
    if(sent.arg) html.push("<ul>");
    if(sent.arg) rekHtml(sent.arg,html,hintArg);
    if(sent.arg) html.push("</ul>");
  }

  else throw "unknown type: "+sent.type
  html.push("</li>");
}

function addWord(word,html,ctx){
  if(ctx) html.push(word + " "+ctx);
  else html.push(word);
}

function isLoad(list){
  return list && list.length
}