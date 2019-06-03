var i, j;

fcs = [];
for (i = 0; i <= 3; i++) {
    fcs.push(function () {
        console.log(i);
    });
}
for (j = 0; j <= 3; j++) {
    fcs[j]();
    // 4, 4, 4, 4
}

fcs = [];
for (i = 0; i <= 3; i++) {
    fcs.push(() => {
        console.log(i);
    });
}
for (j = 0; j <= 3; j++) {
    fcs[j]();
}
// 4, 4, 4, 4

fcs = [];
for (i = 0; i <= 3; i++) {
    fcs.push(
        function (x) {
            return function () {
                console.log(x);
            };
        }(i)
    );
}
for (j = 0; j <= 3; j++) {
    fcs[j]();
    // 0, 1, 2, 3
}
