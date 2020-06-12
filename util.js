function load(name,fn){
  fetch(name).then(response => response.text()).then(text => fn(text));
}