const prog: number = 100;
const mnoznik: number = 3;

const tab: number[] = [10, 20, 30, 40, 50];
var res: number = 
    tab.map(function (it) {
            return it * mnoznik;
        }
    ).filter(function (it) {
        return it > prog;
    }).reduce(function(wynik, it) {
            return wynik + it;
        },
        0
    );
// res = 270

console.log(res);
