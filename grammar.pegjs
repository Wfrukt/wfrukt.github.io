{
function isLoad(list){
  return list && list.length
}

function createVerb(word,lsArg,lsPglg1,lsPglg2){
  let lsPglg = [];
  if(isLoad(lsPglg1)) lsPglg = lsPglg.concat(lsPglg1);
  if(isLoad(lsPglg2)) lsPglg = lsPglg.concat(lsPglg2);
  let debug = word+"("+lsArg.map(e => e.debug).join(" ");
  if(isLoad(lsPglg)) debug = debug + " "+lsPglg.map(e => e.debug).join(" ");
  debug = debug + ")";
  return { type: "verb", word, lsArg, lsPglg, debug };
}

function createNoun(word,lsAdj,arg){
  let debug = word;
  if(isLoad(lsAdj)) debug = debug +"["+ lsAdj.map(e => e.debug).join(" ")+"]";
  if(arg) debug = debug + "#" + arg.debug;
  return { type: "noun", word, lsAdj,arg, debug };
}

function createAdj(word,arg){
  let debug = word;
  if(arg) debug = debug + "#" + arg.debug;
  return { type: "adj", word, arg, debug };
}

function createPglg(word,arg){
  let debug = word;
  if(arg) debug = debug + "#" + arg.debug;
  return { type: "pglg", word, arg, debug };
}

function createList(head,tail){
  tail.unshift(head);
  return tail;
}
}

sentence = _ arg:arg { return arg; }

arg "arg" = verbPhrase / nounPhrase

verbPhrase "verbPhrase" =  word:verb2 lsPrlg1:listPglg? arg1:arg arg2:arg lsPrlg2:listPglg? {
  return createVerb(word,[arg1,arg2],lsPrlg1,lsPrlg2);
} / word:verb1 lsPrlg1:listPglg? arg1:arg lsPrlg2:listPglg?{
  return createVerb(word,[arg1],lsPrlg1,lsPrlg2);
}

nounPhrase "nounPhrase" =  word:noun1 lsAdj:listAdj? arg:arg  {
   return createNoun(word,lsAdj,arg);
} / word:noun0 lsAdj:listAdj? {
   return createNoun(word,lsAdj,null);
}

listAdj "listAdj" = head:adjPhrase tail:adjPhrase* {
  return createList(head,tail);
}

listPglg "listPrgl" = head:pglgPhrase tail:pglgPhrase* {
  return createList(head,tail);
}

pglgPhrase = word:pglg1 arg:arg {
  return createPglg(word,arg);
} / word:pglg0 {
  return createPglg(word,null);
}

adjPhrase = word:adj1 arg:arg {
  return createAdj(word,arg);
} / word:adj0 {
  return createAdj(word,null);
}

verb2 "verb2" = (!tailVerb2 prefix)* tailVerb2 { return text().trim(); }
verb1 "verb1" = (!tailVerb1 prefix)* tailVerb1 { return text().trim(); }
noun0 "noun0" = (!tailNoun0 prefix)* tailNoun0 { return text().trim(); }
noun1 "noun1" = (!tailNoun1 prefix)* tailNoun1 { return text().trim(); }
adj0 "adj0" = (!tailAdj0 prefix)* tailAdj0 { return text().trim(); }
adj1 "adj1" = (!tailAdj1 prefix)* tailAdj1 { return text().trim(); }
pglg0 "pglg0" = (!tailPglg0 prefix)* tailPglg0 { return text().trim(); }
pglg1 "pglg1" = (!tailPglg1 prefix)* tailPglg1 { return text().trim(); }

tailVerb1 "tailNoun1" = tors1 endVerb
tailVerb2 "tailNoun2" = tors2 endVerb
tailNoun0 "tailNoun0" = tors1 endNoun
tailNoun1 "tailNoun1" = tors2 endNoun
tailAdj0 "tailAdj0" = tors1 endAdj
tailAdj1 "tailAdj1" = tors2 endAdj
tailPglg0 "tailPglg0" = tors1 endPglg
tailPglg1 "tailPglg1" = tors2 endPglg

tors1 "tors1" = (rootVerb ("ul"/"eg"/"as") / rootNoun)
tors2 "tors2" = rootVerb ("ot"/"ap"/"id")?

endVerb "endAdj" = "i" eow
endNoun "endNoun" = "o" eow
endAdj "endAdj" = "a" eow
endPglg "endPrlg" = "e" eow

rootNoun "rootNoun" = ksntButN vcl ksntButN
rootVerb "rootVerb" = ksnt vcl "n"
prefix "prefix" = ksnt vcl "j"?

ksnt "consonant" = [rtpsdfghklzxcvbnm]
ksntButN "consonantWithoutN" = [rtpsdfghklzxcvbm]
vcl "vowel" = [aouie]

eow = " " / !.

_ "whitespace"
  = [ \t\n\r]*
