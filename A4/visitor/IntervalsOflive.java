package visitor;
import syntaxtree.*;
import java.util.*;

public class IntervalsOflive implements Comparator<IntervalsOflive>,Comparable<IntervalsOflive> {
      int start,end,temporaryNumber;
      public int compareTo(IntervalsOflive a){
         if(start == a.start){ 
              return end - a.end;
         }
         else{
            return start - a.start;
         }
      }
      public int compare(IntervalsOflive a, IntervalsOflive b){
            if(a.start==b.start){ 
                  return (a.end-b.end);
            }
            else{
                  return a.start - b.start;
            }
      }
};