var prog = 100;
var mnoznik = 3;
var tab = [10, 20, 30, 40, 50];
var res = tab.map(function (it) {
    return it * mnoznik;
}).filter(function (it) {
    return it > prog;
}).reduce(function (wynik, it) {
    return wynik + it;
}, 0);
// res = 270
console.log(res);


var i = 10;
setTimeout(
    function () {
        i = i + 5;
        console.log(i);
    },
    500
);

