import java.io.FileInputStream;
import java.io.FileNotFoundException;

import syntaxtree.*;
import visitor.*;

public class A3 {
   public static void main(String [] args)  {
      try {
          Node root = new MiniJavaParser(System.in).Goal();
         
         Object table=root.accept(new phase1(),null);

         root.accept(new phase2(),table);
         
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 



