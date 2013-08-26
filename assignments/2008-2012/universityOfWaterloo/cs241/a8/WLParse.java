import java.io.*;
import java.util.*;
public class WLParse {
  
  public static class Tree {
    String rule;
    List <Tree>children = new ArrayList<Tree>();
  }

  public static void main (String [] args)
{
  List <String>code = new ArrayList<String>();
  List <String>inputline = new ArrayList<String>();
  HashMap <String,String>production = new HashMap<String, String>();
  HashMap <String,String>transition = new HashMap<String, String>();
  //set up a wlgrammar cgf-r template excluding the last line
final String wlGrammar=
    "29\n"+
"BECOMES\n"+
"BOF\n"+
"COMMA\n"+
"ELSE\n"+
"EOF\n"+
"EQ\n"+
"GE\n"+
"GT\n"+
"ID\n"+
"IF\n"+
"INT\n"+
"LBRACE\n"+
"LE\n"+
"LPAREN\n"+
"LT\n"+
"MINUS\n"+
"NE\n"+
"NUM\n"+
"PCT\n"+
"PLUS\n"+
"PRINTLN\n"+
"RBRACE\n"+
"RETURN\n"+
"RPAREN\n"+
"SEMI\n"+
"SLASH\n"+
"STAR\n"+
"WAIN\n"+
"WHILE\n"+
"10\n"+
"S\n"+
"dcl\n"+
"dcls\n"+
"expr\n"+
"factor\n"+
"procedure\n"+
"statement\n"+
"statements\n"+
"term\n"+
"test\n"+
"S\n"+
"27\n"+
"S BOF procedure EOF\n"+
"procedure INT WAIN LPAREN dcl COMMA dcl RPAREN LBRACE dcls statements RETURN expr SEMI RBRACE\n"+
"dcls \n"+
"dcls dcls dcl BECOMES NUM SEMI\n"+
"dcl INT ID\n"+
"statements \n"+
"statements statements statement\n"+
"statement ID BECOMES expr SEMI\n"+
"statement IF LPAREN test RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE\n"+
"statement WHILE LPAREN test RPAREN LBRACE statements RBRACE\n"+
"statement PRINTLN LPAREN expr RPAREN SEMI\n"+
"test expr EQ expr\n"+
"test expr NE expr\n"+
"test expr LT expr\n"+
"test expr LE expr\n"+
"test expr GE expr\n"+
"test expr GT expr\n"+
"expr term\n"+
"expr expr PLUS term\n"+
"expr expr MINUS term\n"+
"term factor\n"+
"term term STAR factor\n"+
"term term SLASH factor\n"+
"term term PCT factor\n"+
"factor ID\n"+
"factor NUM\n"+
"factor LPAREN expr RPAREN\n"+
"82\n"+
"394\n"+
"58 PLUS shift 1\n"+
"65 SEMI reduce 23\n"+
"47 WHILE reduce 10\n"+
"31 ID shift 2\n"+
"58 RPAREN reduce 15\n"+
"16 EQ reduce 20\n"+
"55 statement shift 3\n"+
"34 MINUS shift 4\n"+
"3 PRINTLN reduce 6\n"+
"71 ID reduce 5\n"+
"65 EQ reduce 23\n"+
"17 EQ reduce 25\n"+
"54 IF reduce 5\n"+
"22 RPAREN reduce 22\n"+
"22 STAR reduce 22\n"+
"16 GT reduce 20\n"+
"52 LE reduce 18\n"+
"2 GE reduce 24\n"+
"6 LT reduce 17\n"+
"11 LPAREN shift 5\n"+
"60 term shift 6\n"+
"62 PRINTLN reduce 5\n"+
"8 SEMI shift 7\n"+
"64 expr shift 8\n"+
"33 RPAREN shift 9\n"+
"15 RPAREN reduce 13\n"+
"75 COMMA shift 10\n"+
"36 EQ reduce 26\n"+
"80 STAR reduce 21\n"+
"21 INT reduce 3\n"+
"2 SLASH reduce 24\n"+
"66 ID reduce 2\n"+
"40 LPAREN shift 5\n"+
"51 SLASH shift 11\n"+
"79 BECOMES shift 12\n"+
"16 SEMI reduce 20\n"+
"51 LE reduce 19\n"+
"43 IF shift 13\n"+
"22 GT reduce 22\n"+
"31 expr shift 14\n"+
"6 SEMI reduce 17\n"+
"25 expr shift 15\n"+
"69 term shift 6\n"+
"37 factor shift 16\n"+
"76 NUM shift 17\n"+
"22 SLASH reduce 22\n"+
"27 ID shift 2\n"+
"56 RBRACE shift 18\n"+
"56 WHILE shift 19\n"+
"65 NE reduce 23\n"+
"65 GT reduce 23\n"+
"46 RBRACE shift 20\n"+
"76 factor shift 16\n"+
"44 SEMI shift 21\n"+
"6 GT reduce 17\n"+
"11 factor shift 22\n"+
"2 NE reduce 24\n"+
"67 RBRACE reduce 5\n"+
"16 PCT reduce 20\n"+
"66 WHILE reduce 2\n"+
"41 ID shift 2\n"+
"2 STAR reduce 24\n"+
"22 LE reduce 22\n"+
"17 NE reduce 25\n"+
"80 SEMI reduce 21\n"+
"47 RBRACE reduce 10\n"+
"80 NE reduce 21\n"+
"6 NE reduce 17\n"+
"49 factor shift 16\n"+
"6 LE reduce 17\n"+
"17 RPAREN reduce 25\n"+
"5 term shift 6\n"+
"54 ID reduce 5\n"+
"68 EOF shift 23\n"+
"77 LPAREN shift 24\n"+
"16 MINUS reduce 20\n"+
"34 LT shift 25\n"+
"16 RPAREN reduce 20\n"+
"74 MINUS shift 4\n"+
"78 factor shift 16\n"+
"80 EQ reduce 21\n"+
"80 RPAREN reduce 21\n"+
"59 WHILE shift 19\n"+
"16 PLUS reduce 20\n"+
"56 PRINTLN shift 26\n"+
"51 PCT shift 27\n"+
"60 expr shift 28\n"+
"40 NUM shift 17\n"+
"30 RETURN reduce 8\n"+
"62 ID reduce 5\n"+
"6 PLUS reduce 17\n"+
"2 LE reduce 24\n"+
"40 ID shift 2\n"+
"62 IF reduce 5\n"+
"30 WHILE reduce 8\n"+
"52 EQ reduce 18\n"+
"71 IF reduce 5\n"+
"16 NE reduce 20\n"+
"39 IF reduce 9\n"+
"65 LT reduce 23\n"+
"45 ID shift 29\n"+
"65 PCT reduce 23\n"+
"31 LPAREN shift 5\n"+
"14 MINUS shift 4\n"+
"36 GT reduce 26\n"+
"52 SEMI reduce 18\n"+
"59 RBRACE shift 30\n"+
"65 MINUS reduce 23\n"+
"43 RETURN shift 31\n"+
"21 WHILE reduce 3\n"+
"31 factor shift 16\n"+
"36 RPAREN reduce 26\n"+
"18 ELSE shift 32\n"+
"35 RPAREN reduce 11\n"+
"6 RPAREN reduce 17\n"+
"36 STAR reduce 26\n"+
"35 MINUS shift 4\n"+
"8 PLUS shift 1\n"+
"4 factor shift 16\n"+
"76 test shift 33\n"+
"76 expr shift 34\n"+
"76 ID shift 2\n"+
"37 NUM shift 17\n"+
"25 ID shift 2\n"+
"40 expr shift 35\n"+
"30 PRINTLN reduce 8\n"+
"7 WHILE reduce 7\n"+
"63 RPAREN shift 36\n"+
"69 LPAREN shift 5\n"+
"25 LPAREN shift 5\n"+
"5 ID shift 2\n"+
"80 LT reduce 21\n"+
"14 PLUS shift 1\n"+
"34 NE shift 37\n"+
"51 LT reduce 19\n"+
"51 NE reduce 19\n"+
"70 RPAREN shift 38\n"+
"55 RBRACE shift 39\n"+
"34 EQ shift 40\n"+
"41 LPAREN shift 5\n"+
"52 LT reduce 18\n"+
"52 STAR shift 41\n"+
"25 NUM shift 17\n"+
"59 ID shift 42\n"+
"3 RETURN reduce 6\n"+
"60 ID shift 2\n"+
"4 LPAREN shift 5\n"+
"76 term shift 6\n"+
"67 statements shift 43\n"+
"17 GE reduce 25\n"+
"2 MINUS reduce 24\n"+
"17 GT reduce 25\n"+
"30 IF reduce 8\n"+
"12 NUM shift 44\n"+
"59 PRINTLN shift 26\n"+
"10 INT shift 45\n"+
"21 IF reduce 3\n"+
"7 IF reduce 7\n"+
"55 IF shift 13\n"+
"60 factor shift 16\n"+
"39 RBRACE reduce 9\n"+
"64 LPAREN shift 5\n"+
"34 PLUS shift 1\n"+
"36 PCT reduce 26\n"+
"52 GT reduce 18\n"+
"22 SEMI reduce 22\n"+
"59 IF shift 13\n"+
"14 SEMI shift 46\n"+
"67 RETURN reduce 5\n"+
"80 GE reduce 21\n"+
"43 statement shift 3\n"+
"47 PRINTLN reduce 10\n"+
"61 SEMI shift 47\n"+
"66 INT reduce 2\n"+
"22 LT reduce 22\n"+
"7 ID reduce 7\n"+
"62 WHILE reduce 5\n"+
"6 EQ reduce 17\n"+
"65 STAR reduce 23\n"+
"71 WHILE reduce 5\n"+
"2 SEMI reduce 24\n"+
"69 expr shift 48\n"+
"24 INT shift 45\n"+
"36 NE reduce 26\n"+
"71 RETURN reduce 5\n"+
"6 GE reduce 17\n"+
"34 GE shift 49\n"+
"22 GE reduce 22\n"+
"55 ID shift 42\n"+
"66 IF reduce 2\n"+
"6 STAR shift 41\n"+
"31 term shift 6\n"+
"71 PRINTLN reduce 5\n"+
"73 expr shift 50\n"+
"54 WHILE reduce 5\n"+
"37 term shift 6\n"+
"3 RBRACE reduce 6\n"+
"4 term shift 51\n"+
"73 factor shift 16\n"+
"36 SEMI reduce 26\n"+
"65 GE reduce 23\n"+
"1 term shift 52\n"+
"30 ID reduce 8\n"+
"7 RETURN reduce 7\n"+
"52 PCT shift 27\n"+
"4 NUM shift 17\n"+
"51 RPAREN reduce 19\n"+
"2 PLUS reduce 24\n"+
"16 SLASH reduce 20\n"+
"47 ID reduce 10\n"+
"15 PLUS shift 1\n"+
"78 test shift 53\n"+
"51 MINUS reduce 19\n"+
"29 COMMA reduce 4\n"+
"69 factor shift 16\n"+
"49 LPAREN shift 5\n"+
"2 PCT reduce 24\n"+
"51 STAR shift 41\n"+
"52 MINUS reduce 18\n"+
"29 RPAREN reduce 4\n"+
"17 SLASH reduce 25\n"+
"50 MINUS shift 4\n"+
"3 WHILE reduce 6\n"+
"67 ID reduce 5\n"+
"8 MINUS shift 4\n"+
"47 IF reduce 10\n"+
"69 NUM shift 17\n"+
"17 STAR reduce 25\n"+
"29 BECOMES reduce 4\n"+
"78 NUM shift 17\n"+
"80 PLUS reduce 21\n"+
"72 LBRACE shift 54\n"+
"67 IF reduce 5\n"+
"4 ID shift 2\n"+
"71 statements shift 55\n"+
"28 MINUS shift 4\n"+
"30 RBRACE reduce 8\n"+
"28 PLUS shift 1\n"+
"78 ID shift 2\n"+
"31 NUM shift 17\n"+
"22 PCT reduce 22\n"+
"50 PLUS shift 1\n"+
"41 NUM shift 17\n"+
"5 LPAREN shift 5\n"+
"56 ID shift 42\n"+
"1 factor shift 16\n"+
"64 ID shift 2\n"+
"73 NUM shift 17\n"+
"54 statements shift 56\n"+
"43 WHILE shift 19\n"+
"64 factor shift 16\n"+
"0 BOF shift 57\n"+
"52 SLASH shift 11\n"+
"49 expr shift 58\n"+
"67 WHILE reduce 5\n"+
"37 LPAREN shift 5\n"+
"69 ID shift 2\n"+
"5 factor shift 16\n"+
"65 RPAREN reduce 23\n"+
"62 RBRACE reduce 5\n"+
"60 LPAREN shift 5\n"+
"62 statements shift 59\n"+
"78 term shift 6\n"+
"17 PLUS reduce 25\n"+
"65 LE reduce 23\n"+
"34 GT shift 60\n"+
"49 ID shift 2\n"+
"50 RPAREN shift 61\n"+
"16 STAR reduce 20\n"+
"15 MINUS shift 4\n"+
"21 ID reduce 3\n"+
"16 GE reduce 20\n"+
"49 term shift 6\n"+
"54 RBRACE reduce 5\n"+
"62 RETURN reduce 5\n"+
"32 LBRACE shift 62\n"+
"80 GT reduce 21\n"+
"5 expr shift 63\n"+
"55 WHILE shift 19\n"+
"35 PLUS shift 1\n"+
"67 PRINTLN reduce 5\n"+
"39 WHILE reduce 9\n"+
"55 PRINTLN shift 26\n"+
"56 IF shift 13\n"+
"27 NUM shift 17\n"+
"59 statement shift 3\n"+
"54 RETURN reduce 5\n"+
"42 BECOMES shift 64\n"+
"71 RBRACE reduce 5\n"+
"7 RBRACE reduce 7\n"+
"16 LE reduce 20\n"+
"54 PRINTLN reduce 5\n"+
"5 NUM shift 17\n"+
"80 PCT reduce 21\n"+
"6 PCT shift 27\n"+
"27 factor shift 65\n"+
"38 LBRACE shift 66\n"+
"52 GE reduce 18\n"+
"73 term shift 6\n"+
"80 LE reduce 21\n"+
"22 PLUS reduce 22\n"+
"43 ID shift 42\n"+
"48 RPAREN reduce 14\n"+
"51 EQ reduce 19\n"+
"17 SEMI reduce 25\n"+
"51 GE reduce 19\n"+
"66 dcls shift 67\n"+
"2 RPAREN reduce 24\n"+
"64 term shift 6\n"+
"73 LPAREN shift 5\n"+
"21 PRINTLN reduce 3\n"+
"49 NUM shift 17\n"+
"58 MINUS shift 4\n"+
"17 MINUS reduce 25\n"+
"11 ID shift 2\n"+
"39 RETURN reduce 9\n"+
"78 expr shift 34\n"+
"57 procedure shift 68\n"+
"34 LE shift 69\n"+
"63 PLUS shift 1\n"+
"16 LT reduce 20\n"+
"10 dcl shift 70\n"+
"9 LBRACE shift 71\n"+
"22 MINUS reduce 22\n"+
"78 LPAREN shift 5\n"+
"36 LE reduce 26\n"+
"6 SLASH shift 11\n"+
"53 RPAREN shift 72\n"+
"66 PRINTLN reduce 2\n"+
"37 ID shift 2\n"+
"67 INT shift 45\n"+
"65 SLASH reduce 23\n"+
"52 PLUS reduce 18\n"+
"36 LT reduce 26\n"+
"51 SEMI reduce 19\n"+
"26 LPAREN shift 73\n"+
"40 factor shift 16\n"+
"37 expr shift 74\n"+
"40 term shift 6\n"+
"24 dcl shift 75\n"+
"39 ID reduce 9\n"+
"17 PCT reduce 25\n"+
"19 LPAREN shift 76\n"+
"80 SLASH reduce 21\n"+
"81 WAIN shift 77\n"+
"13 LPAREN shift 78\n"+
"67 dcl shift 79\n"+
"20 EOF reduce 1\n"+
"73 ID shift 2\n"+
"1 NUM shift 17\n"+
"74 PLUS shift 1\n"+
"17 LT reduce 25\n"+
"39 PRINTLN reduce 9\n"+
"25 factor shift 16\n"+
"63 MINUS shift 4\n"+
"80 MINUS reduce 21\n"+
"48 MINUS shift 4\n"+
"27 LPAREN shift 5\n"+
"48 PLUS shift 1\n"+
"2 LT reduce 24\n"+
"28 RPAREN reduce 16\n"+
"52 NE reduce 18\n"+
"1 LPAREN shift 5\n"+
"36 SLASH reduce 26\n"+
"7 PRINTLN reduce 7\n"+
"36 GE reduce 26\n"+
"2 EQ reduce 24\n"+
"6 MINUS reduce 17\n"+
"51 GT reduce 19\n"+
"74 RPAREN reduce 12\n"+
"60 NUM shift 17\n"+
"66 RETURN reduce 2\n"+
"36 PLUS reduce 26\n"+
"3 ID reduce 6\n"+
"41 factor shift 80\n"+
"22 EQ reduce 22\n"+
"25 term shift 6\n"+
"21 RETURN reduce 3\n"+
"52 RPAREN reduce 18\n"+
"47 RETURN reduce 10\n"+
"2 GT reduce 24\n"+
"65 PLUS reduce 23\n"+
"56 statement shift 3\n"+
"76 LPAREN shift 5\n"+
"51 PLUS reduce 19\n"+
"22 NE reduce 22\n"+
"3 IF reduce 6\n"+
"57 INT shift 81\n"+
"43 PRINTLN shift 26\n"+
"11 NUM shift 17\n"+
"64 NUM shift 17\n"+
"36 MINUS reduce 26\n"+
"17 LE reduce 25\n"+
"1 ID shift 2\n";
   
try{
  Scanner input = new Scanner(wlGrammar);
  while(input.hasNext())
  {
   String temp = input.nextLine();
   code.add(temp);
  }
  }
  catch (Exception e)
  {System.err.println("ERROR WHILE READING");}




  int num1 = Integer.parseInt(code.get(0));
  int num2 = Integer.parseInt(code.get(num1 + 1));
  int numproduction = Integer.parseInt(code.get(num1 + num2 + 3));
  int numtransition = Integer.parseInt(code.get(num1 + num2 + numproduction + 5));
  
  int keynum = 0;
  for (int i = num1 + num2 + 4; i < num1 + num2 + 4 + numproduction; i++)
  {
    String key = "" + keynum;
     keynum ++;
     production.put(key, code.get(i));
  }
  
  //transition map
  for(int i = num1 + num2 + numproduction + 6; i < num1 + num2 + numproduction + numtransition + 6; i++)
  {
    String[] breakdown = code.get(i).split("\\s");
    String key = breakdown[0] + " " + breakdown[1] + " " + breakdown[2];
    String transvalue = breakdown[3];
    transition.put(key, transvalue);
  }
  
  try {
      Scanner in = new Scanner(System.in);
      
      while(in.hasNextLine()) {
        String temp = in.nextLine();
        inputline.add(temp);
      }
    }
    catch (Exception e)
    {  System.out.println("Error while reading");
    }
    inputline.add("EOF");
  
  
  Stack<Tree> nodeStack = new Stack<Tree>();
  Stack<Object> stateStack = new Stack<Object>();
  Stack<Tree> tempNode = new Stack<Tree>();
  Tree bof = new Tree();
  bof.rule = "BOF";
  nodeStack.push(bof);
  stateStack.push(transition.get("0 BOF shift")); 
  boolean counter = true;
  for(int i =0; i <inputline.size(); i++)
  {

    String[] temps = inputline.get(i).split("\\s");
    while(transition.containsKey(stateStack.peek() + " " + temps[0] + " reduce")&& production.containsKey(transition.get(stateStack.peek() + " " + temps[0] + " reduce")))
    {
      String productionTransition = stateStack.peek() + " " + temps[0] + " reduce";
      String[] temp = production.get(transition.get(productionTransition)).split("\\s");
      for(int j = 1; j < temp.length; j++)
      {
        tempNode.push(nodeStack.pop());
        stateStack.pop();
      }
      Tree temptree = new Tree();
      temptree.rule = temp[0];
      List templist = new ArrayList();
      for(int x=1;x<temp.length;x++)
      {
        templist.add(tempNode.pop());
      }
      temptree.children = templist;
      nodeStack.push(temptree);
      stateStack.push(transition.get(stateStack.peek()+" "+temp[0]+" shift"));
    }
    Tree temptree2 = new Tree();
    temptree2.rule = inputline.get(i);
    nodeStack.push(temptree2);
    if(transition.containsKey(stateStack.peek()+" "+temps[0]+" shift"))
    {
      stateStack.push(transition.get(stateStack.peek() + " " + temps[0] + " shift"));
    }else
    {
      System.err.println("ERROR at " + (i+1) );
      counter= false;
      break;
    }
  }
  System.out.println("S BOF procedure EOF");

  while(!nodeStack.empty()){
        Tree currTree= (Tree)nodeStack.pop();
        printNode(currTree);
      }
}

  public static void printNode(Tree inputTree){    
    if(inputTree.rule.equals("BOF")){
      System.out.print("EOF EOF");
    }else if (inputTree.rule.equals("EOF")){
      System.out.print("BOF BOF");
    }else{
      System.out.print(inputTree.rule);
    }
    for(Tree child : inputTree.children) {
      String[] breakToken = child.rule.split("\\s");
      System.out.print(" "+breakToken[0]);
    }
    System.out.println();  
    for(Tree child : inputTree.children) {
      if (child.children!=null){
       printNode(child); 
      }
    }
  }
}
