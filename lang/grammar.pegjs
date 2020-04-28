{

function createVerb(word,lsArg){
  let debug = word+"("+lsArg.map(e => e.debug).join(" ")+")";
  return { type: "verb", word, lsArg, debug }
}

}

sentence = _ arg:arg { return arg }

arg "arg" = verbPhrase / nounPhrase

nounPhrase "nounPhrase" = word:noun _ lsAdj:(listAdj)? {
  let debug = [word];
  if(lsAdj && lsAdj.length){
    debug.push("[");
    lsAdj.forEach(e => {
        debug.push(e.debug);
    });
    debug.pop();
    debug.push("]");
  }
  return { type: "noun", word, lsAdj, debug:debug.join("") };
}

listAdj "listAdj" = head:adj tail:(_ adj)* {
  let list = tail.map(elem => {return elem[1]});
  list.unshift(head);
  return list.map(e => {
  	return { type: "adj", word: e, arg: null,debug:e };
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

endNoun "endNoun" = "o" eow

endVerb "endVerb" = ("ani" / "uli" / "egi" / "oti") eow

endAdj "endAdj" = "a" eow

root "root" = [a-z]+

eow = " " / !.

_ "whitespace"
  = [ \t\n\r]*

/*
{

function createVerb(word,lsArg){
  let debug = word+"("+lsArg.map(e => e.debug).join(" ")+")";
  return { type: "verb", word, lsArg, debug }
}

}
/*
sentence = arg:arg { return arg.debug }

arg "arg" = verbPhrase / nounPhrase

nounPhrase "nounPhrase" = (word:noun _ lsAdj:listAdj? arg) / (word:noun _ lsAdj:listAdj?){
  let debug = [word];
  if(lsAdj && lsAdj.length){
    debug.push("[");
    lsAdj.forEach(e => {
        debug.push(e.debug);
    });
    debug.pop();
    debug.push("]");
  }
  return { type: "noun", word, lsAdj, debug:debug.join("") };
}



verbPhrase "verbPhrase" = verbPhrase2 / verbPhrase1

verbPhrase1 "verbPhrase1" = word:verb1 _ arg1:arg {
  return createVerb(word,[arg1]);
}

verbPhrase2 "verbPhrase2" = word:verb2 _ arg1:arg _ arg2:arg {
  return createVerb(word,[arg1,arg2]);
}

verb2 "verb2" = (!endVerb2 [a-z])+ endVerb2 { return text().trim(); }

verb1 "verb1" = (!endVerb [a-z])+ endVerb { return text().trim(); }
*/
sentence = _ arg:arg { return arg.debug }

arg "arg" = nounPhraseA / nounPhrase

nounPhrase "nounPhrase" = word:noun _ lsAdj:listAdj?{
  let debug = [word];
  if(lsAdj && lsAdj.length){
    debug.push("[");
    lsAdj.forEach(e => {
        debug.push(e.debug);
        debug.push(",");
    });
    debug.pop();
    debug.push("]");
  }
  return { type: "noun", word, lsAdj, debug:debug.join("") };
}

nounPhraseA "nounPhraseA" = word:nounA _ lsAdj:listAdj? arg{
  let debug = [word];
  if(lsAdj && lsAdj.length){
    debug.push("[");
    lsAdj.forEach(e => {
        debug.push(e.debug);
        debug.push(",");
    });
    debug.pop();
    debug.push("]");
  }
  return { type: "noun", word, lsAdj, debug:debug.join("") };
}

listAdj "listAdj" = head:adj tail:(_ adj)* {
  let list = tail.map(elem => elem[1]);
  list.unshift(head);
  return list.map(e => {
  	return { type: "adj", word: e, arg: null,debug:e };
  });
}

noun "noun" = (!tailNoun prefix)* tailNoun { return text().trim(); }

tailNoun "tailNoun" = (rootVerb ("ul"/"eg"/"as") / rootNoun) "o" eow

nounA "nounA" = (!tailNounA prefix)* tailNounA { return text().trim(); }

tailNounA "tailNoun" = rootVerb ("ot"/"ap"/"id")? "o" eow

adj "adj" = (!tailAdj [a-z])+ tailAdj { return text().trim(); }

tailAdj "adj" = ksnt "a" eow

endVerb2 "endVerb2" = ("noti" / "napi" / "nidi" / "ni") eow

endVerb "endVerb" = ("nuli" / "negi" / "nasi" / "i" ) eow

endAdj "endAdj" = "a" eow

rootNoun "rootNoun" = ksntButN vcl ksntButN
rootVerb "rootVerb" = ksnt vcl "n"
prefix "prefix" = ksnt vcl "j"?

ksnt "consonant" = [rtpsdfghklzxcvbnm]
ksntButN "consonantWithoutN" = [rtpsdfghklzxcvbm]
vcl "vocalic" = [aouie]

eow = " " / !.

_ "whitespace"
  = [ \t\n\r]*