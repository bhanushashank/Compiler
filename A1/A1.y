%{
//
//    GOAL    :-      MacroJava to MiniJava translator using Flex and Bison
//    Author  :-      This file is written by T.BHANU SHASHANK(CS19B043)
//    
#include<stdio.h>
#include<stdbool.h>
#include<stdlib.h>
#include<string.h>
extern int yylex();
extern int yylineno;
void yyerror( );

char* convert1(char* a){
	int len = strlen(a);
	char *ans = (char*)malloc((len+1)*sizeof(char));
	sprintf(ans,"%s",a);
	return ans;
}

//Function to combine two strings
char* convert2(char* a,char* b){
	int len = strlen(a);
	len += strlen(b);
	char *ans = (char*)malloc((len+2)*sizeof(char));
	sprintf(ans,"%s %s",a,b);
	return ans;
}

//Function to combine three strings
char* convert3(char* a,char* b,char* c){
	int len = strlen(a);
	len += strlen(b);
	len += strlen(c);
	char *ans = (char*)malloc((len+3)*sizeof(char));
	sprintf(ans,"%s %s %s",a,b,c);
	return ans;
} 

int CurrentNumOfMacros=0;	//Contains number of macros stored till that point

//DataTyepe for storing Macros
struct MacroData{
    char* IDENTITY;
    char* replacement;		//replacement of the macro statement and expression
    int numarg[2];
    char** arg;
} ; 
    
struct MacroData array[2000]; //Declaring space for macro's

//Checking the character validation
int valid_char(char a){
	if(a>='a' && a<='z'){
		return 1;
	}
	if(a>='A' && a<= 'Z'){
		return 1;
	}	
	if(a>='0' && a<='9'){
		return 1;
	}
	if(a == '_'){
		return 1;
	}
    return 0;
}

char** getArg(char* argumentarray,int * num){
      if(argumentarray == NULL){
      		*num=0;
      		return NULL;
      	}
      *num=1;
      int i = 0 ;
      int l = strlen(argumentarray);
      while(i<l){
        if(argumentarray[i]==',')
        (*num)++;
        i++;
        }
      
      char** ans=(char**)malloc(((*num)+2)*sizeof(char*));
       for(int i=0;i<(*num);i++){
           ans[i] = (char*)malloc((l+5)*sizeof(char));
       }
      int k=0,j=0;
      for(int i=0;i<l;i++){
        	if(argumentarray[i]==','){
        		ans[k][j] = '\0';
         		k++;
         		j=0;
         	}
         	else{
         		ans[k][j] = argumentarray[i];
            		j++;
         	}	
      }
       ans[k][j]='\0';
       return ans;
  }
  
//Checking the Validation of Macro
void checker(char* idf){
	int i = 0;
        while(i<CurrentNumOfMacros){
        	if(strcmp(idf,array[i].IDENTITY)==0){
                	printf("//Failed to parse input code");
                	exit(0);
             	}
             	i++;
        }
}
   
//Adding new macro to array    
void addMacro(char* idf,char* argumentarray,char* replace,int type){
         checker(idf);				//Function to check whether macro is present previously or not
         //Assigning the macro
        array[CurrentNumOfMacros].IDENTITY=idf;
        array[CurrentNumOfMacros].replacement=replace;
        int a;
        array[CurrentNumOfMacros].arg =  getArg(argumentarray,&a);
        array[CurrentNumOfMacros].numarg[0] = a;
        array[CurrentNumOfMacros].numarg[1] = type;
        CurrentNumOfMacros++;
}

//Replacing the macro with required code
char* replacementOfMacro(char* idf,char* argumentarray,int type){
        int index;char* temp;
        bool ok = false;
        for(index=0;index<CurrentNumOfMacros;index++){
            if(strcmp(array[index].IDENTITY,idf)==0)
                {	
                	if(type==array[index].numarg[1]){
                		ok=true;
                		break;
                	}
                }
         }
        //If macro not found then exit the program
        if(!ok)
        {   
        	printf("//Failed to parse input code");
        	exit(0);
        }
        if(argumentarray==NULL){
            if(array[index].numarg[0]==0){
                temp = (char*)malloc((strlen(array[index].replacement)+5)*sizeof(char));
                temp =  strcpy(temp,array[index].replacement);
                return temp;
            }
            printf("//Failed to parse input code");
            exit(0);
        }
        
        int num;
        char** arg = getArg(argumentarray,&num);
        
        if(num!=array[index].numarg[0])
        {  
        	printf("//Failed to parse input code");
        	exit(0);
        }
        char* ans = (char*)malloc(10000*sizeof(char));
        int pos=0;
        ans[0]='\0';
        int l=strlen(array[index].replacement);
        char *a  =  (char*)malloc((l+5)*sizeof(char));
        int k=0;
        a[0]='\0';
        for(int i=0;i<l;i++){
            if(valid_char(array[index].replacement[i])!=0){
            	a[k]=array[index].replacement[i];
                k++;
            }
            else{
            	a[k]='\0';
                for(int j=0;j<array[index].numarg[0];j++){
                    		if(strcmp(array[index].arg[j],a)==0){ 
                        		strcat(ans,arg[j]);
                        		pos+=strlen(arg[j]);
                        		a[0]='\0';
                        		k=0;
                        		break;
                        	}
                 }
                 a[k]='\0';
                 strcat(ans,a);
                 pos+=strlen(a);
                 k=0;
                 ans[pos++]=array[index].replacement[i];
                 ans[pos]='\0';
            }
        }
        return ans;
    }
%}

