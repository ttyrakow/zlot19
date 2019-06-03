val mnoznik = 3
val prog = 100

fun main() {
    val tab = arrayOf(10, 20, 30, 40, 50)
    val res = tab
        .map { it * mnoznik }
        .filter { it > prog }
        .reduce { acc, it -> acc + it }
    // res = 270
    println(res)
}
