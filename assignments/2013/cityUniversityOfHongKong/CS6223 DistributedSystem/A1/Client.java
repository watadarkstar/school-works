import java.io.*;
import java.net.*;
import java.util.StringTokenizer;

class Client {

/* -------------------- HELPER FUNCTIONS ---------------------*/
    // set Dispatcher's IP address (localhost in this case)
    private static String IPAddress= "localhost";

    // print an error message
    private static void printErrorMessage(){
	System.out.println("Invalid operation! " +
	"Expecting: [read ObjectId]/[write ObjectId Value]");
    }
    
    // string tokenizer
    private static StringTokenizer parseString(String s){
	StringTokenizer tokens = new StringTokenizer(s);
	return tokens;
    }

    // check if the input is a number
    private static boolean isInteger(String s){
	try{
	    Integer.parseInt(s);
	}catch(NumberFormatException e){
	    return false;
	}
	return true;
    }

    // check if the input is correct
    private static boolean checkInput(StringTokenizer s){
	int size = s.countTokens();
	if(size == 0) return false;
	String operation = s.nextToken();
	if(operation.toLowerCase().equals("read") && size == 2){
	    if(isInteger(s.nextToken())){
		return true;
	    }
	}else if(operation.toLowerCase().equals("write") && size == 3){
	    if(isInteger(s.nextToken()) && isInteger(s.nextToken())){
		return true;
	    }
	}
	return false;
    }

/* ------------------------------------------------------*/

    // main
    // connect to the dispatcher and send validated operations
    public static void main(String argv[]) throws Exception {

	while(true){
	    // initializing 
	    String sentence;
	    String modifiedSentence;
	    BufferedReader inFromUser;
	    Socket clientSocket;
	    DataOutputStream outToServer;
	    BufferedReader inFromServer;

	    // create a socket to Dispatcher
	    clientSocket = new Socket(IPAddress, 6789);
	    System.out.print("Please insert operation: ");

	    // read input from std input
	    inFromUser = new BufferedReader(new InputStreamReader(System.in));
	    sentence = inFromUser.readLine();

	    // exit
	    if(sentence.toLowerCase().equals("e")){
		System.out.println("Connection to dispatcher is closed");
		clientSocket.close();
		break;	// press E to terminate communication

	    // error handling
	    }else if(checkInput(parseString(sentence)) == false){
		printErrorMessage();

	    // correct input, ready to send
	    }else{
		// send request to Dispatcher
		outToServer = new DataOutputStream(clientSocket.getOutputStream());
		outToServer.writeBytes(sentence + '\n');

		// receive respond from Dispatcher
		inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		modifiedSentence = inFromServer.readLine();
		System.out.println("FROM DISPATCHER: " + modifiedSentence);
	    }
	    clientSocket.close();
	}
    }
}		