%union {
	char *text;
	int d;
}

%token <text> CLASS IFCONDITION ELSECONDITION WHILE LEFTB RIGHTB LEFTSB RIGHTSB LEFTCB RIGHTCB LESSTHANEQUAL EQUAL ADD SUB MULTI DIV FALSE TRUE THIS INT DLENGTH PRINTSTATEMENT STRING EXTENDS RETURN BOOL IDENTIFIER NUMBER OTHER END  DEFSTMTZERO DEFSTMTONE DEFSTMTTWO DEFINESTMT DEFEXPRZERO DEFEXPRONE DEFEXPRTWO DEFINEEXPR TAND TOR NTEQUAL SEMICOL AND OR NOT DOT COMMA PUBLIC STATIC VOID MAIN NEW

%start Goal
%type <text> Goal PrimaryExpression Identifier Expression CommaExpression CommaExpressionStar MethodDeclarationStar CommaTypeIden CommaTypeIdentifierStar StatementStar 
%type <text> CommaIdent CommaIdentifierStar TypeDeclarationStar TypeIdenSemiColonStar TypeIdentifierSemicolon MainClass TypeDeclaration MethodDeclaration Type Statement 
%type <text> MacroStatement MacroExpression


%%
Goal :  MacroDefinitionStar MainClass TypeDeclarationStar {
									$$ = convert2($2,$3);
									printf("%s\n",$$);		
							   };

MacroDefinitionStar : {}
					| MacroDefinition MacroDefinitionStar ;
TypeDeclarationStar : 			{
                                               $$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
                                       }
		| TypeDeclaration TypeDeclarationStar   {
						$$ = convert2($1,$2); 
		};

MainClass : CLASS Identifier LEFTCB PUBLIC STATIC VOID MAIN LEFTB STRING LEFTSB RIGHTSB Identifier RIGHTB LEFTCB PRINTSTATEMENT LEFTB Expression RIGHTB SEMICOL RIGHTCB RIGHTCB {
																																									$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+strlen($9)+strlen($10)+strlen($11)+strlen($12)+strlen($13)+strlen($14)+strlen($15)+strlen($16)+strlen($17)+strlen($18)+strlen($19)+strlen($20)+strlen($21)+22)*sizeof(char));
																																									sprintf($$,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21);
																																								  };
TypeDeclaration : 	CLASS Identifier LEFTCB TypeIdenSemiColonStar MethodDeclarationStar RIGHTCB {
			$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+6)*sizeof(char));
			sprintf($$,"%s %s %s\n%s %s\n%s",$1,$2,$3,$4,$5,$6);
		  }				 
	| 	CLASS Identifier EXTENDS Identifier LEFTCB TypeIdenSemiColonStar MethodDeclarationStar RIGHTCB {
					$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+8)*sizeof(char));
					sprintf($$,"%s %s %s %s %s\n%s %s\n%s",$1,$2,$3,$4,$5,$6,$7,$8);
                              };

