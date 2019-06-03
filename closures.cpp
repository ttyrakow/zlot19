#include <functional>
#include <iostream>
#include <vector>

int main(void) {
    std::vector< std::function<void (void)> > fcs;
    for (int i = 0; i <= 3; i++) {
        fcs.push_back(
            [i] () -> void {
                std::cout << i << std::endl;
            }
        );
    }
    for (int j = 0; j <= 3; j++) {
        fcs[j](); // 0, 1, 2, 3
    }

    fcs.clear();
    for (int i = 0; i <= 3; i++) {
        fcs.push_back(
            [&i] () -> void {
                std::cout << i << std::endl;
            }
        );
    }
    for (int j = 0; j <= 3; j++) {
        fcs[j](); // 4, 4, 4, 4
    }
    return 0;
}



