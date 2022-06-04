package visitor;
import syntaxtree.*;
import java.util.*;

public class liveAnalysis {
      public HashMap<Integer, Set<Integer> > in =  new HashMap<Integer, Set<Integer> >(); 
      public HashMap<Integer, Set<Integer> > out = new HashMap<Integer, Set<Integer> >(); 
      public HashMap<Integer,Integer> liveStartpoint = new HashMap<Integer,Integer>();
      public HashMap<Integer,Integer> liveEndpoint = new HashMap<Integer,Integer>(); 

      public void rangeCalculation(int begin,int end,liveAnalysis intervalFinding,HashMap <Integer, HashMap <Integer, Set<Integer> >> variableInfo){
 

        int p = begin;

        while(p<=end){
                    Set<Integer> temp1 = variableInfo.get(1).get(p);

                    Iterator<Integer> itr = variableInfo.get(1).get(p).iterator();
                    
                    for(Integer j : temp1){
                       if(!intervalFinding.liveStartpoint.containsKey(j)){
                               intervalFinding.liveStartpoint.put(j,p);
                               intervalFinding.liveEndpoint.put(j,p);
                         }
                        else
                                 if(intervalFinding.liveEndpoint.get(j)<p){
                                      intervalFinding.liveEndpoint.put(j, p);
                                   }
        
                                  for(Integer k : intervalFinding.in.get(p)){
                                       if(!intervalFinding.liveEndpoint.containsKey(k)){
                                                  intervalFinding.liveEndpoint.put(k,p);
                                        }
                                        else{
                                            if(intervalFinding.liveEndpoint.get(k)<p){
                                                     intervalFinding.liveEndpoint.put(k,p);
                                         }
                           }
         
                   }
           }   
           p++;
        }
 }

};