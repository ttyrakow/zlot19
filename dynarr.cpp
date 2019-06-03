#include <functional>
#include <numeric>
#include <iostream>
#include <algorithm>
#include <vector>

template<class T> class TVec: public std::vector<T> {
public:
    TVec(): std::vector<T>() {};
    TVec(const TVec<T>& v): std::vector<T>(v.begin(), v.end()) {};
    TVec (std::initializer_list<T> il): std::vector<T>(il) {};
    TVec<T> map(std::function<T (const T&)> mapFunc);
    TVec<T> filter(std::function<bool (const T&)> filterFunc);
    T reduce(std::function<T (const T&, const T&)> reduceFunc, const T& initial);
};

template<class T> TVec<T> TVec<T>::map(std::function<T (const T&)> mapFunc) {
    TVec<T> res;
    std::transform(
        this->begin(), this->end(), 
        std::back_inserter(res),
        mapFunc
    );
    return res;
}

template<class T> TVec<T> TVec<T>::filter(std::function<bool (const T&)> filterFunc) {
    TVec<T> res;
    std::copy_if(
        this->begin(), this->end(), 
        std::back_inserter(res),
        filterFunc
    );
    return res;
}

template<class T> T TVec<T>::reduce(std::function<T (const T&, const T&)> reduceFunc, const T& initial) {
    return std::accumulate(
        this->begin(), this->end(),
        initial, reduceFunc
    );
}

const int mnoznik = 3;
const int prog = 100;
int main(void) {
    TVec<int> tab({10, 20, 30, 40, 50});
    auto res =
        tab.map([=] (int it) -> int { 
                return it * mnoznik; 
            }
        ).filter([=] (int it) -> int { 
                return it > prog; 
            }
        ).reduce([] (int wynik, int it) -> int { 
                return wynik + it; 
            },
            0
        );
    // 270
    std::cout << res << std::endl;
    return 0;
}



