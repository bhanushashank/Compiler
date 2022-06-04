import syntaxtree.*;
import visitor.*;

public class A5 {
   public static void main(String [] args) {
      try {
         Node cry = new MiniRAParser(System.in).Goal();
         cry.accept(new Codegeneration(),null); // Your assignment part is invoked here.
         
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 

