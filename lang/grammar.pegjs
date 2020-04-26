{

function createVerb(word,lsArg){
  let html = ["<li>",word];
  if(lsArg && lsArg.length){
  	html.push("<ul>");
    lsArg.forEach(e => {html.push(e.html);});
    html.push("</ul>");
  }
  html.push("</li>");
  return { type: "verb", word, lsArg, html: html.join("") }
}

}

sentence = _ arg:arg { return arg }

arg "arg" = verbPhrase / nounPhrase

nounPhrase "nounPhrase" = noun:noun _ list:(listAdj)? {
  let html = ["<li>",noun];
  if(list && list.length){
  	html.push("<ul>");
    list.forEach(e => {html.push(e.html);});
    html.push("</ul>");
  }
  html.push("</li>");
  let obj = { type: "noun", word: noun, lsAdj: list, html: html.join("") };
  return obj;
}

listAdj "listAdj" = head:adj tail:(_ adj)* {
  let list = tail.map(elem => {return elem[1]});
  list.unshift(head);
  return list.map(e => {
  	return { type: "adj", word: e, arg: null, html:"<li>"+e+"</li>" }
  });
}

verbPhrase "verbPhrase" = verbPhrase2 / verbPhrase1

verbPhrase1 "verbPhrase1" = word:verb1 _ arg1:arg {
  return createVerb(word,[arg1]);
}

verbPhrase2 "verbPhrase2" = word:verb2 _ arg1:arg _ arg2:arg {
  return createVerb(word,[arg1,arg2]);
}

verb2 "verb2" = (!endVerb [a-z])+ endVerb { return text().trim(); }

verb1 "verb1" = (!endVerb [a-z])+ endVerb { return text().trim(); }

noun "noun" = (!endNoun [a-z])+ endNoun { return text().trim(); }

adj "adj" = (!endAdj [a-z])+ endAdj { return text().trim(); }

endNoun "endNoun" = "o" (" " / eof)

endVerb "endVerb" = "i" (" " / eof)

endAdj "endAdj" = "a" (" " / eof)

root "root" = [a-z]+

eof = !.

_ "whitespace"
  = [ \t\n\r]*