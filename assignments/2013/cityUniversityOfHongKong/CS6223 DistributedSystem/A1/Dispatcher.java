import java.io.*;
import java.net.*;
import java.rmi.*;
import java.rmi.server.*;
import java.util.StringTokenizer;
import java.util.*;

/* 
Dispatcher - 1) for receiving requests from clients, 
	     2) then create a thread for each request 
	     3) and pass the operation using RMI to the appropriate server
*/

class Dispatcher {

/*-------------------- INITIALIZAING VARIABLES -----------------*/
    // modify as will
    private static int port = 6789;
    private static String backendUrl = "localhost";

    // server 1's variables
    private static String backendSerName1 = "SERVER1";
    private static int arrayIndexStart1 = 100;
    private static int arrayIndexEnd1 = 199;
    private static SampleServer Server1;

    // server 2's variables
    private static String backendSerName2 = "SERVER2";
    private static int arrayIndexStart2 = 200;
    private static int arrayIndexEnd2 = 299;
    private static SampleServer Server2;

    // transaction IDs (readTran starts from id 0, writeTran starts from id 100)
    private static int ReadTransId = 0;
    private static int WriteTransId = 100;

    // since dispatcher will reply to client if the operation is 
    // successful or not, the dispatcher needs to store a key-value 
    // pair of <transaction ID> and corresponding <client's address>
    public static Map<Integer, DataOutputStream> info = new HashMap<Integer, DataOutputStream>();


/*------------------------ HELPER FUNCTIONS ----------------------*/

    // tokenize the input from client side
    private static StringTokenizer parseString(String s){
	StringTokenizer tokens = new StringTokenizer(s);
	return tokens;
    }

    // send operation to backend server side
    private static void sendOperation(StringTokenizer s, DataOutputStream d){
	int size = s.countTokens();
	String operation = s.nextToken();

	// handle READ operation
	if(operation.toLowerCase().equals("read")){
	    int firstArgument = Integer.parseInt(s.nextToken());

	    // if objectID is in the range of Server1
	    if(arrayIndexStart1<=firstArgument && firstArgument<=arrayIndexEnd1){
		info.put(ReadTransId, d);
		ReadTran(Server1, ReadTransId, firstArgument);
		ReadTransId++;
	    // if objectID is in the range of Server2
	    }else if (arrayIndexStart2<=firstArgument && firstArgument<=arrayIndexEnd2){
		info.put(ReadTransId, d);
		ReadTran(Server2, ReadTransId, firstArgument);
		ReadTransId++;
	    // if objectID is out of range
	    }else {
		System.err.println("read object ID is not in range");
		ErrorReport(d);
	    }

	// handle WRITE operation
	}else if(operation.toLowerCase().equals("write")){
	    int firstArgument = Integer.parseInt(s.nextToken());
	    int secondArgument = Integer.parseInt(s.nextToken());

	    // if objectID is in the range of Server1
	    if(arrayIndexStart1<=firstArgument && firstArgument<=arrayIndexEnd1){
		info.put(WriteTransId, d);
		WriteTran(Server1, WriteTransId, firstArgument, secondArgument);
		WriteTransId++;
	    // if objectID is in the range of Server2
	    }else if (arrayIndexStart2<=firstArgument && firstArgument<=arrayIndexEnd2){
		info.put(WriteTransId, d);
		WriteTran(Server2, WriteTransId, firstArgument, secondArgument);
		WriteTransId++;
	    // if objectID is out of range
	    }else {
		System.err.println("write object ID is not in range");
		ErrorReport(d);
	    }
	}
    }

    // report error back to client's stream 'd'
    public static void ErrorReport(DataOutputStream d){
	try{
	    String resultSentence = "object ID is not in range" + '\n';
	    d.writeBytes(resultSentence);
	}catch(Exception e){
	    System.err.println("Error in method: ErrorReport() " + e);
	}
    }

    // send READ transaction to backend server by creating a single new thread
    public static void ReadTran(final SampleServer s, final int tranId, final int objectId){
	Thread readThread = new Thread(){
	    public void run(){
		try{
		    // run READ operation using RMI
		    int result = s.read(tranId, objectId);

		    // print output
		    String resultSentence = "Read successful: trans[" + tranId + "] | key_id = " + objectId + " reads : " + result + '\n';
		    System.out.print(resultSentence);

		    // send back to client side
		    DataOutputStream outToClient = (DataOutputStream)info.get(tranId);
		    outToClient.writeBytes(resultSentence);
		    info.remove(tranId);
		}catch (Exception e){
		    System.out.println("Error in ReadTran: " + e);
		}
	    }
	};
	readThread.start();
    }

    // send WRITE transaction to backend server by creating a single new thread
    public static void WriteTran(final SampleServer s, final int tranId, final int objectId, final int value){
	Thread writeThread = new Thread(){
	    public void run(){
		try{
		    // run WRITE operation using RMI
		    boolean result = s.write(tranId, objectId, value);

		    // print output
		    String resultSentence = "Write successful: trans[" + tranId + "] | key_id = " + objectId + " writes : " + value + '\n';
		    System.out.print(resultSentence);

		    // send back to client side
		    DataOutputStream outToClient = (DataOutputStream)info.get(tranId);

		    outToClient.writeBytes(resultSentence);
		    info.remove(tranId);

		}catch (Exception e){
		    System.out.println("Error in WriteTran: " + e);
		    System.exit(1);
		}
	    }
	};
	writeThread.start();
    }

/* ---------------------------------------------------------*/

    // main
    public static void main(String argv[]) throws Exception {
	String clientSentence;
	String capitalizedSentence;

	// set the security manager and RMI to backend
//	System.setSecurityManager(new RMISecurityManager());
	try {
	    System.out.println("Security Manager loaded at Dispatcher");

	    // try to bind to server1
	    String url1 = "//" + backendUrl + "/" + backendSerName1;
	    Server1 = (SampleServer)Naming.lookup(url1);
	    System.out.println("Got remote object: " + backendSerName1);

	    // try to bind to server2
	    String url2 = "//" + backendUrl + "/" + backendSerName2;
	    Server2 = (SampleServer)Naming.lookup(url2);
	    System.out.println("Got remote object: " + backendSerName2);

	}catch (RemoteException exc){
	    System.out.println("Error in lookup: " + exc.toString());
	}catch (java.net.MalformedURLException exc){
	    System.out.println("Malformed URL: " + exc.toString());
	}catch (java.rmi.NotBoundException exc){
	    System.out.println("NotBound: " + exc.toString());
	}
	

	// create socket and receive input from client
	ServerSocket welcomeSocket = new ServerSocket(port);

	// handle inputs from clients and pass it to servers
	while(true){
	    Socket connectionSocket = welcomeSocket.accept();

	    BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));

	    DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());

	    clientSentence = inFromClient.readLine();

	    // handle null character cases
	    if(!(clientSentence == null)){

	   	System.out.println(clientSentence);

		sendOperation(parseString(clientSentence), outToClient);
	    }
	}
    }
}