TypeIdenSemiColonStar :   {
                                 $$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
                          }
					  
		      | TypeIdenSemiColonStar TypeIdentifierSemicolon   {
				$$ = convert2($1,$2);
		        };	

TypeIdentifierSemicolon : Type Identifier SEMICOL  {sprintf($$,"%s %s %s",$1,$2,$3);};

MethodDeclarationStar :  			
							{
									$$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
							}																					    																															 
		 |MethodDeclarationStar MethodDeclaration  		{
											$$ = convert2($1,$2);
									};	

MethodDeclaration : PUBLIC Type Identifier LEFTB RIGHTB LEFTCB TypeIdenSemiColonStar StatementStar RETURN Expression SEMICOL RIGHTCB  {
		  $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+strlen($9)+strlen($10)+strlen($11)+strlen($12)+12)*sizeof(char));
		  sprintf($$,"%s %s %s %s %s\n%s %s %s %s %s %s\n%s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);	
	}
	| PUBLIC Type Identifier LEFTB Type Identifier CommaTypeIdentifierStar RIGHTB LEFTCB TypeIdenSemiColonStar StatementStar RETURN Expression SEMICOL RIGHTCB {
$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+strlen($9)+strlen($10)+strlen($11)+strlen($12)+strlen($13)+strlen($14)+strlen($15)+15)*sizeof(char));
	sprintf($$,"%s %s %s %s %s %s %s %s %s\n%s %s %s %s %s\n%s",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15);
       };

CommaTypeIdentifierStar : 			{
							$$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
						}
	| CommaTypeIdentifierStar CommaTypeIden   {
							$$ = convert2($1,$2);
						};

CommaTypeIden : COMMA Type Identifier                                   {sprintf($$,"%s %s %s",$1,$2,$3);};

Type : INT LEFTSB RIGHTSB  		{
				  					$$ = convert3($1,$2,$3);
				        }
	 | BOOL  		        {
								       $$ = convert1($1);
				        }
	 | INT   		        {
									$$ = convert1($1);
					}
	 | Identifier  		{
									$$ = convert1($1);
				        };

Statement : LEFTCB StatementStar RIGHTCB               {
				  				       $$ = convert3($1,$2,$3);
				  	               }							 
          | Identifier EQUAL Expression SEMICOL 	{
				  				       $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+4)*sizeof(char));
				  					sprintf($$,"%s %s %s %s",$1,$2,$3,$4);
				  			}		 
         | PRINTSTATEMENT LEFTB Expression RIGHTB SEMICOL 	{
				  					$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+5)*sizeof(char));
				  				        sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
				  			}	 
	| Identifier LEFTSB Expression RIGHTSB EQUAL Expression SEMICOL {
		   							$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+7)*sizeof(char));
		   							sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);
		   					}  
	| IFCONDITION LEFTB Expression RIGHTB Statement 	{
				  				       $$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+5)*sizeof(char));
				  				       sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
				  			} 
	| IFCONDITION LEFTB Expression RIGHTB Statement ELSECONDITION Statement {
		   							$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+7)*sizeof(char));
		   							sprintf($$,"%s %s %s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);
		   						} 
	| WHILE LEFTB Expression RIGHTB Statement   	{
				  					$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+5)*sizeof(char));
				  					sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
							} 
	| MacroStatement 				{
									$$ = convert1($1);
							};

MacroStatement : Identifier LEFTB RIGHTB SEMICOL 	{ 
									$$ = replacementOfMacro($1,NULL,1);
							}							 
			   
	        | Identifier LEFTB Expression CommaExpressionStar RIGHTB SEMICOL 	{
			   									char* argl=(char*)malloc((strlen($3)+strlen($4)+2)*sizeof(char));
			   									strcpy(argl,$3);
			   									strcat(argl,$4);
			   									$$ = replacementOfMacro($1, argl, 1);
			   								};

StatementStar :  	                              {      
				                               $$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
			                              }
			  |  Statement StatementStar  {
								$$ = convert2($1,$2);
			                               };


