public class SumTemplate {

  public static <T> T sum(T i1, T i2) {
    return i1 + i2;
  }

  public static void main(String[] args) {
    int x = 10;
    int y = 20;
    int z = sum(x, y);
    System.out.println(z);
  }
}
