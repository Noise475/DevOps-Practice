public class MicroBenchTest
{

    static class Node {
        String text;
        Node next;

        public Node(String text) {
            this.text = text;
        }
        
        // used for building the list
        public Node add(String text) {
            next = new Node(text);
            return next;
        }
        
    }

    // this is the recursive method concat
    public static String concat(Node node) {
        if (node == null)
            return "";

        return node.text + " " + concat(node.next);
    }

    public static void main(String[] argv) {
        // build the list
        Node head = new Node("hello");
        head.add("this").add("is").add("a").add("linked").add("list");

        // print the result of concat
        System.out.println(concat(head));
         
      
          long start = System.currentTimeMillis();
          for (int ii = 0 ; ii < 1000000 ; ii++)
          {
             concat(head);
          }
          long elapsed = System.currentTimeMillis() - start;
          System.out.println("elapsed time = " + elapsed + "ms");
          System.out.println((elapsed * 1000.0) / 1000000 + " microseconds per execution");
      

    }
}