Expression : PrimaryExpression TAND PrimaryExpression        {
				  				       $$ = convert3($1,$2,$3);
				  			        }	 
	| PrimaryExpression LESSTHANEQUAL PrimaryExpression 	{
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression ADD PrimaryExpression 		{
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression SUB PrimaryExpression  		{
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression TOR PrimaryExpression  		{
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression NTEQUAL PrimaryExpression 	 {
				  					$$ = convert3($1,$2,$3);
				  				}	 
	| PrimaryExpression MULTI PrimaryExpression 		 {
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression DIV PrimaryExpression 		 {
				  					$$ = convert3($1,$2,$3);
				  				}
	| PrimaryExpression LEFTSB PrimaryExpression RIGHTSB   {
				  					$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+4)*sizeof(char));
				  					sprintf($$,"%s %s %s %s",$1,$2,$3,$4);
				  				}
	| PrimaryExpression DLENGTH 			{
									$$ = (char*)malloc((strlen($1)+strlen($2)+2)*sizeof(char));
				  					sprintf($$,"%s%s",$1,$2);
								}
	| PrimaryExpression					{
									$$ = convert1($1);
								}
	| PrimaryExpression DOT Identifier LEFTB RIGHTB 	 {
				  					$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+5)*sizeof(char));
				  					sprintf($$,"%s%s%s %s %s",$1,$2,$3,$4,$5);
				  				}
	| PrimaryExpression DOT Identifier LEFTB Expression CommaExpressionStar RIGHTB 	{
		   							$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+7)*sizeof(char));
		   							sprintf($$,"%s%s%s %s %s %s %s",$1,$2,$3,$4,$5,$6,$7);
		   						} 
	| MacroExpression 					{
									$$ = convert1($1);
								};

MacroExpression : Identifier LEFTB Expression CommaExpressionStar RIGHTB  {
										char* argl=(char*)malloc((strlen($3)+strlen($4)+2)*sizeof(char));
										strcpy(argl,$3);
										strcat(argl,$4);
										$$ = replacementOfMacro($1, argl, 0);
									   }
		| Identifier LEFTB RIGHTB 				   { 
										$$ = replacementOfMacro($1,NULL,0); 
									  };


CommaExpressionStar : 	 		{
						$$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
					}
		|CommaExpressionStar CommaExpression  {
						$$ = convert2($1,$2);
					};

CommaExpression : COMMA Expression 	{
						$$ = convert2($1,$2);
					};					 

PrimaryExpression : NUMBER 		{
						$$ = convert1($1);
					}
		   | TRUE 		{
						$$ = convert1($1);
					}
		  | FALSE 		{
						$$ = convert1($1);
					}
		| Identifier  		{
						$$ = convert1($1);
					}
		| THIS			{
						$$ = convert1($1);
					}
		| NEW INT LEFTSB Expression RIGHTSB  	{
				  		$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+5)*sizeof(char));
				  		sprintf($$,"%s %s %s %s %s",$1,$2,$3,$4,$5);
				  	}
		| NEW Identifier LEFTB RIGHTB         {
				  		$$ = (char*)malloc((strlen($1)+strlen($2)+strlen($3)+strlen($4)+4)*sizeof(char));
				  		sprintf($$,"%s %s %s %s",$1,$2,$3,$4);
				  	}
		| NOT Expression  	{
						$$ = convert2($1,$2);
					}
		| LEFTB Expression RIGHTB     {
						sprintf($$,"%s %s %s",$1,$2,$3);
					};

Identifier : IDENTIFIER    		{
						$$ = convert1($1);
					};

MacroDefinition : MacroDefExpression
				| MacroDefStatement ;

