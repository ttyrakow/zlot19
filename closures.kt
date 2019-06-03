fun main() {
    val fcs = mutableListOf<() -> Unit>()
    for (i: Int in 0..3) {
        fcs.add({ println(i) })
    }
    for (j: Int in 0..3) {
        fcs[j]() // 0, 1, 2, 3
    }
}
