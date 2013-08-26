import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;
import java.util.*;

public class Server2 extends UnicastRemoteObject implements SampleServer {

    // initialize (change as will for server's configuration)
    private static String ServerName = "SERVER2";
    // if arrayIndex is changed, the dispatcher's arrayIndex must also be changed for consistent purposes, otherwise malfunction could be seen
    private static int arrayIndexStart = 200;
    private static int arrayIndexEnd = 299;
    public static Map<Integer, DataRecord> newmap = new HashMap<Integer, DataRecord>();

    Server2() throws RemoteException{
	super();
    }

    // implement the remote method sum(a, b)
    public int sum(int a, int b) throws RemoteException{
	return a + b;
    }

    // implement the remote method write(objectId, value){
    public boolean write(int tranId, int objectId, int value) throws RemoteException{
	DataRecord dr = (DataRecord) newmap.get(objectId);

	dr.op_write(value);
	System.out.println("trans [" + tranId + "] | key_id = " + objectId + " writes : " + value);
	return true;
    }

    // implement the remote method read(objectId)
    public int read(int tranId, int objectId) throws RemoteException{	
	DataRecord dr = (DataRecord) newmap.get(objectId);

	int result = dr.op_read();
	System.out.println("trans [" + tranId + "] | key_id = " + objectId + " reads : " + result);

	return result;
    }

    // main
    public static void main(String argv[]){
	try{
	    // setting the security manager
//	    System.setSecurityManager(new RMISecurityManager());

	    // create a local instance of the object
	    Server2 Server = new Server2();

	    // initialize storage for hashmap
	    for(int i=arrayIndexStart; i<=arrayIndexEnd; i++){
		DataRecord data = new DataRecord(i,0);
	    	newmap.put(i, data);
	    }

	    System.out.println(ServerName);
	    Naming.rebind(ServerName, Server);

	    System.out.println(ServerName + " waiting.....");

	}catch (java.net.MalformedURLException me){
	    System.out.println("Malformed URL: " + me.toString());

	}catch (RemoteException re){
	    System.out.println("Remote exception: " + re.toString());

	}
    }
}