MacroDefStatement  : DEFSTMTZERO Identifier LEFTB RIGHTB LEFTCB StatementStar RIGHTCB  {
						char* rep=(char*)malloc((strlen($6)+5)*sizeof(char));
						strcpy(rep,"{");
						strcat(rep,$6);
						strcat(rep,"}");
						addMacro($2, NULL, rep, 1);
				}
		| DEFSTMTONE Identifier LEFTB Identifier RIGHTB LEFTCB StatementStar RIGHTCB{
					   	char* rep=(char*)malloc((strlen($7)+5)*sizeof(char));
						 strcpy(rep,"{");
						strcat(rep,$7);
						 strcat(rep,"}");
						 char* argl=(char*)malloc((strlen($4)+3)*sizeof(char));
						 strcpy(argl,$4);
						 addMacro($2, argl, rep, 1);
				}
	       | DEFSTMTTWO Identifier LEFTB Identifier COMMA Identifier RIGHTB LEFTCB StatementStar RIGHTCB	{
 						char* rep=(char*)malloc((strlen($9)+5)*sizeof(char));
						 strcpy(rep,"{");
						 strcat(rep,$9);
						 strcat(rep,"}");
						char* argl=(char*)malloc((strlen($4)+strlen($5)+strlen($6)+3)*sizeof(char));
						 strcpy(argl,$4);
						 strcat(argl,$5);
						 strcat(argl,$6);
						addMacro($2, argl, rep, 1);
			   }
		| DEFINESTMT Identifier LEFTB Identifier CommaIdentifierStar RIGHTB LEFTCB StatementStar RIGHTCB 	{
						 char* argl=(char*)malloc((strlen($4)+strlen($5)+3)*sizeof(char));
						 strcpy(argl,$4);
						 strcat(argl,$5);	
						char* rep=(char*)malloc((strlen($8)+5)*sizeof(char));
						strcpy(rep,"{");
						strcat(rep,$8);
						strcat(rep,"}");
						addMacro($2, argl, rep, 1);
		 };

CommaIdentifierStar :   	{
						$$ = (char*)malloc((1)*sizeof(char));sprintf($$,"");
				}
	|  CommaIdentifierStar CommaIdent        {
									$$ = (char*)malloc((strlen($1)+strlen($2))*sizeof(char)); 
									sprintf($$,"%s%s",$1,$2);
						};

CommaIdent : COMMA Identifier  {
						$$ = (char*)malloc((strlen($1)+strlen($2))*sizeof(char)); 
						sprintf($$,"%s%s",$1,$2);
				};

MacroDefExpression : DEFEXPRZERO Identifier LEFTB RIGHTB LEFTB Expression RIGHTB 	{
						char* rep=(char*)malloc((strlen($6)+5)*sizeof(char));
						strcpy(rep,"(");
						strcat(rep,$6);
						strcat(rep,")");
						addMacro($2, NULL, rep,0);
			 }
	| DEFEXPRONE Identifier LEFTB Identifier RIGHTB LEFTB Expression RIGHTB     {
					   	char* rep=(char*)malloc((strlen($7)+5)*sizeof(char));
						strcpy(rep,"(");
						strcat(rep,$7);
						strcat(rep,")");
						char* argl=(char*)malloc((strlen($4)+3)*sizeof(char));
						 strcpy(argl,$4);
						 addMacro($2, argl, rep, 0);
			}
 	| DEFEXPRTWO Identifier LEFTB Identifier COMMA Identifier RIGHTB LEFTB Expression RIGHTB         {
					   	char* rep=(char*)malloc((strlen($9)+5)*sizeof(char));
						strcpy(rep,"(");
						strcat(rep,$9);
						strcat(rep,")");
						char* argl=(char*)malloc((strlen($4)+strlen($5)+strlen($6)+3)*sizeof(char));
						strcpy(argl,$4);
						strcat(argl,$5);
						strcat(argl,$6);
						addMacro($2, argl, rep, 0);
		    }
	| DEFINEEXPR Identifier LEFTB Identifier CommaIdentifierStar RIGHTB LEFTB Expression RIGHTB  		{
						char* argl=(char*)malloc((strlen($4)+strlen($5)+3)*sizeof(char));
					       strcpy(argl,$4);
						strcat(argl,$5);	
						 char* rep=(char*)malloc((strlen($8)+5)*sizeof(char));
						strcpy(rep,"(");
						strcat(rep,$8);
						strcat(rep,")");
						addMacro($2, argl, rep, 0);
			};  
		           
%%

void yyerror( ) {
	printf("//Failed to parse input code");
	exit(0);
}

int main(){
	yyparse();
}
