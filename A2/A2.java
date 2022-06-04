import syntaxtree.*;
import visitor.*;

public class A2{
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();

         //Symbol Table Creation
         Object  symbolTableData = root.accept(new GJDepthFirst(),null);

         //Type Checking Phase
         root.accept(new TypeCheckingPhase(),symbolTableData);
         System.out.println("Program type checked successfully"); // Your assignment part is invoked here.
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 

